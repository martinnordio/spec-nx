#!/usr/bin/env bash
# Tokens and cost of a time range of the AI chat, by the method of COSTS.md.
# usage: usage.sh --since <time> --model <name> [--until <time>] [--transcript <file>]
#                 [--root <dir>] [--context-cap <tokens>] [--json]
set -euo pipefail
command -v python3 >/dev/null || { echo "usage.sh needs python3" >&2; exit 1; }
exec python3 - "$@" <<'PY'
import argparse, glob, json, os, re, sys
from datetime import datetime, timezone
from urllib.parse import unquote

sys.stdout.reconfigure(encoding="utf-8")
p = argparse.ArgumentParser(prog="usage.sh")
p.add_argument("--since", required=True)
p.add_argument("--until")
p.add_argument("--model", required=True)
p.add_argument("--transcript")
p.add_argument("--root", default=".")
p.add_argument("--context-cap", type=int, default=200000)
p.add_argument("--agent", choices=("all", "main", "subagents"), default="all")
p.add_argument("--json", action="store_true")
a = p.parse_args()


def utc(text):
    d = datetime.fromisoformat(text.strip().replace("Z", "+00:00"))
    if d.tzinfo is None:
        d = d.astimezone()
    return d.astimezone(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3] + "Z"


def load(path):
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return {}


project = load(os.path.join(a.root, ".specs", "spec-nx.json"))
local = load(os.path.join(a.root, ".specs", "spec-nx.local.json"))
if not isinstance(project.get("cost"), dict) and not isinstance(local.get("cost"), dict):
    print("Cost tracking is off: no cost block in .specs/spec-nx.json.")
    sys.exit(0)
cost = {**(project.get("cost") or {}), **(local.get("cost") or {})}
if not cost.get("enabled", True):
    print("Cost tracking is off: cost.enabled is false.")
    sys.exit(0)

since = utc(a.since)
until = utc(a.until) if a.until else "9999"


def u16(text):
    return len(text.encode("utf-16-le")) // 2


def stamp(raw):
    i = raw.rfind('"timestamp":"')
    return raw[i + 13:raw.find('"', i + 13)] if i >= 0 else ""


def size(raw):
    s, e = raw.find('"data":'), raw.rfind(',"id":"')
    return u16(raw[s + 7:e]) // 4 if 0 <= s < e else 0


def num(raw, key):
    m = re.search('"%s":(\\d+)' % key, raw)
    return int(m.group(1)) if m else 0


def kind_of(lines):
    # A Copilot CLI log starts like a VS Code transcript but records billed usage per request.
    if any(raw.startswith('{"type":"session.usage_record"') for raw in lines):
        return "cli"
    if lines and lines[0].startswith('{"type":"session.start"'):
        return "vscode"
    return "claude"


