# Shared by the git-host tools: put a text between named markers of a description
# (<!-- spec-summary:start --> ... <!-- spec-summary:end -->, the same for semantic-diff).
# Source it: . "$here/../spec_summary.sh"

# set_marked_block <body> <name> <text>  ->  new body on stdout
set_marked_block() {
  local body="$1" name="$2" text="$3"
  local start="<!-- $name:start -->" end="<!-- $name:end -->"
  local block="$start"$'\n'"$text"$'\n'"$end"
  if [[ -z "${body//[[:space:]]/}" ]]; then
    printf '%s\n' "$block"
  elif [[ "$body" == *"$start"*"$end"* ]]; then
    printf '%s%s%s\n' "${body%%"$start"*}" "$block" "${body#*"$end"}"
  else
    printf '%s\n\n%s\n' "$body" "$block"
  fi
}

# set_spec_summary <body> <summary>  ->  new body on stdout
set_spec_summary() {
  set_marked_block "$1" spec-summary "$2"
}

# set_semantic_diff <body> <text>  ->  new body on stdout
set_semantic_diff() {
  set_marked_block "$1" semantic-diff "$2"
}
