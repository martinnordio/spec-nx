# Shared by the git-host tools: put a text between named markers of a description
# ([//]: # (spec-summary:start) ... [//]: # (spec-summary:end), the same for semantic-diff).
# Azure DevOps drops HTML comments from work items; older <!-- name:start --> markers are still found.
# Source it: . "$here/../spec_summary.sh"

# set_marked_block <body> <name> <text>  ->  new body on stdout
set_marked_block() {
  local body="$1" name="$2" text="$3"
  local block="[//]: # ($name:start)"$'\n\n'"$text"$'\n\n'"[//]: # ($name:end)"
  if [[ -z "${body//[[:space:]]/}" ]]; then
    printf '%s\n' "$block"
    return
  fi
  local start end
  for start in "[//]: # ($name:start)" "<!-- $name:start -->"; do
    end="${start/start/end}"
    if [[ "$body" == *"$start"*"$end"* ]]; then
      local before="${body%%"$start"*}" after="${body#*"$end"}"
      before="${before%"${before##*[![:space:]]}"}"
      after="${after#"${after%%[![:space:]]*}"}"
      [[ -n "$before" ]] && before="$before"$'\n\n'
      [[ -n "$after" ]] && after=$'\n\n'"$after"
      printf '%s%s%s\n' "$before" "$block" "$after"
      return
    fi
  done
  printf '%s\n\n%s\n' "$body" "$block"
}

# set_spec_summary <body> <summary>  ->  new body on stdout
set_spec_summary() {
  set_marked_block "$1" spec-summary "$2"
}

# set_semantic_diff <body> <text>  ->  new body on stdout
set_semantic_diff() {
  set_marked_block "$1" semantic-diff "$2"
}
