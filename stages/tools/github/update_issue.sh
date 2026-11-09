#!/usr/bin/env bash
# Put a spec summary into the spec-summary block of a GitHub issue; text outside the block is kept.
# usage: update_issue.sh <issue> <summary-file> [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"

usage='usage: update_issue.sh <issue> <summary-file> [--dry-run]'
issue="${1:?$usage}"
summary_file="${2:?$usage}"
dry_run="${3:-}"

body="$(gh issue view "$issue" --json body -q .body)"
new="$(set_spec_summary "$body" "$(cat "$summary_file")")"

if [[ "$dry_run" == "--dry-run" ]]; then
  printf 'Would update issue #%s to:\n%s\n' "$issue" "$new"
  exit 0
fi
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
printf '%s\n' "$new" > "$tmp"
gh issue edit "$issue" --body-file "$tmp"
