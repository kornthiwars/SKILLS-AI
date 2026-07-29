#Requires -Version 5.1
# Archive old project dailies: vault/projects/*/daily/*.md → …/daily/archive/YYYY/
param(
    [int]$OlderThanDays = 14,
    [string]$BeforeDate = '',
    [string]$Project = '',
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

$projectsRoot = Join-Path $RepoRoot 'vault\projects'
if (-not (Test-Path -LiteralPath $projectsRoot)) {
    throw 'Missing vault/projects - run bootstrap-vault first'
}

$today = Get-Date -Date (Get-Date -Format 'yyyy-MM-dd')
$cutoff = if ($BeforeDate) {
    Get-Date -Date $BeforeDate
} else {
    $today.AddDays(-1 * $OlderThanDays)
}

$projectFilter = if ($Project.Trim()) { $Project.Trim().ToLowerInvariant() } else { '*' }
$moved = 0
Get-ChildItem -LiteralPath $projectsRoot -Directory | Where-Object {
    $projectFilter -eq '*' -or $_.Name -eq $projectFilter
} | ForEach-Object {
    $dailyDir = Join-Path $_.FullName 'daily'
    if (-not (Test-Path -LiteralPath $dailyDir)) { return }
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
}

Write-Output "Done archived=$moved cutoff=$($cutoff.ToString('yyyy-MM-dd'))"
