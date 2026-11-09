#!/usr/bin/env bash
# Put a spec summary into the spec-summary block of the Azure DevOps pull request of the current
# branch; creates the pull request if there is none (needs --title). Text outside the block is kept.
# usage: update_pr.sh <summary-file> [--title <title>] [--issue <id>] [--draft] [--dry-run]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/../spec_summary.sh"
. "$here/ado.sh"

# Azure DevOps refuses pull-request descriptions longer than this.
max_description=4000

summary_file="${1:?usage: update_pr.sh <summary-file> [--title <title>] [--issue <id>] [--draft] [--dry-run]}"
shift
title='' issue='' draft=false dry_run=''
while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) title="$2"; shift 2 ;;
    --issue) issue="$2"; shift 2 ;;
    --draft) draft=true; shift ;;
    --dry-run) dry_run=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

branch="$(git branch --show-current)"
[[ -n "$branch" ]] || { echo 'Not on a branch.' >&2; exit 1; }
summary="$(cat "$summary_file")"
ado_repo
api="$ADO_BASE/_apis/git/repositories/$ADO_REPO"
source="refs/heads/$branch"

pr="$(ado GET "$api/pullrequests?searchCriteria.sourceRefName=$source&searchCriteria.status=active&api-version=7.1" | jq -c '.value[0] // empty')"

if [[ -n "$pr" ]]; then
  id="$(jq -r .pullRequestId <<< "$pr")"
  new="$(set_spec_summary "$(jq -r '.description // ""' <<< "$pr")" "$summary")"
  target="pull request $id"
else
  [[ -n "$title" ]] || { echo "No active pull request for '$branch' yet: pass --title to create one." >&2; exit 1; }
  new="$(set_spec_summary '' "$summary")"
  target="a new $([[ $draft == true ]] && echo 'draft ')pull request '$title' from '$branch'"
fi
if (( ${#new} > max_description )); then
  echo "The description has ${#new} characters; Azure DevOps allows $max_description. Shorten the summary." >&2
  exit 1
fi

if [[ -n "$dry_run" ]]; then
  printf 'Would write %s:\n%s\n' "$target" "$new"
  exit 0
fi
if [[ -n "$pr" ]]; then
  ado PATCH "$api/pullrequests/$id?api-version=7.1" "$(jq -n --arg d "$new" '{description: $d}')" > /dev/null
  echo "Updated $target."
else
  default_branch="$(ado GET "$api?api-version=7.1" | jq -r .defaultBranch)"
  create="$(jq -n --arg s "$source" --arg t "$default_branch" --arg title "$title" --arg d "$new" \
    --argjson draft "$draft" --arg issue "$issue" \
    '{sourceRefName: $s, targetRefName: $t, title: $title, description: $d, isDraft: $draft}
     + (if $issue == "" then {} else {workItemRefs: [{id: $issue}]} end)')"
  id="$(ado POST "$api/pullrequests?api-version=7.1" "$create" | jq -r .pullRequestId)"
  echo "Created pull request $id."
fi
