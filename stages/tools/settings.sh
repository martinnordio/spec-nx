#!/usr/bin/env bash
# The settings of spec-nx in three layers: the kit's (<kit>/.specs/spec-nx.json, when the kit
# is a repository of its own, e.g. a submodule), the project's (.specs/spec-nx.json) and the
# developer's (.specs/spec-nx.local.json). A later layer wins: a key replaces the same key,
# objects are merged key by key, lists are replaced as a whole, null removes the key. Keys that
# describe the generated kit are taken from the project's file only. Needs python3.
# usage: settings.sh [--root <dir>] [--get <key.sub>] [--json] [--sources]
#   (no option: every setting with the file it comes from)
set -euo pipefail
command -v python3 >/dev/null || { echo "settings.sh needs python3" >&2; exit 1; }
SPEC_NX_KIT="$(cd "$(dirname "$0")/.." && pwd)" exec python3 - "$@" <<'PY'
import argparse, json, os, sys

sys.stdout.reconfigure(encoding="utf-8")
p = argparse.ArgumentParser(prog="settings.sh")
p.add_argument("--root", default=".")
p.add_argument("--get")
p.add_argument("--json", action="store_true")
p.add_argument("--sources", action="store_true")
a = p.parse_args()

PROJECT_ONLY = ["version", "spec_nx_version", "generated", "kit", "kit_dir", "kit_ref", "kit_files", "shells"]


def read(path):
    if not path or not os.path.exists(path):
        return None
    with open(path, encoding="utf-8-sig") as f:
        text = f.read()
    if not text.strip():
        return {}
    try:
        return json.loads(text)
    except ValueError as e:
        sys.exit("%s is not valid JSON: %s" % (path, e))


def merge(into, frm, file, sources, prefix):
    for key, value in frm.items():
        path = prefix + "." + key if prefix else key
        if value is None:
            into.pop(key, None)
            for s in [s for s in sources if s == path or s.startswith(path + ".")]:
                del sources[s]
            sources[path] = file + " (removed)"
            continue
        if isinstance(value, dict) and isinstance(into.get(key), dict):
            merge(into[key], value, file, sources, path)
            continue
        for s in [s for s in sources if s.startswith(path + ".")]:
            del sources[s]
        into[key] = value
        if isinstance(value, dict):
            for k in value:
                sources[path + "." + k] = file
        else:
            sources[path] = file


root = os.path.abspath(a.root)
project_file = os.path.join(root, ".specs", "spec-nx.json")
local_file = os.path.join(root, ".specs", "spec-nx.local.json")
kit_file = os.path.join(os.environ.get("SPEC_NX_KIT", ""), ".specs", "spec-nx.json")
if os.path.exists(kit_file) and os.path.exists(project_file) and os.path.samefile(kit_file, project_file):
    kit_file = None

project = read(project_file)
personal = isinstance(project, dict) and project.get("kit") == "personal"
values, sources, warnings = {}, {}, []
for name, file, data in (("kit", kit_file, read(kit_file)), ("project", project_file, project), ("developer", local_file, read(local_file))):
    if data is None:
        continue
    keep = {}
    for k, v in data.items():
        only = k in PROJECT_ONLY or (k == "model" and not personal)
        if only and name != "project":
            if name == "developer" and k != "version":
                warnings.append("'%s' in %s is ignored: it describes the generated kit and is set only in %s." % (k, file, project_file))
            continue
        keep[k] = v
    merge(values, keep, file, sources, "")

for w in warnings:
    print("warning: " + w, file=sys.stderr)


def get(key):
    v = values
    for part in key.split("."):
        if isinstance(v, dict) and part in v:
            v = v[part]
        else:
            return None
    return v


if a.get:
    v = get(a.get)
    if v is not None:
        print(json.dumps(v, ensure_ascii=False, separators=(",", ":")) if isinstance(v, (dict, list)) else ("true" if v is True else "false" if v is False else v))
elif a.json:
    print(json.dumps(values, ensure_ascii=False, indent=2))
elif a.sources:
    print(json.dumps({"values": values, "sources": sources, "warnings": warnings}, ensure_ascii=False))
else:
    for key, file in sources.items():
        v = get(key)
        text = "(removed)" if v is None else "[" + ", ".join(str(x) for x in v) + "]" if isinstance(v, list) else ("true" if v is True else "false" if v is False else str(v))
        bare = file.replace(" (removed)", "")
        try:
            shown = os.path.relpath(bare, root)
        except ValueError:
            shown = bare
        print("%s = %s   (%s)" % (key, text, shown + (" (removed)" if file.endswith(" (removed)") else "")))
PY
