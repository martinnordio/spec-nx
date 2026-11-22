#!/usr/bin/env bash
# Create a GitHub issue whose description is a spec summary (in the spec-summary block), and
# optionally make it a sub-issue of a parent issue. Its type and the person it is assigned to
# come from the options or the settings (work_items.type, .assigned_to); by default it is
# assigned to you (@me), and work_items.assigned_to = null leaves it unassigned. Every field is
# checked before the issue is created; the dry run lists them with where they come from.
# Prints the new issue number. Needs gh and python3 (for the settings, ../settings.sh).
# usage: create_issue.sh <title> <summary-file> [--parent <n>] [--type <type>]
#        [--assigned-to <login>] [--unassigned] [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"

usage='usage: create_issue.sh <title> <summary-file> [--parent <n>] [--type <type>] [--assigned-to <login>] [--unassigned] [--dry-run]'
title="${1:?$usage}"
summary_file="${2:?$usage}"
shift 2
parent='' dry_run='' type='' assigned='' unassigned=''
while [[ $# -gt 0 ]]; do
  case "$1" in
    --parent) parent="$2"; shift 2 ;;
    --type) type="$2"; shift 2 ;;
    --assigned-to) assigned="$2"; shift 2 ;;
    --unassigned) unassigned=1; shift ;;
    --dry-run) dry_run=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

settings_root="$(git rev-parse --show-toplevel)"
setting() { bash "$here/../settings.sh" --root "$settings_root" "$@"; }

# field <option value> <key>  ->  sets FIELD_VALUE and FIELD_FROM
field() {
  FIELD_VALUE='' FIELD_FROM=''
  if [[ -n "$1" ]]; then FIELD_VALUE="$1" FIELD_FROM='option'; return; fi
  FIELD_VALUE="$(setting --get "$2")"
  FIELD_FROM="$(setting --source "$2")"
  [[ -n "$FIELD_VALUE" ]] && FIELD_FROM="$2 in $FIELD_FROM"
  return 0
}

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
owner="${repo%%/*}"
in_org="$(gh repo view --json isInOrganization --jq .isInOrganization)"

field "$type" work_items.type; type_value="$FIELD_VALUE" type_from="$FIELD_FROM"
if [[ -n "$type_value" ]]; then
  if [[ "$in_org" != true ]]; then
    echo "The issue type '$type_value' ($type_from) cannot be set: issue types exist only in organizations, and '$owner' is a user account." >&2
    exit 1
  fi
  types="$(gh api "orgs/$owner/issue-types" --jq '.[].name')"
  if ! grep -qxF -- "$type_value" <<< "$types"; then
    echo "The issue type '$type_value' ($type_from) is not a type of '$owner': $(paste -sd, - <<< "$types" | sed 's/,/, /g')." >&2
    exit 1
  fi
fi

field "$assigned" work_items.assigned_to; assigned_value="$FIELD_VALUE" assigned_from="$FIELD_FROM"
if [[ -n "$unassigned" ]]; then
  assigned_value='' assigned_from='option --unassigned'
elif [[ -z "$assigned_value" && "$assigned_from" == *' (removed)' ]]; then
  assigned_from="work_items.assigned_to = null in ${assigned_from% (removed)}"
elif [[ -z "$assigned_value" || "$assigned_value" == '@me' ]]; then
  [[ -z "$assigned_value" ]] && assigned_from='default: you (@me)'
  assigned_value="$(gh api user --jq .login)" ||
    { echo 'gh could not find the signed-in user; set work_items.assigned_to, or null to leave the issue unassigned.' >&2; exit 1; }
elif ! gh api "repos/$repo/assignees/$assigned_value" --silent 2> /dev/null; then
  echo "'$assigned_value' ($assigned_from) cannot be assigned issues in $repo." >&2
  exit 1
fi

body="$(set_spec_summary '' "$(cat "$summary_file")")"
parent_title=''
if [[ -n "$parent" ]]; then
  parent_title="$(gh issue view "$parent" --json title --jq .title)"
fi
if [[ -n "$dry_run" ]]; then
  printf "Would create issue '%s' in %s with:\n" "$title" "$repo"
  if [[ -n "$parent" ]]; then printf "  Parent:      #%s '%s' (as a sub-issue)\n" "$parent" "$parent_title"; else echo '  Parent:      -'; fi
  if [[ -n "$type_value" ]]; then printf '  Type:        %s   (%s)\n' "$type_value" "$type_from"; else echo '  Type:        -'; fi
  if [[ -n "$assigned_value" ]]; then printf '  Assigned to: %s   (%s)\n' "$assigned_value" "$assigned_from"; else printf -- '  Assigned to: -   (%s)\n' "$assigned_from"; fi
  printf 'Description:\n%s\n' "$body"
  exit 0
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
printf '%s\n' "$body" > "$tmp"
create=(issue create --title "$title" --body-file "$tmp")
[[ -n "$assigned_value" ]] && create+=(--assignee "$assigned_value")
url="$(gh "${create[@]}")"
number="${url##*/}"
if [[ -n "$type_value" ]]; then
  gh api -X PATCH "repos/$repo/issues/$number" -f "type=$type_value" --silent ||
    { echo "Created issue #$number, but could not set its type '$type_value'." >&2; exit 1; }
fi
if [[ -n "$parent" ]]; then
  id="$(gh api "repos/{owner}/{repo}/issues/$number" --jq .id)"
  gh api -X POST "repos/{owner}/{repo}/issues/$parent/sub_issues" -F "sub_issue_id=$id" > /dev/null ||
    { echo "Created issue #$number, but could not add it under #$parent." >&2; exit 1; }
fi
echo "$number"
