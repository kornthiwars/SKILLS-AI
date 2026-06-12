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
$Assets = Join-Path $Vault 'assets'
$ScriptVault = Join-Path $RepoRoot 'scripts\vault'

$NoteDirs = @(
    'daily',
    'daily\archive',
    'decisions',
    'sessions',
    'projects',
    'inbox'
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
New-Item -ItemType Directory -Path $Assets -Force | Out-Null
New-Item -ItemType Directory -Path $Meta -Force | Out-Null

Ensure-FileFromTemplate (Join-Path $Meta 'tiers.json') (Join-Path $ScriptVault 'tiers.template.json')
Ensure-FileFromTemplate (Join-Path $Meta 'manifest.json') (Join-Path $ScriptVault 'manifest.template.json')

function Ensure-TodayDaily {
    param(
        [string]$NotesRoot,
        [string]$MetaRoot,
        [string]$TemplatesRoot
    )

    $date = Get-Date -Format 'yyyy-MM-dd'
    $iso = Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'
    $dailyFile = Join-Path $NotesRoot "daily\$date.md"
    $template = Join-Path $TemplatesRoot 'daily.template.md'

    if (-not (Test-Path -LiteralPath $dailyFile)) {
        if (-not (Test-Path -LiteralPath $template)) {
            throw "Missing template: $template"
        }
        $body = Get-Content -LiteralPath $template -Raw -Encoding UTF8
        $body = $body.Replace('DATE', $date).Replace('ISO', $iso)
        $parent = Split-Path -Parent $dailyFile
        if (-not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        [System.IO.File]::WriteAllText($dailyFile, $body, [System.Text.UTF8Encoding]::new($false))
        Write-Host "OK  daily seeded: notes/daily/$date.md"
    }

    $manifestPath = Join-Path $MetaRoot 'manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath)) { return }

    $manifestJson = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8
    $manifest = $manifestJson | ConvertFrom-Json
    $dailyId = "daily-$date"
    $hasDaily = $false
    if ($null -ne $manifest.docs) {
        foreach ($doc in @($manifest.docs)) {
            if ($doc.id -eq $dailyId) { $hasDaily = $true; break }
        }
    }

    if (-not $hasDaily) {
        $entry = [ordered]@{
            id      = $dailyId
            path    = "notes/daily/$date.md"
            title   = "Daily $date"
            tier    = 'episodic'
            project = ''
            status  = 'active'
            updated = $date
        }
        if ($null -eq $manifest.docs -or $manifest.docs.Count -eq 0) {
            $manifest.docs = @([pscustomobject]$entry)
        } else {
            $manifest.docs = @($manifest.docs) + @([pscustomobject]$entry)
        }
        $manifest.updated_at = $iso
        $out = $manifest | ConvertTo-Json -Depth 6
        [System.IO.File]::WriteAllText($manifestPath, $out, [System.Text.UTF8Encoding]::new($false))
        Write-Host "OK  manifest: $dailyId"
    }
}

Ensure-TodayDaily -NotesRoot $Notes -MetaRoot $Meta -TemplatesRoot $ScriptVault

if ($Verify) {
    $missing = @()
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
