<#
.SYNOPSIS
  Put a spec summary into the spec-summary block of an Azure DevOps backlog item (work item)
  description; text outside the block is kept. The description is stored as Markdown.
.EXAMPLE
  ./update_issue.ps1 -Issue 123 -SummaryFile summary.md -DryRun
#>
param(
    [Parameter(Mandatory)] [int] $Issue,
    [Parameter(Mandatory)] [string] $SummaryFile,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')
. (Join-Path $PSScriptRoot 'ado.ps1')

$uri = "$(Get-AdoWorkItemsBase)/_apis/wit/workitems/$($Issue)?api-version=7.1"
$item = Invoke-Ado -Method Get -Uri "$uri&fields=System.Description"
$body = [string]$item.fields.'System.Description'
$new = Set-SpecSummary -Body $body.TrimEnd() -Summary (Read-Utf8 $SummaryFile)

if ($DryRun) {
    Write-Output "Would update backlog item $Issue to:"
    Write-Output $new
    return
}
$patch = @(
    @{ op = 'add'; path = '/multilineFieldsFormat/System.Description'; value = 'Markdown' },
    @{ op = 'add'; path = '/fields/System.Description'; value = $new }
)
Invoke-Ado -Method Patch -Uri $uri -Body $patch -ContentType 'application/json-patch+json' | Out-Null
Write-Output "Updated backlog item $Issue."
