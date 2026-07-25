#Requires -Version 5.1
# Append bullet and/or Issues row to today's daily for one project (vault autolog).
param(
    [string]$Bullet = '',
    [string]$Issue = '',
    [string]$Project = '',
    [string]$RepoRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Bullet.Trim() -and -not $Issue.Trim()) {
    throw 'Provide -Bullet and/or -Issue'
}

if (-not $Project.Trim()) {
    $Project = [string]$env:VAULT_PROJECT
}
if (-not $Project.Trim()) {
    throw 'Provide -Project or set VAULT_PROJECT (required for daily-per-project)'
}

$Project = $Project.Trim().ToLowerInvariant()
if ($Project.Length -gt 64 -or $Project -notmatch '^[a-z0-9_-]+$') {
    throw 'Project must be [a-z0-9_-] length 1–64'
}

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

# Template always from pack (script location); daily file under RepoRoot vault.
$PackRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$TemplateFile = Join-Path $PackRoot 'templates\vault\notes\template.vault-daily.md'
if (-not (Test-Path -LiteralPath $TemplateFile)) {
    $TemplateFile = Join-Path $RepoRoot 'templates\vault\notes\template.vault-daily.md'
}
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

function Read-VaultText([string]$Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Write-VaultText([string]$Path, [string]$Content) {
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function New-DailyFromTemplate {
    param([string]$Target, [string]$Template, [string]$Date, [string]$Iso, [string]$Proj)
    if (-not (Test-Path -LiteralPath $Template)) {
        throw "Missing template: $Template"
    }
    $content = Read-VaultText $Template
    $dailyId = "daily-${Date}__${Proj}"
    $content = $content.Replace('__VAULT_DAILY_ID__', $dailyId).Replace('__VAULT_DATE__', $Date).Replace('__VAULT_ISO__', $Iso).Replace('__VAULT_PROJECT__', $Proj)
    $parent = Split-Path -Parent $Target
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Write-VaultText $Target $content
}

function Get-DailySummaryInsertIndex([string]$Content) {
    $fm = [regex]::Match($Content, '(?s)\A---\r?\n.*?\r?\n---\r?\n')
    if (-not $fm.Success) { throw 'Missing YAML frontmatter in daily file' }
    $rest = $Content.Substring($fm.Length)
    $h2 = [regex]::Match($rest, '(?m)^## [^\r\n]+\r?\n')
    if (-not $h2.Success) { throw 'Missing first ## section (summary) in daily file' }
    return $fm.Length + $h2.Index + $h2.Length
}

function Send-VaultRemoteEvent {
    param([string]$Date, [string]$Proj, [string]$Kind, [string]$Text)
    $base = [string]$env:VAULT_REMOTE_URL
    $token = [string]$env:VAULT_AGENT_TOKEN
    if (-not $base.Trim() -or -not $token.Trim()) { return }
    $base = $base.TrimEnd('/')
    $uri = "$base/vault/v2/daily/$Date/projects/$Proj/events"
    try {
        $body = @{ kind = $Kind; text = $Text; source = 'append-daily' } | ConvertTo-Json -Compress
        Invoke-RestMethod -Method Post -Uri $uri -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json' -Body $body -TimeoutSec 8 | Out-Null
        Write-Output "REMOTE ok $uri"
    } catch {
        Write-Output "REMOTE skip: $($_.Exception.Message)"
    }
}

$date = Get-Date -Format 'yyyy-MM-dd'
$iso = Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'
$dailyFile = Join-Path $RepoRoot "vault\daily\${date}__${Project}.md"
$dailyDir = Split-Path -Parent $dailyFile

if (-not (Test-Path -LiteralPath $dailyDir)) {
    throw "Vault layout missing: run scripts/vault/bootstrap-vault.ps1 -Verify first"
}
if (-not (Test-Path -LiteralPath $dailyFile)) {
    New-DailyFromTemplate -Target $dailyFile -Template $TemplateFile -Date $date -Iso $iso -Proj $Project
    Write-Output "INIT daily created"
}

$content = Read-VaultText $dailyFile
$content = $content -replace "`r`n", "`n"

# Ensure project frontmatter
if ($content -match '(?m)^project:\s*') {
    $content = [regex]::Replace($content, '(?m)^project:\s*.*$', "project: `"$Project`"")
} else {
    $content = $content -replace '(?m)^(date:\s*.*)$', "`$1`nproject: `"$Project`""
}

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
        Send-VaultRemoteEvent -Date $date -Proj $Project -Kind 'bullet' -Text ($Bullet.Trim() -replace '^-+\s*', '')
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
        Send-VaultRemoteEvent -Date $date -Proj $Project -Kind 'issue' -Text $Issue.Trim()
    } else {
        Write-Output "SKIP duplicate issue row"
    }
}

Write-VaultText $dailyFile $content
Write-Output "OK runs=$runs project=$Project"
Write-Output $dailyFile
