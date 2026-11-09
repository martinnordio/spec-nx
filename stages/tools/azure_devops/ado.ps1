# Shared by the Azure DevOps tools: organisation, project and repository from the origin remote,
# and REST calls authenticated with the personal access token in AZURE_DEVOPS_EXT_PAT.

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
            }
        }
    }
    throw "origin is not an Azure DevOps repository: $url"
}

function Invoke-Ado {
    param([string]$Method, [string]$Uri, $Body, [string]$ContentType = 'application/json')
    if (-not $env:AZURE_DEVOPS_EXT_PAT) { throw 'Set AZURE_DEVOPS_EXT_PAT to a personal access token (Work Items and Code: read and write).' }
    $token = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$env:AZURE_DEVOPS_EXT_PAT"))
    $request = @{ Method = $Method; Uri = $Uri; Headers = @{ Authorization = "Basic $token" } }
    if ($null -ne $Body) {
        $request.Body = [Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject $Body -Depth 10))
        $request.ContentType = $ContentType
    }
    Invoke-RestMethod @request
}
