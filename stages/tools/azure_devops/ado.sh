# Shared by the Azure DevOps tools: organisation, project and repository from the origin remote,
# and REST calls authenticated with the personal access token in AZURE_DEVOPS_EXT_PAT.
# Needs curl and jq.

ado_repo() {
  local url org project repo
  url="$(git remote get-url origin)"
  if [[ "$url" =~ dev\.azure\.com/([^/]+)/([^/]+)/_git/([^/?#]+) ]] ||
     [[ "$url" =~ ssh\.dev\.azure\.com:v3/([^/]+)/([^/]+)/([^/?#]+) ]] ||
     [[ "$url" =~ ([^/@.]+)\.visualstudio\.com/(DefaultCollection/)?([^/]+)/_git/([^/?#]+) ]]; then
    if [[ "$url" == *visualstudio.com* ]]; then
      org="${BASH_REMATCH[1]}" project="${BASH_REMATCH[3]}" repo="${BASH_REMATCH[4]}"
    else
      org="${BASH_REMATCH[1]}" project="${BASH_REMATCH[2]}" repo="${BASH_REMATCH[3]}"
    fi
    ADO_BASE="https://dev.azure.com/$org/$project"
    ADO_REPO="$repo"
  else
    echo "origin is not an Azure DevOps repository: $url" >&2
    return 1
  fi
}

# ado <method> <url> [json-body] [content-type]
ado() {
  [[ -n "${AZURE_DEVOPS_EXT_PAT:-}" ]] || { echo 'Set AZURE_DEVOPS_EXT_PAT to a personal access token (Work Items and Code: read and write).' >&2; return 1; }
  local args=(-sS --fail-with-body -u ":$AZURE_DEVOPS_EXT_PAT" -X "$1" "$2")
  if [[ $# -ge 3 ]]; then
    args+=(-H "Content-Type: ${4:-application/json}" --data-binary "$3")
  fi
  curl "${args[@]}"
}
