#!/usr/bin/env bash
# Rebuild .specs/costs.md (tokens and cost of every spec) from the Stage logs of the specs.
# usage: costs_ledger.sh [--root <dir>] [--costs-link <path from .specs/ to COSTS.md>] [--dry-run]
set -euo pipefail
command -v python3 >/dev/null || { echo "costs_ledger.sh needs python3" >&2; exit 1; }
# The kit's, the project's and the developer's settings, the later winning (settings.sh).
root=.
for ((i = 1; i <= $#; i++)); do
  case "${!i}" in --root) j=$((i + 1)); root="${!j}" ;; --root=*) root="${!i#--root=}" ;; esac
done
SPEC_NX_SETTINGS="$(bash "$(dirname "$0")/settings.sh" --root "$root" --json)" || exit 1
export SPEC_NX_SETTINGS
exec python3 - "$@" <<'PY'
import argparse, datetime, glob, json, os, re, sys

sys.stdout.reconfigure(encoding="utf-8")
p = argparse.ArgumentParser(prog="costs_ledger.sh")
p.add_argument("--root", default=".")
p.add_argument("--costs-link")
p.add_argument("--dry-run", action="store_true")
a = p.parse_args()


settings = json.loads(os.environ.get("SPEC_NX_SETTINGS") or "{}")
if not isinstance(settings.get("cost"), dict):
    print("Cost tracking is off: no cost block in the settings (.specs/spec-nx.json).")
    sys.exit(0)
cost = settings["cost"]
if not cost.get("enabled", True):
    print("Cost tracking is off: cost.enabled is false.")
    sys.exit(0)

link = a.costs_link
if not link and os.path.exists(os.path.join(a.root, "stages", "COSTS.md")):
    link = "../stages/COSTS.md"
if not link:
    kit = (settings.get("kit_dir") or ".specs/kit").rstrip("/")
    if kit.startswith(".specs/"):
        link = kit[len(".specs/"):] + "/COSTS.md"
    elif kit in (".", ""):
        link = "../COSTS.md"
    else:
        link = "../" + re.sub(r"^\./", "", kit) + "/COSTS.md"

TOKENS = re.compile(r"([0-9][0-9,]*(?:\.[0-9]+)?)\s*([kM])")
MONEY = re.compile(r"([A-Z]{3})\s*([0-9]+(?:\.[0-9]+)?)")
CREDITS = re.compile(r"([0-9][0-9,]*(?:\.[0-9]+)?)\s*credits?")


def credit_text(n):
    return "%s %s" % (round(n), "credit" if round(n) == 1 else "credits")


def tokens(cell):
    m = TOKENS.search(cell)
    if not m:
        return None
    return float(m.group(1).replace(",", "")) * (1e6 if m.group(2) == "M" else 1e3)


def add(into, frm):
    # A cell is [tokens, amount, credits, estimated, measured, included].
    for i in range(3):
        into[i] += frm[i]
    for i in range(3, 6):
        into[i] = into[i] or frm[i]


def stage_of(stage):
    return stage if stage in ("requirements", "plan", "implementation", "review", "pr") else "other"


