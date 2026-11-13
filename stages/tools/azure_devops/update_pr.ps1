<#
.SYNOPSIS
  Put a spec summary into the spec-summary block of the Azure DevOps pull request of the current
  branch; creates the pull request if there is none (needs -Title). With -SemanticDiffFile, also
  puts that text into the semantic-diff block. Text outside the blocks is kept.
.EXAMPLE
  ./update_pr.ps1 -SummaryFile summary.md -Title "Login page" -Issue 123 -Draft -DryRun
.EXAMPLE
  ./update_pr.ps1 -SummaryFile summary.md -SemanticDiffFile semantic_diff.md -DryRun
#>
param(
    [Parameter(Mandatory)] [string] $SummaryFile,
    [string] $SemanticDiffFile,
    [string] $Title,
    [int] $Issue,
    [switch] $Draft,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')
. (Join-Path $PSScriptRoot 'ado.ps1')

# Azure DevOps refuses pull-request descriptions longer than this.
$MaxDescription = 4000

$branch = (git branch --show-current | Out-String).Trim()
if (-not $branch) { throw 'Not on a branch.' }
$summary = Read-Utf8 $SummaryFile
$ado = Get-AdoRepo
$api = "$($ado.Base)/_apis/git/repositories/$([uri]::EscapeDataString($ado.Repo))"
$source = "refs/heads/$branch"

$found = Invoke-Ado -Method Get -Uri "$api/pullrequests?searchCriteria.sourceRefName=$source&searchCriteria.status=active&api-version=7.1"
$pr = @($found.value)[0]

if ($pr) {
    $new = Set-SpecSummary -Body ([string]$pr.description).TrimEnd() -Summary $summary
    $target = "pull request $($pr.pullRequestId)"
} else {
    if (-not $Title) { throw "No active pull request for '$branch' yet: pass -Title to create one." }
    $new = Set-SpecSummary -Body '' -Summary $summary
    $kind = if ($Draft) { 'draft pull request' } else { 'pull request' }
    $target = "a new $kind '$Title' from '$branch'"
}
if ($SemanticDiffFile) { $new = Set-SemanticDiff -Body $new -Text (Read-Utf8 $SemanticDiffFile) }
if ($new.Length -gt $MaxDescription) { throw "The description has $($new.Length) characters; Azure DevOps allows $MaxDescription. Shorten the summary." }

if ($DryRun) {
    Write-Output "Would write $($target):"
    Write-Output $new
    return
}
if ($pr) {
    Invoke-Ado -Method Patch -Uri "$api/pullrequests/$($pr.pullRequestId)?api-version=7.1" -Body @{ description = $new } | Out-Null
    Write-Output "Updated $target."
} else {
    $repo = Invoke-Ado -Method Get -Uri "$($api)?api-version=7.1"
    $create = @{
        sourceRefName = $source; targetRefName = $repo.defaultBranch
        title = $Title; description = $new; isDraft = [bool]$Draft
    }
    if ($Issue) { $create.workItemRefs = @(@{ id = "$Issue" }) }
    $created = Invoke-Ado -Method Post -Uri "$api/pullrequests?api-version=7.1" -Body $create
    Write-Output "Created pull request $($created.pullRequestId)."
}
