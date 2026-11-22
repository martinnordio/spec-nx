<#
.SYNOPSIS
  Create an Azure DevOps backlog item (work item) whose description is a spec summary (in the
  spec-summary block, stored as Markdown), optionally under a parent work item. Area path,
  iteration path and the person it is assigned to come from the parameters or the settings
  (work_items.area, .iteration, .assigned_to); by default it is assigned to the signed-in user,
  and work_items.assigned_to = null leaves it unassigned. Every field is checked before the
  item is created; the dry run lists them with where they come from. Prints the new id.
.EXAMPLE
  ./create_issue.ps1 -Title "Login page" -SummaryFile summary.md -Type "Product Backlog Item" -Parent 1234 -DryRun
  ./create_issue.ps1 -Title "Login page" -SummaryFile summary.md -Area "Shop\Team A" -Iteration "Shop\Sprint 12" -AssignedTo ana@example.com -DryRun
#>
param(
    [Parameter(Mandatory)] [string] $Title,
    [Parameter(Mandatory)] [string] $SummaryFile,
    [string] $Type = 'Product Backlog Item',
    [int] $Parent,
    [string] $Area,
    [string] $Iteration,
    [string] $AssignedTo,
    [switch] $Unassigned,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')
. (Join-Path $PSScriptRoot 'ado.ps1')

$items = Get-AdoWorkItemsBase
$org = ([uri]$items).Segments[1].TrimEnd('/')
$projectName = [uri]::UnescapeDataString(([uri]$items).Segments[2].TrimEnd('/'))
$settings = Get-AdoSettings

# A field from the parameter, else from the settings; with the place it comes from.
function Resolve-Field([string] $given, [string] $key) {
    if ($given) { return @{ value = $given; from = 'parameter' } }
    $v = Get-SpecNxValue $settings $key
    $src = Get-SpecNxSource $settings $key
    if ($v) { return @{ value = "$v"; from = "$key in $src" } }
    return @{ value = $null; from = $src }
}

# Checks a classification path (area or iteration) of the project; returns the full path.
function Test-ClassificationPath([string] $kind, [string] $path, [string] $from) {
    $relative = $path -replace '^[\\/]+', ''
    if ($relative -eq $projectName) { $relative = '' }
    elseif ($relative.StartsWith("$projectName\") -or $relative.StartsWith("$projectName/")) { $relative = $relative.Substring($projectName.Length + 1) }
    $segments = @($relative -split '[\\/]' | Where-Object { $_ } | ForEach-Object { [uri]::EscapeDataString($_) })
    $nodes = if ($kind -eq 'area') { 'areas' } else { 'iterations' }
    try {
        $node = Invoke-Ado -Method Get -Uri "$items/_apis/wit/classificationnodes/$nodes/$($segments -join '/')?api-version=7.1"
    } catch {
        throw "The $kind '$path' ($from) is not an $kind path of the project '$projectName'."
    }
    return ($projectName + $(if ($relative) { '\' + ($relative -replace '/', '\') } else { '' }))
}

$areaField = Resolve-Field $Area 'work_items.area'
if ($areaField.value) { $areaField.value = Test-ClassificationPath 'area' $areaField.value $areaField.from }
$iterationField = Resolve-Field $Iteration 'work_items.iteration'
if ($iterationField.value) { $iterationField.value = Test-ClassificationPath 'iteration' $iterationField.value $iterationField.from }

$assigned = Resolve-Field $AssignedTo 'work_items.assigned_to'
if ($Unassigned -or (-not $assigned.value -and $assigned.from -like '* (removed)')) {
    $assigned = @{ value = $null; from = $(if ($Unassigned) { 'parameter -Unassigned' } else { "work_items.assigned_to = null in $($assigned.from -replace ' \(removed\)$', '')" }) }
} elseif (-not $assigned.value) {
    $me = Invoke-Ado -Method Get -Uri "https://dev.azure.com/$org/_apis/connectionData?api-version=7.1-preview"
    $account = $me.authenticatedUser.properties.Account.'$value'
    if (-not $account) { throw 'Could not find the signed-in user; set work_items.assigned_to, or null to leave the item unassigned.' }
    $assigned = @{ value = $account; from = 'default: you, the signed-in user' }
} else {
    $found = Invoke-Ado -Method Get -Uri "https://vssps.dev.azure.com/$org/_apis/identities?searchFilter=General&filterValue=$([uri]::EscapeDataString($assigned.value))&api-version=7.1"
    if (-not $found -or $found.count -lt 1) { throw "The person '$($assigned.value)' ($($assigned.from)) is not a user of the organisation '$org'." }
}

$body = Set-SpecSummary -Body '' -Summary (Read-Utf8 $SummaryFile)
if ($Parent) {
    try { $parentItem = Invoke-Ado -Method Get -Uri "$items/_apis/wit/workitems/$($Parent)?fields=System.Title&api-version=7.1" }
    catch { throw "The parent $Parent is not a work item of $items." }
}
if ($DryRun) {
    $show = { param($f) if ($f.value) { "$($f.value)   ($($f.from))" } else { "-   ($(if ($f.from) { $f.from } else { 'not set: the project default' }))" } }
    Write-Output "Would create $Type '$Title' in $items with:"
    Write-Output "  Parent:      $(if ($Parent) { "$Parent '$($parentItem.fields.'System.Title')'" } else { '-' })"
    Write-Output "  Area:        $(& $show $areaField)"
    Write-Output "  Iteration:   $(& $show $iterationField)"
    Write-Output "  Assigned to: $(if ($assigned.value) { "$($assigned.value)   ($($assigned.from))" } else { "-   ($($assigned.from))" })"
    Write-Output 'Description:'
    Write-Output $body
    return
}
$patch = @(
    @{ op = 'add'; path = '/fields/System.Title'; value = $Title },
    @{ op = 'add'; path = '/multilineFieldsFormat/System.Description'; value = 'Markdown' },
    @{ op = 'add'; path = '/fields/System.Description'; value = $body }
)
if ($areaField.value) { $patch += @{ op = 'add'; path = '/fields/System.AreaPath'; value = $areaField.value } }
if ($iterationField.value) { $patch += @{ op = 'add'; path = '/fields/System.IterationPath'; value = $iterationField.value } }
if ($assigned.value) { $patch += @{ op = 'add'; path = '/fields/System.AssignedTo'; value = $assigned.value } }
if ($Parent) {
    $patch += @{ op = 'add'; path = '/relations/-'; value = @{ rel = 'System.LinkTypes.Hierarchy-Reverse'; url = $parentItem.url } }
}
$typePath = [uri]::EscapeDataString($Type)
$created = Invoke-Ado -Method Post -Uri "$items/_apis/wit/workitems/`$$($typePath)?api-version=7.1" -Body $patch -ContentType 'application/json-patch+json'
Write-Output $created.id
