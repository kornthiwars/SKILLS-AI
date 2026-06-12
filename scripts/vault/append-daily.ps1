#Requires -Version 5.1
# Append one bullet to today's daily note (vault autolog — deterministic).
param(
    [Parameter(Mandatory = $true)]
    [string]$Bullet,
    [string]$RepoRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$date = Get-Date -Format 'yyyy-MM-dd'
$iso = Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'
$dailyFile = Join-Path $RepoRoot "vault\daily\$date.md"
$dailyDir = Split-Path -Parent $dailyFile

if (-not (Test-Path -LiteralPath $dailyDir)) {
    throw "Vault layout missing: run scripts/vault/bootstrap-vault.ps1 -Verify first"
}
if (-not (Test-Path -LiteralPath $dailyFile)) {
    throw "Daily file missing: $dailyFile - create from templates/vault/notes/template.vault-daily.md (DATE/ISO) first"
}

$bulletLine = if ($Bullet.TrimStart().StartsWith('-')) { $Bullet.Trim() } else { "- $Bullet" }
$utf8 = New-Object System.Text.UTF8Encoding $false
$content = [System.IO.File]::ReadAllText($dailyFile, $utf8)
# Normalize line endings for section match
$content = $content -replace "`r`n", "`n"

if ($content -match [regex]::Escape($bulletLine)) {
    Write-Output "SKIP duplicate"
    Write-Output $dailyFile
    exit 0
}

if ($content -match 'runs:\s*(\d+)') {
    $runs = [int]$Matches[1] + 1
    $content = $content -replace 'runs:\s*\d+', "runs: $runs"
} else {
    $runs = 2
}

$content = $content -replace 'updated_at:\s*"[^"]*"', "updated_at: `"$iso`""

# ASCII anchor — avoids .ps1 source encoding vs UTF-8 daily file mismatch
$anchor = "`n## Issues"
$pos = $content.IndexOf($anchor)
if ($pos -lt 0) { throw "Missing anchor section before Issues table" }
$content = $content.Insert($pos + 1, "$bulletLine`n`n")

[System.IO.File]::WriteAllText($dailyFile, $content, $utf8)
Write-Output "OK runs=$runs"
Write-Output $dailyFile
