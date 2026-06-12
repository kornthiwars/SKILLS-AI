#Requires -Version 5.1
# Bootstrap Obsidian-native vault layout + _agent catalog (no Python).
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
$LegacyTemplates = Join-Path $Vault 'Templates'

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

function Remove-LegacyTemplatesDir {
    if (-not (Test-Path -LiteralPath $LegacyTemplates)) { return }

    $item = Get-Item -LiteralPath $LegacyTemplates -Force
    if ($item.LinkType) {
        Write-Warning "vault/Templates is a link — remove manually if you want pack-only templates."
        return
    }

    $files = Get-ChildItem -LiteralPath $LegacyTemplates -File -ErrorAction SilentlyContinue
    if (-not $files -or $files.Count -eq 0) {
        Remove-Item -LiteralPath $LegacyTemplates -Force -Recurse
        Write-Host "Removed empty vault/Templates/ (schemas live in templates/vault/notes/)."
        return
    }

    $unexpected = @()
    foreach ($file in $files) {
        $packFile = Join-Path $NotesPack $file.Name
        if (-not (Test-Path -LiteralPath $packFile)) {
            $unexpected += $file.Name
            continue
        }
        $packHash = (Get-FileHash -LiteralPath $packFile -Algorithm SHA256).Hash
        $runtimeHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        if ($packHash -ne $runtimeHash) {
            $unexpected += $file.Name
        }
    }

    if ($unexpected.Count -gt 0) {
        Write-Warning "vault/Templates/ has custom or unknown files ($($unexpected -join ', ')) — not removed."
        return
    }

    Remove-Item -LiteralPath $LegacyTemplates -Force -Recurse
    Write-Host "Removed vault/Templates/ copy (use templates/vault/notes/ in git)."
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

Remove-LegacyTemplatesDir

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
    foreach ($t in $PackTemplateNames) {
        if (-not (Test-Path -LiteralPath (Join-Path $NotesPack $t))) { $missing += "templates/vault/notes/$t" }
    }
    if ($missing.Count -gt 0) {
        throw "Verify failed: missing $($missing -join ', ')"
    }
}

Write-Host "OK  vault bootstrap: $Vault"
