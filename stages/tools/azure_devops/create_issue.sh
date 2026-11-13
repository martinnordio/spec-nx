#!/usr/bin/env bash
# Create an Azure DevOps backlog item (work item) whose description is a spec summary (in the
# spec-summary block, stored as Markdown), optionally under a parent work item. Prints its id.
# usage: create_issue.sh <title> <summary-file> [--type <work item type>] [--parent <id>] [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"
. "$here/ado.sh"

usage='usage: create_issue.sh <title> <summary-file> [--type <work item type>] [--parent <id>] [--dry-run]'
title="${1:?$usage}"
summary_file="${2:?$usage}"
shift 2
type='Product Backlog Item' parent='' dry_run=''
while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) type="$2"; shift 2 ;;
    --parent) parent="$2"; shift 2 ;;
    --dry-run) dry_run=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

ado_repo
body="$(set_spec_summary '' "$(cat "$summary_file")")"
parent_json='null'
if [[ -n "$parent" ]]; then
  parent_json="$(ado GET "$ADO_BASE/_apis/wit/workitems/$parent?fields=System.Title&api-version=7.1")"
fi
if [[ -n "$dry_run" ]]; then
  under=''
  [[ -n "$parent" ]] && under=" under $parent '$(jq -r '.fields["System.Title"]' <<< "$parent_json")'"
  printf "Would create %s '%s'%s with:\n%s\n" "$type" "$title" "$under" "$body"
  exit 0
fi
patch="$(jq -n --arg t "$title" --arg d "$body" --argjson p "$parent_json" '[
  {op: "add", path: "/fields/System.Title", value: $t},
  {op: "add", path: "/multilineFieldsFormat/System.Description", value: "Markdown"},
  {op: "add", path: "/fields/System.Description", value: $d}]
  + (if $p == null then [] else [{op: "add", path: "/relations/-",
       value: {rel: "System.LinkTypes.Hierarchy-Reverse", url: $p.url}}] end)')"
type_path="$(jq -rn --arg t "$type" '$t | @uri')"
ado POST "$ADO_BASE/_apis/wit/workitems/\$$type_path?api-version=7.1" "$patch" 'application/json-patch+json' | jq -r .id
