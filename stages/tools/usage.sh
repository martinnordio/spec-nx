#!/usr/bin/env bash
# Tokens and cost of a time range of the AI chat, by the method of COSTS.md.
# usage: usage.sh --since <time> --model <name> [--until <time>] [--transcript <file>]
#                 [--root <dir>] [--context-cap <tokens>] [--json]
set -euo pipefail
command -v python3 >/dev/null || { echo "usage.sh needs python3" >&2; exit 1; }
exec python3 - "$@" <<'PY'
import argparse, glob, json, os, re, sys
from datetime import datetime, timezone

sys.stdout.reconfigure(encoding="utf-8")
p = argparse.ArgumentParser(prog="usage.sh")
p.add_argument("--since", required=True)
p.add_argument("--until")
p.add_argument("--model", required=True)
p.add_argument("--transcript")
p.add_argument("--root", default=".")
p.add_argument("--context-cap", type=int, default=200000)
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


def candidates():
    home = os.path.expanduser("~")
    files = []
    for base in (os.environ.get("APPDATA", ""), os.path.join(home, ".config"),
                 os.path.join(home, "Library", "Application Support")):
        for app in ("Code", "Code - Insiders"):
            files += glob.glob(os.path.join(base, app, "User", "workspaceStorage", "*",
                                            "GitHub.copilot-chat", "transcripts", "*.jsonl"))
    slug = re.sub(r"[^A-Za-z0-9]", "-", os.path.abspath(a.root))
    files += glob.glob(os.path.join(home, ".claude", "projects", slug, "*.jsonl"))
    return files


transcript = a.transcript
if not transcript:
    found = candidates()
    if not found:
        sys.exit("No chat transcript found; pass --transcript <file>.")
    transcript = max(found, key=os.path.getmtime)

with open(transcript, encoding="utf-8") as f:
    lines = f.read().splitlines()
vscode = bool(lines) and lines[0].startswith('{"type":"session.start"')


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


t = {"requests": 0, "input": 0, "cached": 0, "output": 0}
if vscode:
    base = int(cost.get("base_tokens", 35000))
    context, previous = base, None
    for raw in lines:
        kind = raw[9:raw.find('"', 9)] if raw.startswith('{"type":"') else ""
        ts = stamp(raw)
        n = size(raw)
        inside = since <= ts < until
        if kind == "assistant.turn_start":
            if context > a.context_cap:
                context, previous = base, None
            if inside:
                cached = previous or 0
                t["requests"] += 1
                t["cached"] += cached
                t["input"] += context - cached
            previous = context
        elif kind == "assistant.message" and inside:
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


pr = prices()
credits = (t["input"] * pr["cache_write"] + t["cached"] * pr["cached"] + t["output"] * pr["output"]) / 1000000
usd = credits / 100
currency = cost.get("currency", "USD")
local_amount = usd * float(cost.get("rate", 1))
monthly = cost.get("monthly_credits")
share = credits / monthly * 100 if monthly else None
total = t["input"] + t["cached"] + t["output"]
out = {"source": "estimated" if vscode else "measured", "transcript": transcript, "model": a.model,
       **t, "total": total, "credits": round(credits, 4), "usd": round(usd, 4), "currency": currency,
       "local": round(local_amount, 4), "share_percent": round(share, 4) if share is not None else None,
       "plan": cost.get("plan")}
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
print("Source: %s from %s%s%d requests" % (out["source"], transcript, dot, t["requests"]))
PY
