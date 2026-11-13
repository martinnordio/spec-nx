<#
.SYNOPSIS
  Create an Azure DevOps backlog item (work item) whose description is a spec summary (in the
  spec-summary block, stored as Markdown), optionally under a parent work item. Prints its id.
.EXAMPLE
  ./create_issue.ps1 -Title "Login page" -SummaryFile summary.md -Type "Product Backlog Item" -Parent 1234 -DryRun
#>
param(
    [Parameter(Mandatory)] [string] $Title,
    [Parameter(Mandatory)] [string] $SummaryFile,
    [string] $Type = 'Product Backlog Item',
    [int] $Parent,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')
. (Join-Path $PSScriptRoot 'ado.ps1')

$items = Get-AdoWorkItemsBase
$body = Set-SpecSummary -Body '' -Summary (Read-Utf8 $SummaryFile)
if ($Parent) {
    $parentItem = Invoke-Ado -Method Get -Uri "$items/_apis/wit/workitems/$($Parent)?fields=System.Title&api-version=7.1"
}
if ($DryRun) {
    $under = if ($Parent) { " under $Parent '$($parentItem.fields.'System.Title')'" } else { '' }
    Write-Output "Would create $Type '$Title'$under in $items with:"
    Write-Output $body
    return
}
$patch = @(
    @{ op = 'add'; path = '/fields/System.Title'; value = $Title },
    @{ op = 'add'; path = '/multilineFieldsFormat/System.Description'; value = 'Markdown' },
    @{ op = 'add'; path = '/fields/System.Description'; value = $body }
)
if ($Parent) {
    $patch += @{ op = 'add'; path = '/relations/-'; value = @{ rel = 'System.LinkTypes.Hierarchy-Reverse'; url = $parentItem.url } }
}
$typePath = [uri]::EscapeDataString($Type)
$created = Invoke-Ado -Method Post -Uri "$items/_apis/wit/workitems/`$$($typePath)?api-version=7.1" -Body $patch -ContentType 'application/json-patch+json'
Write-Output $created.id
