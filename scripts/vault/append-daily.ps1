#Requires -Version 5.1
# Append bullet and/or Issues row to today's daily (vault autolog).
param(
    [string]$Bullet = '',
    [string]$Issue = '',
    [string]$RepoRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Bullet.Trim() -and -not $Issue.Trim()) {
    throw 'Provide -Bullet and/or -Issue'
}

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$NotesPack = Join-Path $RepoRoot 'templates\vault\notes'
$TemplateFile = Join-Path $NotesPack 'template.vault-daily.md'

function New-DailyFromTemplate {
    param([string]$Target, [string]$Template, [string]$Date, [string]$Iso)
    if (-not (Test-Path -LiteralPath $Template)) {
        throw "Missing template: $Template"
    }
    $utf8 = New-Object System.Text.UTF8Encoding $false
    $content = [System.IO.File]::ReadAllText($Template, $utf8)
    $content = $content.Replace('__VAULT_DATE__', $Date).Replace('__VAULT_ISO__', $Iso)
    $parent = Split-Path -Parent $Target
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Target, $content, $utf8)
}

$date = Get-Date -Format 'yyyy-MM-dd'
$iso = Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'
$dailyFile = Join-Path $RepoRoot "vault\daily\$date.md"
$dailyDir = Split-Path -Parent $dailyFile

if (-not (Test-Path -LiteralPath $dailyDir)) {
    throw "Vault layout missing: run scripts/vault/bootstrap-vault.ps1 -Verify first"
}
if (-not (Test-Path -LiteralPath $dailyFile)) {
    New-DailyFromTemplate -Target $dailyFile -Template $TemplateFile -Date $date -Iso $iso
    Write-Output "INIT daily created"
}

$utf8 = New-Object System.Text.UTF8Encoding $false
$content = [System.IO.File]::ReadAllText($dailyFile, $utf8)
$content = $content -replace "`r`n", "`n"

$runs = 1
if ($content -match 'runs:\s*(\d+)') {
    $runs = [int]$Matches[1] + 1
    $content = $content -replace 'runs:\s*\d+', "runs: $runs"
}
$content = $content -replace 'updated_at:\s*"[^"]*"', "updated_at: `"$iso`""

if ($Bullet.Trim()) {
    $bulletLine = if ($Bullet.TrimStart().StartsWith('-')) { $Bullet.Trim() } else { "- $Bullet" }
    if ($content -notmatch [regex]::Escape($bulletLine)) {
        $anchor = "`n## Issues"
        $pos = $content.IndexOf($anchor)
        if ($pos -lt 0) { throw "Missing ## Issues section in daily file" }
        $content = $content.Insert($pos + 1, "$bulletLine`n`n")
    } else {
        Write-Output "SKIP duplicate bullet"
    }
}

if ($Issue.Trim()) {
    $issueId = "iss-$date-$runs"
    $issueRow = "| $issueId | $($Issue.Trim()) | open | daily_only | |"
    if ($content -notmatch [regex]::Escape($issueRow)) {
        $tableSep = '|----|-------|-------|--------|--------|'
        $sepIndex = $content.IndexOf($tableSep)
        if ($sepIndex -lt 0) { throw "Missing Issues table separator in daily file" }
        $insertAt = $sepIndex + $tableSep.Length
        $content = $content.Insert($insertAt, "`n$issueRow")
    } else {
        Write-Output "SKIP duplicate issue row"
    }
}

[System.IO.File]::WriteAllText($dailyFile, $content, $utf8)
Write-Output "OK runs=$runs"
Write-Output $dailyFile
