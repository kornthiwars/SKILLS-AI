#Requires -Version 5.1
# Bootstrap Obsidian-native vault layout + _agent catalog (no Python).
# Seeds vault/daily/YYYY-MM-DD.md from template when missing.
param(
    [string]$RepoRoot = '',
    [switch]$Verify
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$Vault = Join-Path $RepoRoot 'vault'
$Agent = Join-Path $Vault '_agent'
$TemplatesPack = Join-Path $RepoRoot 'templates\vault'
$MetaPack = Join-Path $TemplatesPack 'meta'
$NotesPack = Join-Path $TemplatesPack 'notes'
$ObsidianPack = Join-Path $TemplatesPack 'obsidian'
$ObsidianRuntime = Join-Path $Vault '.obsidian'

$NoteDirs = @('daily', 'decisions', 'sessions', 'projects')

$PackTemplateNames = @(
    'template.vault-daily.md',
    'template.vault-session.md',
    'template.vault-decision.md',
    'template.vault-project.md'
)

function Ensure-FileFromTemplate([string]$Target, [string]$Template) {
    if (Test-Path -LiteralPath $Target) { return $false }
    if (-not (Test-Path -LiteralPath $Template)) {
        throw "Missing template: $Template"
    }
    $parent = Split-Path -Parent $Target
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -LiteralPath $Template -Destination $Target -Force
    return $true
}

function Copy-IfMissing([string]$Source, [string]$Dest) {
    if (Test-Path -LiteralPath $Dest) { return $false }
    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Missing seed: $Source"
    }
    $parent = Split-Path -Parent $Dest
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -LiteralPath $Source -Destination $Dest -Force
    return $true
}

function Ensure-TodayDaily {
    param([string]$DailyDir, [string]$TemplateFile)
    $date = Get-Date -Format 'yyyy-MM-dd'
    $iso = Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'
    $dailyFile = Join-Path $DailyDir "$date.md"
    if (Test-Path -LiteralPath $dailyFile) { return $false }
    if (-not (Test-Path -LiteralPath $TemplateFile)) {
        throw "Missing template: $TemplateFile"
    }
    $utf8 = New-Object System.Text.UTF8Encoding $false
    $content = [System.IO.File]::ReadAllText($TemplateFile, $utf8)
    $content = $content.Replace('__VAULT_DATE__', $date).Replace('__VAULT_ISO__', $iso)
    [System.IO.File]::WriteAllText($dailyFile, $content, $utf8)
    Write-Host "INIT daily created: $dailyFile"
    return $true
}

New-Item -ItemType Directory -Path $Vault -Force | Out-Null
$gitkeep = Join-Path $Vault '.gitkeep'
if (-not (Test-Path -LiteralPath $gitkeep)) { New-Item -ItemType File -Path $gitkeep -Force | Out-Null }

foreach ($name in $NoteDirs) {
    New-Item -ItemType Directory -Path (Join-Path $Vault $name) -Force | Out-Null
}
New-Item -ItemType Directory -Path $Agent -Force | Out-Null

Ensure-FileFromTemplate (Join-Path $Agent 'tiers.json') (Join-Path $MetaPack 'tiers.template.json') | Out-Null
Ensure-FileFromTemplate (Join-Path $Agent 'manifest.json') (Join-Path $MetaPack 'manifest.template.json') | Out-Null

if (Test-Path -LiteralPath $ObsidianPack) {
    New-Item -ItemType Directory -Path $ObsidianRuntime -Force | Out-Null
    Get-ChildItem -LiteralPath $ObsidianPack -File | ForEach-Object {
        Copy-IfMissing $_.FullName (Join-Path $ObsidianRuntime $_.Name) | Out-Null
    }
}

$dailyDir = Join-Path $Vault 'daily'
$dailyTemplate = Join-Path $NotesPack 'template.vault-daily.md'
Ensure-TodayDaily -DailyDir $dailyDir -TemplateFile $dailyTemplate | Out-Null

if ($Verify) {
    $missing = @()
    foreach ($name in $NoteDirs) {
        if (-not (Test-Path -LiteralPath (Join-Path $Vault $name))) { $missing += $name }
    }
    foreach ($file in @('tiers.json', 'manifest.json')) {
        if (-not (Test-Path -LiteralPath (Join-Path $Agent $file))) { $missing += "_agent/$file" }
    }
    foreach ($t in $PackTemplateNames) {
        if (-not (Test-Path -LiteralPath (Join-Path $NotesPack $t))) { $missing += "templates/vault/notes/$t" }
    }
    if ($missing.Count -gt 0) {
        throw "Verify failed: missing $($missing -join ', ')"
    }
}

Write-Host "OK  vault bootstrap: $Vault"
