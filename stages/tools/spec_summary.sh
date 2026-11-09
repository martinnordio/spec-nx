# Shared by the git-host tools: put a summary between the spec-summary markers of a description.
# Source it: . "$here/../spec_summary.sh"

SPEC_SUMMARY_START='<!-- spec-summary:start -->'
SPEC_SUMMARY_END='<!-- spec-summary:end -->'

# set_spec_summary <body> <summary>  ->  new body on stdout
set_spec_summary() {
  local body="$1" summary="$2"
  local block="$SPEC_SUMMARY_START"$'\n'"$summary"$'\n'"$SPEC_SUMMARY_END"
  if [[ -z "${body//[[:space:]]/}" ]]; then
    printf '%s\n' "$block"
  elif [[ "$body" == *"$SPEC_SUMMARY_START"*"$SPEC_SUMMARY_END"* ]]; then
    printf '%s%s%s\n' "${body%%"$SPEC_SUMMARY_START"*}" "$block" "${body#*"$SPEC_SUMMARY_END"}"
  else
    printf '%s\n\n%s\n' "$body" "$block"
  fi
}
