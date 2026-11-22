<#
.SYNOPSIS
  Checks of the usage and costs_ledger scripts (both shells) on the sample logs in samples/:
  a Copilot CLI chat with a sub-agent and two models, a second chat of the same project at the
  same time, a chat of another project, an empty range, and the -Run marker. Run from anywhere:
    powershell -File testing/usage/check_usage.ps1 [-Bash <bash.exe>] [-BashPath <dir to put first on PATH>]
  Prints one line per check and the number of failures (exit code 1 when any check fails).
#>
param(
    [string] $Bash = $(if ($IsWindows -or $env:OS -eq 'Windows_NT') { 'C:\Program Files\Git\bin\bash.exe' } else { 'bash' }),
    [string] $BashPath
)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$tools = Join-Path (Split-Path (Split-Path $here -Parent) -Parent) 'stages/tools'
$work = Join-Path ([IO.Path]::GetTempPath()) ('spec-nx-usage-check-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
$project = Join-Path $work 'project'; $other = Join-Path $work 'other'; $home2 = Join-Path $work 'home'
New-Item -ItemType Directory -Force (Join-Path $project '.specs/features/done'), $other, (Join-Path $work 'appdata') | Out-Null
$enc = New-Object Text.UTF8Encoding $false
[IO.File]::WriteAllText((Join-Path $project '.specs/spec-nx.json'), '{ "version": 1, "cost": { "enabled": true, "plan": "Copilot Business", "monthly_credits": 1900, "currency": "CHF", "rate": 0.8 } }', $enc)
foreach ($c in @(@{ n = 'chat_a'; cwd = $project }, @{ n = 'chat_b'; cwd = $project }, @{ n = 'chat_other_project'; cwd = $other })) {
    $dir = Join-Path $home2 ".copilot/session-state/$($c.n)"
    New-Item -ItemType Directory -Force $dir | Out-Null
    Copy-Item (Join-Path $here "samples/$($c.n).jsonl") (Join-Path $dir 'events.jsonl')
    [IO.File]::WriteAllText((Join-Path $dir 'workspace.yaml'), "id: $($c.n)`ncwd: $($c.cwd)`n", $enc)
}

$fails = 0
function Check([string] $name, [bool] $ok, [string] $detail = '') {
    if ($ok) { "ok   $name" } else { "FAIL $name $detail"; $script:fails++ }
}
# Runs a script with the sample home as the user's home; returns @{ out; code }.
function Invoke-Ps([string] $script, [string[]] $arguments) {
    $saved = @($env:USERPROFILE, $env:APPDATA, $env:HOME)
    $env:USERPROFILE = $home2; $env:HOME = $home2; $env:APPDATA = (Join-Path $work 'appdata')
    try {
        Push-Location $project
        $out = & { $ErrorActionPreference = 'Continue'; & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $tools $script) @arguments 2>&1 | Out-String }
        return @{ out = $out; code = $LASTEXITCODE }
    } finally { Pop-Location; $env:USERPROFILE, $env:APPDATA, $env:HOME = $saved }
}
function ConvertTo-BashPath([string] $p) {
    if ($p -match '^([A-Za-z]):\\') { return '/' + $Matches[1].ToLower() + $p.Substring(2).Replace('\', '/') }
    return $p
}
function Invoke-Sh([string] $script, [string[]] $arguments) {
    $prefix = if ($BashPath) { "export PATH='$(ConvertTo-BashPath $BashPath)':`$PATH; " } else { '' }
    $quoted = ($arguments | ForEach-Object { "'" + ($_ -replace "'", "'\''") + "'" }) -join ' '
    $cmd = "${prefix}export HOME='$(ConvertTo-BashPath $home2)' USERPROFILE='$home2' APPDATA='$(Join-Path $work 'appdata')'; cd '$(ConvertTo-BashPath $project)' && bash '$(ConvertTo-BashPath (Join-Path $tools $script))' $quoted"
    $out = & { $ErrorActionPreference = 'Continue'; & $Bash -c $cmd 2>&1 | Out-String }
    return @{ out = $out; code = $LASTEXITCODE }
}
function Json($r) { try { return $r.out.Trim() | ConvertFrom-Json } catch { return $null } }

$range = @('2026-11-20T09:59:00Z', '2026-11-20T11:00:00Z')
$logA = Join-Path $home2 '.copilot/session-state/chat_a/events.jsonl'

# 1. A Copilot CLI chat with a sub-agent and two models, by -Transcript: measured, billed credits.
$p = Json (Invoke-Ps 'usage.ps1' @('-Since', $range[0], '-Until', $range[1], '-Model', 'Claude Opus 5.5', '-Transcript', $logA, '-Json'))
$s = Json (Invoke-Sh 'usage.sh' @('--since', $range[0], '--until', $range[1], '--model', 'Claude Opus 5.5', '--transcript', $logA, '--json'))
Check 'cli: measured, 3 requests, 15.25 credits' ($p -and $p.source -eq 'measured' -and $p.requests -eq 3 -and $p.credits -eq 15.25) ($p | ConvertTo-Json -Compress)
Check 'cli: tokens 30 k in, 240 k cached, 6 k out' ($p -and $p.input -eq 30000 -and $p.cached -eq 240000 -and $p.output -eq 6000)
Check 'cli: both models named' ($p -and $p.model -eq 'Claude Haiku 5.5, Claude Opus 5.5') "$($p.model)"
Check 'cli: main 14.5 + sub-agents 0.75 credits' ($p -and $p.main_credits -eq 14.5 -and $p.subagent_credits -eq 0.75)
Check 'cli: bash gives the same numbers' ($s -and $s.credits -eq $p.credits -and $s.requests -eq $p.requests -and $s.input -eq $p.input -and $s.model -eq $p.model) ($s | ConvertTo-Json -Compress)
$pm = Json (Invoke-Ps 'usage.ps1' @('-Since', $range[0], '-Until', $range[1], '-Model', 'x', '-Transcript', $logA, '-Agent', 'subagents', '-Json'))
Check 'cli: -Agent subagents counts only the sub-agent' ($pm -and $pm.requests -eq 1 -and $pm.credits -eq 0.75)

# 2. Two chats of the project in the same range: no guess without -Run; the marker picks one.
$r = Invoke-Ps 'usage.ps1' @('-Since', $range[0], '-Until', $range[1], '-Model', 'x')
Check 'parallel: error without -Run, naming both chats' ($r.code -ne 0 -and $r.out -match 'Several chats' -and $r.out -match 'chat_a' -and $r.out -match 'chat_b' -and $r.out -notmatch 'chat_other_project') $r.out
$r = Invoke-Sh 'usage.sh' @('--since', $range[0], '--until', $range[1], '--model', 'x')
Check 'parallel: bash errors the same way' ($r.code -ne 0 -and $r.out -match 'Several chats') $r.out
$p = Json (Invoke-Ps 'usage.ps1' @('-Since', $range[0], '-Until', $range[1], '-Model', 'x', '-Run', '20261120-1000-test', '-Json'))
$s = Json (Invoke-Sh 'usage.sh' @('--since', $range[0], '--until', $range[1], '--model', 'x', '--run', '20261120-1000-test', '--json'))
Check 'parallel: -Run picks chat a' ($p -and $p.transcript -match 'chat_a' -and $p.credits -eq 15.25)
Check 'parallel: --run picks chat a (bash)' ($s -and $s.transcript -match 'chat_a' -and $s.credits -eq 15.25)
$p = Json (Invoke-Ps 'usage.ps1' @('-Since', $range[0], '-Until', $range[1], '-Model', 'x', '-Run', '20261120-1000-othr', '-Json'))
Check 'parallel: -Run picks chat b' ($p -and $p.transcript -match 'chat_b' -and $p.credits -eq 2.4)
$r = Invoke-Ps 'usage.ps1' @('-Since', $range[0], '-Until', $range[1], '-Model', 'x', '-Run', '20261120-1000-else')
Check 'other project: its marker is not found here' ($r.code -ne 0 -and $r.out -match 'No logs') $r.out
$r = Invoke-Ps 'usage.ps1' @('-Since', $range[0], '-Until', $range[1], '-Model', 'x', '-Run', '20261120-1000-othr', '-Transcript', $logA)
Check '-Transcript without the marker is refused' ($r.code -ne 0 -and $r.out -match 'does not contain the marker') $r.out

# 3. An empty range is an error, never 0.
$r = Invoke-Ps 'usage.ps1' @('-Since', '2026-11-19T00:00:00Z', '-Until', '2026-11-19T01:00:00Z', '-Model', 'x', '-Transcript', $logA)
Check 'empty range: error, not 0' ($r.code -ne 0 -and $r.out -match 'No AI requests') $r.out
$r = Invoke-Sh 'usage.sh' @('--since', '2026-11-19T00:00:00Z', '--until', '2026-11-19T01:00:00Z', '--model', 'x', '--transcript', $logA)
Check 'empty range: bash error, not 0' ($r.code -ne 0 -and $r.out -match 'No AI requests') $r.out

# 4. The cost list: "included in" rows, measured numbers without ~, a note when mixed.
Copy-Item (Join-Path $here 'samples/specs/*.md') (Join-Path $project '.specs/features/done/')
$p = Invoke-Ps 'costs_ledger.ps1' @('-CostsLink', '../COSTS.md', '-DryRun')
$s = Invoke-Sh 'costs_ledger.sh' @('--costs-link', '../COSTS.md', '--dry-run')
Check 'ledger: "included in" rows show as included, not N/A' ($p.out -match '\[Included\][^\r\n]*\| included \|[^\r\n]*\| included \|' -and $p.out -notmatch '\[Included\][^\r\n]*N/A') $p.out
Check 'ledger: measured numbers have no ~' ($p.out -match '\| CHF 1\.20 \(143 credits\)' -and $p.out -notmatch '~CHF 1\.20') $p.out
Check 'ledger: note when measured and estimated are mixed' ($p.out -match 'mixes measured and estimated') $p.out
Check 'ledger: bash gives the same list' ($s.out.Trim() -eq $p.out.Trim()) $s.out

Remove-Item -Recurse -Force $work
"$fails failure(s)"
if ($fails) { exit 1 }
