#Requires -Version 5.1
# Bootstrap Obsidian-native vault layout + _agent catalog (no Python).
param(
    [string]$RepoRoot = '',
    [switch]$Verify,
    [switch]$RefreshTemplates
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
$TemplatesRuntime = Join-Path $Vault 'Templates'
$TemplatesPack = Join-Path $RepoRoot 'templates\vault'
$MetaPack = Join-Path $TemplatesPack 'meta'
$NotesPack = Join-Path $TemplatesPack 'notes'
$ObsidianPack = Join-Path $TemplatesPack 'obsidian'
$ObsidianRuntime = Join-Path $Vault '.obsidian'

$NoteDirs = @('daily', 'decisions', 'sessions', 'projects')

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

function Copy-TemplateNote([string]$Name, [switch]$ForceRefresh) {
    $src = Join-Path $NotesPack $Name
    $dest = Join-Path $TemplatesRuntime $Name
    if (-not (Test-Path -LiteralPath $src)) {
        throw "Missing pack template: $src"
    }
    if ($ForceRefresh -and (Test-Path -LiteralPath $dest)) { return $false }
    if (Test-Path -LiteralPath $dest) { return $false }
    Copy-Item -LiteralPath $src -Destination $dest -Force
    return $true
}

New-Item -ItemType Directory -Path $Vault -Force | Out-Null
$gitkeep = Join-Path $Vault '.gitkeep'
if (-not (Test-Path -LiteralPath $gitkeep)) { New-Item -ItemType File -Path $gitkeep -Force | Out-Null }

foreach ($name in $NoteDirs) {
    New-Item -ItemType Directory -Path (Join-Path $Vault $name) -Force | Out-Null
}
New-Item -ItemType Directory -Path $Agent -Force | Out-Null
New-Item -ItemType Directory -Path $TemplatesRuntime -Force | Out-Null

Ensure-FileFromTemplate (Join-Path $Agent 'tiers.json') (Join-Path $MetaPack 'tiers.template.json') | Out-Null
Ensure-FileFromTemplate (Join-Path $Agent 'manifest.json') (Join-Path $MetaPack 'manifest.template.json') | Out-Null

$homeTemplate = Join-Path $NotesPack 'template.vault-home.md'
$homeTarget = Join-Path $Vault 'Home.md'
if (-not (Test-Path -LiteralPath $homeTarget)) {
    if (-not (Test-Path -LiteralPath $homeTemplate)) {
        throw "Missing template: $homeTemplate"
    }
    $today = Get-Date -Format 'yyyy-MM-dd'
    $content = [System.IO.File]::ReadAllText($homeTemplate)
    $content = $content -replace 'UPDATED', $today
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($homeTarget, $content, $utf8)
}

$templateNames = @(
    'template.vault-daily.md',
    'template.vault-session.md',
    'template.vault-decision.md',
    'template.vault-project.md'
)
foreach ($t in $templateNames) {
    if ($RefreshTemplates) {
        $src = Join-Path $NotesPack $t
        $dest = Join-Path $TemplatesRuntime $t
        if (Test-Path -LiteralPath $src) {
            Copy-Item -LiteralPath $src -Destination $dest -Force
        }
    } else {
        Copy-TemplateNote $t | Out-Null
    }
}

if (Test-Path -LiteralPath $ObsidianPack) {
    New-Item -ItemType Directory -Path $ObsidianRuntime -Force | Out-Null
    Get-ChildItem -LiteralPath $ObsidianPack -File | ForEach-Object {
        Copy-IfMissing $_.FullName (Join-Path $ObsidianRuntime $_.Name) | Out-Null
    }
}

$legacyNotes = Join-Path $Vault 'notes'
$legacyMeta = Join-Path $Vault '_meta'
if ((Test-Path -LiteralPath $legacyNotes) -or (Test-Path -LiteralPath $legacyMeta)) {
    Write-Warning "Legacy layout detected (vault/notes/ or vault/_meta/). Run: scripts/vault/migrate-vault.ps1"
}

if ($Verify) {
    $missing = @()
    foreach ($name in $NoteDirs) {
        if (-not (Test-Path -LiteralPath (Join-Path $Vault $name))) { $missing += $name }
    }
    foreach ($file in @('tiers.json', 'manifest.json')) {
        if (-not (Test-Path -LiteralPath (Join-Path $Agent $file))) { $missing += "_agent/$file" }
    }
    if (-not (Test-Path -LiteralPath $TemplatesRuntime)) { $missing += 'Templates/' }
    if ($missing.Count -gt 0) {
        throw "Verify failed: missing $($missing -join ', ')"
    }
}

Write-Host "OK  vault bootstrap: $Vault"
