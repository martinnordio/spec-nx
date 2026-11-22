# Shared by the Azure DevOps tools: organisation, project and repository from the origin remote,
# and REST calls authenticated with AZURE_DEVOPS_EXT_PAT if it is set, otherwise with the
# developer's git login (Git Credential Manager). Credentials are never printed.
# Needs curl, jq and python3 (for the settings, ../settings.sh).

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

# ado_setting <key.sub>  ->  prints a setting of the project in three layers (settings.sh)
ado_setting() {
  bash "$(dirname "${BASH_SOURCE[0]}")/../settings.sh" --root "$(git rev-parse --show-toplevel)" --get "$1"
}

# ado_items  ->  sets ADO_ITEMS: the project that holds the backlog items (work_items.org and
# .project from the settings, otherwise the repository's project)
ado_items() {
  ado_repo || return 1
  local org project
  org="$(ado_setting work_items.org)" || return 1
  project="$(ado_setting work_items.project)" || return 1
  ADO_ITEMS="$ADO_BASE"
  if [[ -n "$org" && -n "$project" ]]; then
    ADO_ITEMS="https://dev.azure.com/$(jq -rn --arg v "$org" '$v | @uri')/$(jq -rn --arg v "$project" '$v | @uri')"
  fi
}

# ado_auth  ->  sets ADO_USERPASS (user:password for curl -u), once
ado_auth() {
  [[ -n "${ADO_USERPASS:-}" ]] && return 0
  if [[ -n "${AZURE_DEVOPS_EXT_PAT:-}" ]]; then
    ADO_USERPASS=":$AZURE_DEVOPS_EXT_PAT"
    return 0
  fi
  local remote host path user='' cred username password
  remote="$(git remote get-url origin)"
  if [[ ! "$remote" =~ ^https://(([^@/]+)@)?([^/]+)/(.*)$ ]]; then
    echo 'origin is not an https remote: set AZURE_DEVOPS_EXT_PAT (Work Items and Code: read and write).' >&2
    return 1
  fi
  user="${BASH_REMATCH[2]}" host="${BASH_REMATCH[3]}" path="${BASH_REMATCH[4]}"
  cred="$(printf 'protocol=https\nhost=%s\npath=%s\n%s\n' "$host" "$path" "${user:+username=$user}" | git credential fill)"
  username="$(sed -n 's/^username=//p' <<< "$cred")"
  password="$(sed -n 's/^password=//p' <<< "$cred")"
  if [[ -z "$password" ]]; then
    echo 'No Azure DevOps login from git: run git fetch once to sign in, or set AZURE_DEVOPS_EXT_PAT.' >&2
    return 1
  fi
  ADO_USERPASS="$username:$password"
}

# ado <method> <url> [json-body] [content-type]
ado() {
  ado_auth || return 1
  local args=(-sS --fail-with-body -u "$ADO_USERPASS" -X "$1" "$2")
  if [[ $# -ge 3 ]]; then
    args+=(-H "Content-Type: ${4:-application/json}" --data-binary "$3")
  fi
  curl "${args[@]}"
}
