# Shared by the Azure DevOps tools: organisation, project and repository from the origin remote,
# and REST calls authenticated with AZURE_DEVOPS_EXT_PAT if it is set, otherwise with the
# developer's git login (Git Credential Manager). Credentials are never printed.

function Get-AdoRepo {
    $url = (git remote get-url origin | Out-String).Trim()
    $patterns = @(
        'dev\.azure\.com/(?<org>[^/]+)/(?<project>[^/]+)/_git/(?<repo>[^/?#]+)',
        'ssh\.dev\.azure\.com:v3/(?<org>[^/]+)/(?<project>[^/]+)/(?<repo>[^/?#]+)',
        '(?<org>[^/@.]+)\.visualstudio\.com/(?:DefaultCollection/)?(?<project>[^/]+)/_git/(?<repo>[^/?#]+)'
    )
    foreach ($p in $patterns) {
        if ($url -match $p) {
            $org = $Matches.org; $project = $Matches.project; $repo = $Matches.repo
            return [pscustomobject]@{
                Base = "https://dev.azure.com/$org/$project"
                Repo = [uri]::UnescapeDataString($repo)
                Remote = $url
            }
        }
    }
    throw "origin is not an Azure DevOps repository: $url"
}

function Get-AdoAuthorization {
    if ($env:AZURE_DEVOPS_EXT_PAT) {
        return 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$env:AZURE_DEVOPS_EXT_PAT"))
    }
    $remote = (git remote get-url origin | Out-String).Trim()
    if ($remote -notmatch '^https://') {
        throw 'origin is not an https remote: set AZURE_DEVOPS_EXT_PAT (Work Items and Code: read and write).'
    }
    $uri = [uri]$remote
    $userInfo = if ($uri.UserInfo) { "username=$($uri.UserInfo)`n" } else { '' }
    $request = "protocol=https`nhost=$($uri.Host)`npath=$($uri.AbsolutePath.TrimStart('/'))`n$userInfo`n"
    $cred = @{}
    ($request | git credential fill) | ForEach-Object {
        if ($_ -match '^(?<k>[^=]+)=(?<v>.*)$') { $cred[$Matches.k] = $Matches.v }
    }
    if (-not $cred.password) { throw 'No Azure DevOps login from git: run git fetch once to sign in, or set AZURE_DEVOPS_EXT_PAT.' }
    return 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($cred.username):$($cred.password)"))
}

function Invoke-Ado {
    param([string]$Method, [string]$Uri, $Body, [string]$ContentType = 'application/json')
    if (-not $script:AdoAuthorization) { $script:AdoAuthorization = Get-AdoAuthorization }
    $request = @{ Method = $Method; Uri = $Uri; Headers = @{ Authorization = $script:AdoAuthorization } }
    if ($null -ne $Body) {
        $request.Body = [Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject $Body -Depth 10))
        $request.ContentType = $ContentType
    }
    Invoke-RestMethod @request
}
