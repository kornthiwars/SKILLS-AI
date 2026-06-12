#Requires -Version 5.1
# Bootstrap vault/notes layout + _meta for agent-only memory (no Python).
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
$Notes = Join-Path $Vault 'notes'
$Meta = Join-Path $Vault '_meta'
$ScriptVault = Join-Path $RepoRoot 'scripts\vault'

$NoteDirs = @(
    'daily',
    'decisions',
    'sessions',
    'projects'
)

function Ensure-FileFromTemplate([string]$Target, [string]$Template) {
    if (Test-Path -LiteralPath $Target) { return }
    if (-not (Test-Path -LiteralPath $Template)) {
        throw "Missing template: $Template"
    }
    $parent = Split-Path -Parent $Target
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -LiteralPath $Template -Destination $Target -Force
}

New-Item -ItemType Directory -Path $Vault -Force | Out-Null
$gitkeep = Join-Path $Vault '.gitkeep'
if (-not (Test-Path -LiteralPath $gitkeep)) { New-Item -ItemType File -Path $gitkeep -Force | Out-Null }

foreach ($name in $NoteDirs) {
    New-Item -ItemType Directory -Path (Join-Path $Notes $name) -Force | Out-Null
}
New-Item -ItemType Directory -Path $Meta -Force | Out-Null

Ensure-FileFromTemplate (Join-Path $Meta 'tiers.json') (Join-Path $ScriptVault 'tiers.template.json')
Ensure-FileFromTemplate (Join-Path $Meta 'manifest.json') (Join-Path $ScriptVault 'manifest.template.json')

if ($Verify) {    $missing = @()
    foreach ($name in $NoteDirs) {
        if (-not (Test-Path -LiteralPath (Join-Path $Notes $name))) { $missing += $name }
    }
    foreach ($file in @('tiers.json', 'manifest.json')) {
        if (-not (Test-Path -LiteralPath (Join-Path $Meta $file))) { $missing += "_meta/$file" }
    }
    if ($missing.Count -gt 0) {
        throw "Verify failed: missing $($missing -join ', ')"
    }
}

Write-Host "OK  vault bootstrap: $Vault"
