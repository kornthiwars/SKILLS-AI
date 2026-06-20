# Static preflight for DYNAMIC-AGENT-SMOKE — run before behavioral scenarios in Cursor.
# Usage: powershell -NoProfile -File scripts/smoke-preflight.ps1

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
& (Join-Path $PSScriptRoot 'validate-skills.ps1')
Write-Host 'OK smoke-preflight: validate-skills passed. Run behavioral scenarios in fresh chat after Reload Cursor — docs/DYNAMIC-AGENT-SMOKE.md'
