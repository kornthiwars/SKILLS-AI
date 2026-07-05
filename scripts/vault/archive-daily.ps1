#Requires -Version 5.1
# Move old vault/daily/*.md files to daily/archive/YYYY/ (ephemeral retention).
param(
    [int]$OlderThanDays = 14,
    [string]$BeforeDate = '',
    [switch]$DryRun,
    [string]$RepoRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$dailyDir = Join-Path $RepoRoot 'vault\daily'
if (-not (Test-Path -LiteralPath $dailyDir)) {
    throw 'Missing vault/daily - run bootstrap-vault first'
}

$today = Get-Date -Date (Get-Date -Format 'yyyy-MM-dd')
$cutoff = if ($BeforeDate) {
    Get-Date -Date $BeforeDate
} else {
    $today.AddDays(-1 * $OlderThanDays)
}

$moved = 0
Get-ChildItem -LiteralPath $dailyDir -Filter '*.md' -File | ForEach-Object {
    $base = $_.BaseName
    if ($base -notmatch '^\d{4}-\d{2}-\d{2}$') { return }
    $fileDate = Get-Date -Date $base
    if ($fileDate -ge $cutoff) { return }

    $year = $fileDate.ToString('yyyy')
    $archiveDir = Join-Path $dailyDir "archive\$year"
    $dest = Join-Path $archiveDir $_.Name

    if ($DryRun) {
        Write-Output "DRY  $($_.FullName) -> $dest"
    } else {
        if (-not (Test-Path -LiteralPath $archiveDir)) {
            New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
        }
        if (Test-Path -LiteralPath $dest) {
            Write-Warning "SKIP exists: $dest"
            return
        }
        Move-Item -LiteralPath $_.FullName -Destination $dest
        Write-Output "OK   $dest"
    }
    $script:moved++
}

Write-Output "Done archived=$moved cutoff=$($cutoff.ToString('yyyy-MM-dd'))"
