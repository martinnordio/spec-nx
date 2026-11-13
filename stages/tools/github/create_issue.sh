#!/usr/bin/env bash
# Create a GitHub issue whose description is a spec summary (in the spec-summary block), and
# optionally make it a sub-issue of a parent issue. Prints the new issue number.
# usage: create_issue.sh <title> <summary-file> [--parent <n>] [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"

usage='usage: create_issue.sh <title> <summary-file> [--parent <n>] [--dry-run]'
title="${1:?$usage}"
summary_file="${2:?$usage}"
shift 2
parent='' dry_run=''
while [[ $# -gt 0 ]]; do
  case "$1" in
    --parent) parent="$2"; shift 2 ;;
    --dry-run) dry_run=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

body="$(set_spec_summary '' "$(cat "$summary_file")")"
if [[ -n "$parent" ]]; then
  gh issue view "$parent" --json number > /dev/null
fi
if [[ -n "$dry_run" ]]; then
  printf "Would create issue '%s'%s with:\n%s\n" "$title" "${parent:+ as a sub-issue of #$parent}" "$body"
  exit 0
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
printf '%s\n' "$body" > "$tmp"
url="$(gh issue create --title "$title" --body-file "$tmp")"
number="${url##*/}"
if [[ -n "$parent" ]]; then
  id="$(gh api "repos/{owner}/{repo}/issues/$number" --jq .id)"
  gh api -X POST "repos/{owner}/{repo}/issues/$parent/sub_issues" -F "sub_issue_id=$id" > /dev/null ||
    { echo "Created issue #$number, but could not add it under #$parent." >&2; exit 1; }
fi
echo "$number"
