#Requires -Version 5.1
# Migrate vault v1 (notes/* + _meta/) to Obsidian-native flat layout + _agent/.
param(
    [string]$RepoRoot = '',
    [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$Vault = Join-Path $RepoRoot 'vault'
$LegacyNotes = Join-Path $Vault 'notes'
$LegacyMeta = Join-Path $Vault '_meta'
$Agent = Join-Path $Vault '_agent'

$tierMap = @{
    'daily'     = 'daily'
    'decisions' = 'decisions'
    'sessions'  = 'sessions'
    'projects'  = 'projects'
}

function Move-TierFiles([string]$TierName) {
    $srcDir = Join-Path $LegacyNotes $TierName
    $destDir = Join-Path $Vault $TierName
    if (-not (Test-Path -LiteralPath $srcDir)) { return }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Get-ChildItem -LiteralPath $srcDir -File -ErrorAction SilentlyContinue | ForEach-Object {
        $dest = Join-Path $destDir $_.Name
        if (Test-Path -LiteralPath $dest) {
            throw "Collision: $dest already exists (will not overwrite)"
        }
        if ($WhatIf) {
            Write-Host "Would move: $($_.FullName) -> $dest"
        } else {
            Move-Item -LiteralPath $_.FullName -Destination $dest
            Write-Host "Moved: $($_.Name) -> $TierName/"
        }
    }
}

if (-not (Test-Path -LiteralPath $LegacyNotes) -and -not (Test-Path -LiteralPath $LegacyMeta)) {
    Write-Host "Nothing to migrate (no vault/notes/ or vault/_meta/)"
    exit 0
}

foreach ($tier in $tierMap.Keys) {
    Move-TierFiles $tier
}

if (Test-Path -LiteralPath $LegacyNotes) {
    $remaining = @(Get-ChildItem -LiteralPath $LegacyNotes -Recurse -File -ErrorAction SilentlyContinue)
    if ($remaining.Count -eq 0 -and -not $WhatIf) {
        Remove-Item -LiteralPath $LegacyNotes -Recurse -Force
        Write-Host "Removed empty vault/notes/"
    }
}

if (Test-Path -LiteralPath $LegacyMeta) {
    New-Item -ItemType Directory -Path $Agent -Force | Out-Null
    foreach ($file in @('manifest.json', 'tiers.json')) {
        $src = Join-Path $LegacyMeta $file
        $dest = Join-Path $Agent $file
        if (-not (Test-Path -LiteralPath $src)) { continue }
        if (Test-Path -LiteralPath $dest) {
            Write-Warning "Skipping $file - already exists in _agent/"
        } elseif ($WhatIf) {
            Write-Host "Would move: $src -> $dest"
        } else {
            Move-Item -LiteralPath $src -Destination $dest
            Write-Host "Moved: _meta/$file -> _agent/$file"
        }
    }
    if (-not $WhatIf) {
        $metaRemaining = @(Get-ChildItem -LiteralPath $LegacyMeta -File -ErrorAction SilentlyContinue)
        if ($metaRemaining.Count -eq 0) {
            Remove-Item -LiteralPath $LegacyMeta -Recurse -Force
            Write-Host "Removed empty vault/_meta/"
        }
    }
}

$manifestPath = Join-Path $Agent 'manifest.json'
if ((Test-Path -LiteralPath $manifestPath) -and -not $WhatIf) {
    $utf8 = New-Object System.Text.UTF8Encoding $false
    $json = [System.IO.File]::ReadAllText($manifestPath, $utf8)
    $updated = $json `
        -replace 'notes/daily/', 'daily/' `
        -replace 'notes/decisions/', 'decisions/' `
        -replace 'notes/sessions/', 'sessions/' `
        -replace 'notes/projects/', 'projects/'
    if ($updated -match '"schema_version"\s*:\s*1') {
        $updated = $updated -replace '"schema_version"\s*:\s*1', '"schema_version": 2'
    }
    if ($updated -ne $json) {
        [System.IO.File]::WriteAllText($manifestPath, $updated, $utf8)
        Write-Host "Rewrote manifest paths (schema v2)"
    }
}

$tiersPath = Join-Path $Agent 'tiers.json'
if ((Test-Path -LiteralPath $tiersPath) -and -not $WhatIf) {
    $utf8 = New-Object System.Text.UTF8Encoding $false
    $json = [System.IO.File]::ReadAllText($tiersPath, $utf8)
    if ($json -match 'notes/') {
        $updated = $json `
            -replace '"notes/daily"', '"daily"' `
            -replace '"notes/decisions"', '"decisions"' `
            -replace '"notes/sessions"', '"sessions"' `
            -replace '"notes/projects"', '"projects"' `
            -replace 'notes/daily/\*\*', 'daily/**'
        if ($updated -match '"schema_version"\s*:\s*1') {
            $updated = $updated -replace '"schema_version"\s*:\s*1', '"schema_version": 2'
        }
        [System.IO.File]::WriteAllText($tiersPath, $updated, $utf8)
        Write-Host "Rewrote tiers.json paths (schema v2)"
    }
}

Write-Host "OK  migrate-vault complete. Run bootstrap-vault -Verify to confirm layout."
