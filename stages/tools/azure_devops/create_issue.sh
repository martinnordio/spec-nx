#!/usr/bin/env bash
# Create an Azure DevOps backlog item (work item) whose description is a spec summary (in the
# spec-summary block, stored as Markdown), optionally under a parent work item. Area path,
# iteration path and the person it is assigned to come from the options or the settings
# (work_items.area, .iteration, .assigned_to); by default it is assigned to the signed-in user,
# and work_items.assigned_to = null leaves it unassigned. Every field is checked before the
# item is created; the dry run lists them with where they come from. Prints the new id.
# usage: create_issue.sh <title> <summary-file> [--type <work item type>] [--parent <id>]
#        [--area <path>] [--iteration <path>] [--assigned-to <email>] [--unassigned] [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"
. "$here/ado.sh"

usage='usage: create_issue.sh <title> <summary-file> [--type <work item type>] [--parent <id>] [--area <path>] [--iteration <path>] [--assigned-to <email>] [--unassigned] [--dry-run]'
title="${1:?$usage}"
summary_file="${2:?$usage}"
shift 2
type='Product Backlog Item' parent='' dry_run='' area='' iteration='' assigned='' unassigned=''
while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) type="$2"; shift 2 ;;
    --parent) parent="$2"; shift 2 ;;
    --area) area="$2"; shift 2 ;;
    --iteration) iteration="$2"; shift 2 ;;
    --assigned-to) assigned="$2"; shift 2 ;;
    --unassigned) unassigned=1; shift ;;
    --dry-run) dry_run=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

ado_items
org="$(cut -d/ -f4 <<< "$ADO_ITEMS")"
project="$(cut -d/ -f5 <<< "$ADO_ITEMS")"
project="$(printf '%b' "${project//%/\\x}")"
settings_root="$(git rev-parse --show-toplevel)"
setting_source() { bash "$here/../settings.sh" --root "$settings_root" --source "$1"; }

# field <option value> <key>  ->  sets FIELD_VALUE and FIELD_FROM
field() {
  FIELD_VALUE='' FIELD_FROM=''
  if [[ -n "$1" ]]; then FIELD_VALUE="$1" FIELD_FROM='option'; return; fi
  FIELD_VALUE="$(ado_setting "$2")"
  FIELD_FROM="$(setting_source "$2")"
  [[ -n "$FIELD_VALUE" ]] && FIELD_FROM="$2 in $FIELD_FROM"
  return 0
}

# check_path <area|iteration> <path> <from>  ->  prints the full path, or fails
check_path() {
  local kind="$1" path="$2" from="$3" rel nodes url
  rel="${path#[\\/]}"
  if [[ "$rel" == "$project" ]]; then rel=''
  elif [[ "$rel" == "$project\\"* || "$rel" == "$project/"* ]]; then rel="${rel:${#project}+1}"; fi
  rel="${rel//\\//}"
  nodes=areas; [[ "$kind" == iteration ]] && nodes=iterations
  url="$ADO_ITEMS/_apis/wit/classificationnodes/$nodes/$(jq -rn --arg v "$rel" '$v | split("/") | map(@uri) | join("/")')?api-version=7.1"
  if ! ado GET "$url" > /dev/null 2>&1; then
    echo "The $kind '$path' ($from) is not an $kind path of the project '$project'." >&2
    return 1
  fi
  if [[ -n "$rel" ]]; then printf '%s\\%s\n' "$project" "${rel//\//\\}"; else printf '%s\n' "$project"; fi
}

field "$area" work_items.area; area_value="$FIELD_VALUE" area_from="$FIELD_FROM"
[[ -n "$area_value" ]] && area_value="$(check_path area "$area_value" "$area_from")"
field "$iteration" work_items.iteration; iteration_value="$FIELD_VALUE" iteration_from="$FIELD_FROM"
[[ -n "$iteration_value" ]] && iteration_value="$(check_path iteration "$iteration_value" "$iteration_from")"

field "$assigned" work_items.assigned_to; assigned_value="$FIELD_VALUE" assigned_from="$FIELD_FROM"
if [[ -n "$unassigned" ]]; then
  assigned_value='' assigned_from='option --unassigned'
elif [[ -z "$assigned_value" && "$assigned_from" == *' (removed)' ]]; then
  assigned_from="work_items.assigned_to = null in ${assigned_from% (removed)}"
elif [[ -z "$assigned_value" ]]; then
  assigned_value="$(ado GET "https://dev.azure.com/$org/_apis/connectionData?api-version=7.1-preview" | jq -r '.authenticatedUser.properties.Account["$value"] // empty')"
  [[ -n "$assigned_value" ]] || { echo 'Could not find the signed-in user; set work_items.assigned_to, or null to leave the item unassigned.' >&2; exit 1; }
  assigned_from='default: you, the signed-in user'
else
  count="$(ado GET "https://vssps.dev.azure.com/$org/_apis/identities?searchFilter=General&filterValue=$(jq -rn --arg v "$assigned_value" '$v | @uri')&api-version=7.1" | jq -r '.count // 0')"
  [[ "$count" -ge 1 ]] || { echo "The person '$assigned_value' ($assigned_from) is not a user of the organisation '$org'." >&2; exit 1; }
fi

body="$(set_spec_summary '' "$(cat "$summary_file")")"
parent_json='null'
if [[ -n "$parent" ]]; then
  parent_json="$(ado GET "$ADO_ITEMS/_apis/wit/workitems/$parent?fields=System.Title&api-version=7.1")" ||
    { echo "The parent $parent is not a work item of $ADO_ITEMS." >&2; exit 1; }
fi
if [[ -n "$dry_run" ]]; then
  show() { if [[ -n "$1" ]]; then printf '%s   (%s)' "$1" "$2"; else printf -- '-   (%s)' "${2:-not set: the project default}"; fi; }
  printf "Would create %s '%s' in %s with:\n" "$type" "$title" "$ADO_ITEMS"
  if [[ -n "$parent" ]]; then printf "  Parent:      %s '%s'\n" "$parent" "$(jq -r '.fields["System.Title"]' <<< "$parent_json")"; else echo '  Parent:      -'; fi
  printf '  Area:        %s\n' "$(show "$area_value" "$area_from")"
  printf '  Iteration:   %s\n' "$(show "$iteration_value" "$iteration_from")"
  printf '  Assigned to: %s\n' "$(show "$assigned_value" "$assigned_from")"
  printf 'Description:\n%s\n' "$body"
  exit 0
fi
patch="$(jq -n --arg t "$title" --arg d "$body" --argjson p "$parent_json" \
  --arg area "$area_value" --arg it "$iteration_value" --arg who "$assigned_value" '[
  {op: "add", path: "/fields/System.Title", value: $t},
  {op: "add", path: "/multilineFieldsFormat/System.Description", value: "Markdown"},
  {op: "add", path: "/fields/System.Description", value: $d}]
  + (if $area == "" then [] else [{op: "add", path: "/fields/System.AreaPath", value: $area}] end)
  + (if $it == "" then [] else [{op: "add", path: "/fields/System.IterationPath", value: $it}] end)
  + (if $who == "" then [] else [{op: "add", path: "/fields/System.AssignedTo", value: $who}] end)
  + (if $p == null then [] else [{op: "add", path: "/relations/-",
       value: {rel: "System.LinkTypes.Hierarchy-Reverse", url: $p.url}}] end)')"
type_path="$(jq -rn --arg t "$type" '$t | @uri')"
ado POST "$ADO_ITEMS/_apis/wit/workitems/\$$type_path?api-version=7.1" "$patch" 'application/json-patch+json' | jq -r .id
