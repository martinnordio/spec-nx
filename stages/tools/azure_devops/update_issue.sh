#!/usr/bin/env bash
# Put a spec summary into the spec-summary block of an Azure DevOps backlog item (work item)
# description; text outside the block is kept. The description is stored as Markdown.
# usage: update_issue.sh <work-item-id> <summary-file> [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"
. "$here/ado.sh"

usage='usage: update_issue.sh <work-item-id> <summary-file> [--dry-run]'
issue="${1:?$usage}"
summary_file="${2:?$usage}"
dry_run="${3:-}"

ado_items
uri="$ADO_ITEMS/_apis/wit/workitems/$issue?api-version=7.1"
body="$(ado GET "$uri&fields=System.Description" | jq -r '.fields["System.Description"] // ""')"
new="$(set_spec_summary "$body" "$(cat "$summary_file")")"

if [[ "$dry_run" == "--dry-run" ]]; then
  printf 'Would update backlog item %s to:\n%s\n' "$issue" "$new"
  exit 0
fi
patch="$(jq -n --arg d "$new" '[
  {op: "add", path: "/multilineFieldsFormat/System.Description", value: "Markdown"},
  {op: "add", path: "/fields/System.Description", value: $d}]')"
ado PATCH "$uri" "$patch" 'application/json-patch+json' > /dev/null
echo "Updated backlog item $issue."
