#!/usr/bin/env bash
# Put a spec summary into the spec-summary block of the GitHub pull request of the current
# branch; creates the pull request if there is none (needs --title). Text outside the block is kept.
# usage: update_pr.sh <summary-file> [--title <title>] [--issue <n>] [--draft] [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"

summary_file="${1:?usage: update_pr.sh <summary-file> [--title <title>] [--issue <n>] [--draft] [--dry-run]}"
shift
title='' issue='' draft='' dry_run=''
while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) title="$2"; shift 2 ;;
    --issue) issue="$2"; shift 2 ;;
    --draft) draft=1; shift ;;
    --dry-run) dry_run=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

branch="$(git branch --show-current)"
[[ -n "$branch" ]] || { echo 'Not on a branch.' >&2; exit 1; }
summary="$(cat "$summary_file")"
number="$(gh pr list --head "$branch" --state open --json number --jq '.[0].number')"

if [[ -n "$number" ]]; then
  new="$(set_spec_summary "$(gh pr view "$number" --json body -q .body)" "$summary")"
  if [[ -n "$dry_run" ]]; then
    printf 'Would update pull request #%s to:\n%s\n' "$number" "$new"
    exit 0
  fi
  command=(pr edit "$number")
else
  [[ -n "$title" ]] || { echo "No open pull request for '$branch' yet: pass --title to create one." >&2; exit 1; }
  new="$(set_spec_summary "${issue:+Closes #$issue}" "$summary")"
  if [[ -n "$dry_run" ]]; then
    printf "Would create a %spull request '%s' from '%s' with:\n%s\n" "${draft:+draft }" "$title" "$branch" "$new"
    exit 0
  fi
  [[ -n "$(git ls-remote --heads origin "$branch")" ]] || { echo "Push the branch first: git push -u origin $branch" >&2; exit 1; }
  command=(pr create --head "$branch" --title "$title")
  [[ -n "$draft" ]] && command+=(--draft)
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
printf '%s\n' "$new" > "$tmp"
gh "${command[@]}" --body-file "$tmp"