def measure(path):
    with open(path, encoding="utf-8") as f:
        lines = f.read().splitlines()
    kind = kind_of(lines)
    t = {"kind": kind, "requests": 0, "input": 0, "cached": 0, "output": 0,
         "credits": None, "models": [], "main": None, "sub": None}
    if kind == "cli":
        nano, split, models = 0.0, {"main": 0.0, "sub": 0.0}, set()
        for raw in lines:
            if not raw.startswith('{"type":"session.usage_record"') or not since <= stamp(raw) < until:
                continue
            record = json.loads(raw)
            # Requests of sub-agents carry the sub-agent's id; the main agent's have none.
            is_sub = bool(record.get("agentId"))
            u = record["data"]["usage"]
            cu = u.get("copilotUsage") or {}
            n = float(cu["totalNanoAiu"]) if cu.get("totalNanoAiu") is not None else sum(
                float(d["tokenCount"]) * float(d["costPerBatch"]) / float(d["batchSize"])
                for d in cu.get("tokenDetails") or [])
            split["sub" if is_sub else "main"] += n
            if (a.agent == "main" and is_sub) or (a.agent == "subagents" and not is_sub):
                continue
            t["requests"] += 1
            t["input"] += int(u.get("inputTokens", 0)) - int(u.get("cacheReadTokens", 0))
            t["cached"] += int(u.get("cacheReadTokens", 0))
            t["output"] += int(u.get("outputTokens", 0))
            models.add(u.get("modelDisplayName") or u.get("model"))
            nano += n
        t.update(credits=nano / 1e9, main=split["main"] / 1e9, sub=split["sub"] / 1e9, models=sorted(models))
    elif kind == "vscode":
        base = int(cost.get("base_tokens", 35000))
        context, previous = base, None
        for raw in lines:
            k = raw[9:raw.find('"', 9)] if raw.startswith('{"type":"') else ""
            ts = stamp(raw)
            n = size(raw)
            inside = since <= ts < until
            if k == "assistant.turn_start":
                if context > a.context_cap:
                    context, previous = base, None
                if inside:
                    cached = previous or 0
                    t["requests"] += 1
                    t["cached"] += cached
                    t["input"] += context - cached
                previous = context
            elif k == "assistant.message" and inside:
                t["output"] += n
            context += n
    else:
        seen = set()
        for raw in lines:
            if '"type":"assistant"' not in raw or '"usage"' not in raw:
                continue
            if not since <= stamp(raw) < until:
                continue
            m = re.search(r'"id":"(msg_[^"]+)"', raw)
            if m:
                if m.group(1) in seen:
                    continue
                seen.add(m.group(1))
            t["requests"] += 1
            t["input"] += num(raw, "input_tokens") + num(raw, "cache_creation_input_tokens")
            t["cached"] += num(raw, "cache_read_input_tokens")
            t["output"] += num(raw, "output_tokens")
    return t


def inside_root(folder, root):
    f, r = os.path.normcase(os.path.abspath(folder)), os.path.normcase(os.path.abspath(root))
    return f == r or f.startswith(r.rstrip(os.sep) + os.sep)


def candidates(root):
    home = os.path.expanduser("~")
    files = []
    for events in glob.glob(os.path.join(home, ".copilot", "session-state", "*", "events.jsonl")):
        ws = os.path.join(os.path.dirname(events), "workspace.yaml")
        if not os.path.exists(ws):
            continue
        with open(ws, encoding="utf-8") as f:
            folders = [line.split(":", 1)[1].strip().strip("'\"") for line in f
                       if line.startswith(("cwd:", "git_root:"))]
        if any(inside_root(d, root) for d in folders):
            files.append(events)
    for base in (os.environ.get("APPDATA", ""), os.path.join(home, ".config"),
                 os.path.join(home, "Library", "Application Support")):
        for app in ("Code", "Code - Insiders"):
            for ws in glob.glob(os.path.join(base, app, "User", "workspaceStorage", "*", "workspace.json")):
                folder = (load(ws) or {}).get("folder", "")
                if not folder:
                    continue
                path = unquote(folder[7:] if folder.startswith("file://") else folder)
                if re.match(r"^/[A-Za-z]:", path):
                    path = path[1:]
                if inside_root(path, root):
                    files += glob.glob(os.path.join(os.path.dirname(ws), "GitHub.copilot-chat", "transcripts", "*.jsonl"))
    slug = re.sub(r"[^A-Za-z0-9]", "-", os.path.abspath(root))
    files += glob.glob(os.path.join(home, ".claude", "projects", slug, "*.jsonl"))
    return files


root = os.path.abspath(a.root)
tried = []
t = None
transcript = a.transcript
if transcript:
    tried.append(transcript)
    t = measure(transcript)
