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
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

function Read-VaultText([string]$Path) {
    # UTF-8 with or without BOM (Obsidian / bootstrap / manual edits)
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Write-VaultText([string]$Path, [string]$Content) {
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function New-DailyFromTemplate {
    param([string]$Target, [string]$Template, [string]$Date, [string]$Iso)
    if (-not (Test-Path -LiteralPath $Template)) {
        throw "Missing template: $Template"
    }
    $content = Read-VaultText $Template
    $content = $content.Replace('__VAULT_DATE__', $Date).Replace('__VAULT_ISO__', $Iso)
    $parent = Split-Path -Parent $Target
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Write-VaultText $Target $content
}

function Get-DailySummaryInsertIndex([string]$Content) {
    # First ## section after YAML frontmatter — avoids Thai literal encoding in script source
    $fm = [regex]::Match($Content, '(?s)\A---\r?\n.*?\r?\n---\r?\n')
    if (-not $fm.Success) { throw 'Missing YAML frontmatter in daily file' }
    $rest = $Content.Substring($fm.Length)
    $h2 = [regex]::Match($rest, '(?m)^## [^\r\n]+\r?\n')
    if (-not $h2.Success) { throw 'Missing first ## section (summary) in daily file' }
    return $fm.Length + $h2.Index + $h2.Length
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

$content = Read-VaultText $dailyFile
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
        $insertAt = Get-DailySummaryInsertIndex $content
        $content = $content.Insert($insertAt, "`n$bulletLine`n")
    } else {
        Write-Output "SKIP duplicate bullet"
    }
}

if ($Issue.Trim()) {
    $issueId = "iss-$date-$runs"
    $issueRow = "| $issueId | $($Issue.Trim()) | open | daily_only | |"
    if ($content -notmatch [regex]::Escape($issueRow)) {
        $sepMatch = [regex]::Match($content, '(?m)^\|----\|[-| ]+\|\s*$')
        if (-not $sepMatch.Success) { throw 'Missing Issues table separator in daily file' }
        $insertAt = $sepMatch.Index + $sepMatch.Length
        $content = $content.Insert($insertAt, "`n$issueRow")
    } else {
        Write-Output "SKIP duplicate issue row"
    }
}

Write-VaultText $dailyFile $content
Write-Output "OK runs=$runs"
Write-Output $dailyFile