specs = []
files = glob.glob(os.path.join(a.root, ".specs", "features", "*_spec.md"))
files += glob.glob(os.path.join(a.root, ".specs", "features", "done", "*_spec.md"))
for path in sorted(files, key=lambda f: os.path.basename(f)):
    with open(path, encoding="utf-8") as f:
        lines = f.read().splitlines()
    title = next((l[2:].strip() for l in lines if l.startswith("# ")), os.path.basename(path))
    title = re.sub(r"\s+Spec$", "", title)
    status = next((l.split("**Status:**", 1)[1].strip() for l in lines if "**Status:**" in l), "")
    status = status.split(" \u2014 ")[0]
    spec = {"title": title, "status": status,
            "path": os.path.relpath(path, os.path.join(a.root, ".specs")).replace(os.sep, "/"),
            "stages": {}, "steps": [], "tracked": False}
    head = None
    for line in lines:
        if line.startswith("| Date | Stage |"):
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            head = {c.split(" ")[0]: i for i, c in enumerate(cells)}
            if "Tokens" not in head or "Cost" not in head:
                head = None
            continue
        if head is None:
            continue
        if not line.startswith("|"):
            head = None
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) <= max(head.values()) or set(cells[0]) <= set("-: "):
            continue
        key = stage_of(cells[head["Stage"]])
        # A row whose numbers are counted in another spec ("included in <spec>", COSTS.md).
        if cells[head["Tokens"]].startswith("included in") or cells[head["Cost"]].startswith("included in"):
            spec["tracked"] = True
            spec["stages"].setdefault(key, [0.0, 0.0, 0.0, False, False, False])[5] = True
            continue
        n = tokens(cells[head["Tokens"]])
        if n is None:
            continue
        estimated = cells[head["Tokens"]].startswith("~") or cells[head["Cost"]].startswith("~")
        money = MONEY.search(cells[head["Cost"]])
        cr = CREDITS.search(cells[head["Cost"]])
        value = float(money.group(2)) if money else 0.0
        credits = float(cr.group(1).replace(",", "")) if cr else 0.0
        currency = money.group(1) if money else cost.get("currency", "USD")
        spec["tracked"] = True
        add(spec["stages"].setdefault(key, [0.0, 0.0, 0.0, False, False, False]),
            [n, value, credits, estimated, not estimated, False])
        step = re.search(r"Step (\d+)", cells[head["Note"]]) if "Note" in head else None
        if step and cells[head["Stage"]] == "implementation":
            spec["steps"].append((step.group(1), n, value, credits, currency,
                                  cells[head["Model"]] if "Model" in head else "", estimated))
    specs.append(spec)

currency = cost.get("currency", "USD")
dot = " \u00b7 "


def k(n):
    return "%.2f M" % (n / 1e6) if n >= 1e6 else "{:,} k".format(round(n / 1000))


def cell(v):
    if v is None:
        return "N/A"
    if not v[3] and not v[4]:
        return "included" if v[5] else "N/A"
    tilde = "~" if v[3] else ""
    return "%s%s%s%s%s %.2f" % (tilde, k(v[0]), dot, tilde, currency, round(v[1], 2))


def total(spec):
    if not spec["tracked"]:
        return None
    t = [0.0, 0.0, 0.0, False, False, False]
    for s in spec["stages"].values():
        add(t, s)
    return t


rows, grand = [], [0.0, 0.0, 0.0, False, False, False]
for spec in specs:
    t = total(spec)
    if t:
        add(grand, t)
        parts = [cell(spec["stages"][x]) if x in spec["stages"] else "\u2014"
                 for x in ("requirements", "plan", "implementation", "review", "pr", "other")]
    else:
        parts = ["N/A"] * 6
    rows.append("| [%s](%s) | %s | %s | %s |" % (spec["title"], spec["path"], spec["status"], " | ".join(parts), cell(t)))

out = ["# Cost of the specs", "",
       "> Estimate \u2014 see [COSTS.md](%s). **All costs are estimates and may be wrong.** Rebuilt by" % link,
       "> `costs_ledger` from the Stage logs on %s; do not edit by hand." % datetime.date.today().isoformat(), "",
       "**All specs: %s (%s)**" % (cell(grand), credit_text(grand[2])), "",
       "| Spec | Status | Requirements | Plan | Implementation | Review | PR | Other | Total |",
       "|------|--------|--------------|------|----------------|--------|----|-------|-------|"]
out += rows
out.append("| **All specs** | | | | | | | | **%s** |" % cell(grand))
if grand[3] and grand[4]:
    out += ["", "> This list mixes measured and estimated (`~`) numbers; they come from different methods \u2014 see [COSTS.md](%s)." % link]
steps = [(s, st) for s in specs for st in s["steps"]]
if steps:
    out += ["", "## Implementation by Step", "", "| Spec | Step | Model | Tokens | Cost |", "|------|------|-------|--------|------|"]
    for s, (n, tok, val, cr, cur, model, est) in steps:
        tilde = "~" if est else ""
        out.append("| %s | %s | %s | %s%s | %s%s %.2f (%s) |" % (s["title"], n, model, tilde, k(tok), tilde, cur, round(val, 2), credit_text(cr)))
text = "\n".join(out) + "\n"
if a.dry_run:
    print(text, end="")
    sys.exit(0)
with open(os.path.join(a.root, ".specs", "costs.md"), "w", encoding="utf-8", newline="\n") as f:
    f.write(text)
print("Wrote .specs/costs.md: %d specs, %s" % (len(specs), cell(grand)))
PY