else:
    since_epoch = datetime.strptime(since, "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=timezone.utc).timestamp()
    for c in candidates(root):
        if os.path.getmtime(c) < since_epoch:
            continue
        tried.append(c)
        m = measure(c)
        if t is None or m["requests"] > t["requests"]:
            t, transcript = m, c
if t is None or t["requests"] == 0:
    listed = "\n".join("  " + x for x in tried) or "  (none written to since the start time)"
    sys.exit("No AI requests found between %s and %s for %s. Logs checked:\n%s\nCheck the start time, "
             "or pass --transcript <file> (Copilot CLI: ~/.copilot/session-state/<session>/events.jsonl)."
             % (since, until if a.until else "now", root, listed))
vscode = t["kind"] == "vscode"
if a.agent != "all" and t["kind"] != "cli":
    sys.exit("--agent %s needs a Copilot CLI log (only it marks the requests of sub-agents); %s is a %s log."
             % (a.agent, transcript, t["kind"]))


def prices():
    sid = os.path.splitext(os.path.basename(transcript))[0]
    models = os.path.join(os.path.dirname(os.path.dirname(transcript)), "debug-logs", sid, "models.json")
    if vscode and os.path.exists(models):
        for m in load(models):
            if a.model.lower() not in (str(m.get("name", "")).lower(), str(m.get("id", "")).lower()):
                continue
            tp = (m.get("billing") or {}).get("token_prices")
            if not tp:
                continue
            d, scale = tp["default"], 1000000 / tp.get("batch_size", 1000000)
            return {"input": d["input_price"] * scale,
                    "cache_write": d.get("cache_write_price", d["input_price"]) * scale,
                    "cached": d["cache_read_price"] * scale, "output": d["output_price"] * scale}
    for name, pr in (cost.get("prices") or {}).items():
        if name.lower() == a.model.lower():
            return {"input": pr["input"], "cache_write": pr.get("cache_write", pr["input"]),
                    "cached": pr["cached"], "output": pr["output"]}
    sys.exit('No price for "%s": add it to cost.prices in .specs/spec-nx.json.' % a.model)


if t["kind"] == "cli":
    credits = t["credits"]
else:
    pr = prices()
    credits = (t["input"] * pr["cache_write"] + t["cached"] * pr["cached"] + t["output"] * pr["output"]) / 1000000
usd = credits / 100
currency = cost.get("currency", "USD")
local_amount = usd * float(cost.get("rate", 1))
monthly = cost.get("monthly_credits")
share = credits / monthly * 100 if monthly else None
total = t["input"] + t["cached"] + t["output"]
model_text = ", ".join(t["models"]) if t["models"] else a.model
out = {"source": "estimated" if vscode else "measured", "transcript": transcript, "model": model_text,
       "requests": t["requests"], "input": t["input"], "cached": t["cached"], "output": t["output"],
       "total": total, "credits": round(credits, 4), "usd": round(usd, 4), "currency": currency,
       "local": round(local_amount, 4), "share_percent": round(share, 4) if share is not None else None,
       "plan": cost.get("plan"), "agent": a.agent,
       "main_credits": round(t["main"], 4) if t["main"] is not None else None,
       "subagent_credits": round(t["sub"], 4) if t["sub"] is not None else None}
if a.json:
    print(json.dumps(out))
    sys.exit(0)


def k(n):
    return "%.2f M" % (n / 1e6) if n >= 1e6 else "{:,} k".format(round(n / 1000))


tilde = "~" if vscode else ""
dot = " \u00b7 "
print("Tokens: %s%s (%s in%s%s cached%s%s out)" % (tilde, k(total), k(t["input"]), dot, k(t["cached"]), dot, k(t["output"])))
plan = "" if share is None else ", %.1f %% of %s" % (share, cost.get("plan", "the plan"))
print("Cost: %s%s %.2f (%s %s%s)" % (tilde, currency, round(local_amount, 2), round(credits), "credit" if round(credits) == 1 else "credits", plan))
print("Source: %s from %s%s%d requests%s%s" % (out["source"], transcript, dot, t["requests"], dot, model_text))
if t["main"] is not None:
    shown = "" if a.agent == "all" else " (counted above: %s)" % a.agent
    print("Split: main agent %d credits%ssub-agents %d credits%s" % (round(t["main"]), dot, round(t["sub"]), shown))
PY
