# Cursor afterFileEdit hook — incremental vault index (fail open)
$ErrorActionPreference = 'Continue'
$inputRaw = [Console]::In.ReadToEnd()
try {
    $payload = $inputRaw | ConvertFrom-Json
    $filePath = [string]$payload.file_path
    if ($filePath -notmatch '[\\/]vault[\\/]notes[\\/]') { exit 0 }
    if ($filePath -match '[\\/]daily[\\/]' -or $filePath -match '[\\/]inbox[\\/]') { exit 0 }

    $installRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    $vaultLink = Join-Path $installRoot '.cursor\vault'
    if (-not (Test-Path -LiteralPath $vaultLink)) { exit 0 }
    $vaultItem = Get-Item -LiteralPath $vaultLink -Force
    if ($vaultItem.LinkType -ne 'Junction') { exit 0 }
    $target = $vaultItem.Target
    if ($target -is [array]) { $target = $target[0] }
    $repoRoot = Split-Path -Parent $target
    $indexPy = Join-Path $repoRoot 'scripts\vault\index.py'
    if (-not (Test-Path -LiteralPath $indexPy)) { exit 0 }

    $pythonArgs = $null
    $null = py -3 --version 2>$null
    if ($LASTEXITCODE -eq 0) { $pythonArgs = @('py', '-3') }
    else {
        $null = python --version 2>$null
        if ($LASTEXITCODE -eq 0) { $pythonArgs = @('python') }
    }
    if (-not $pythonArgs) { exit 0 }

    Push-Location $repoRoot
    try {
        if ($pythonArgs.Count -eq 2) {
            & $pythonArgs[0] $pythonArgs[1] $indexPy 2>&1 | Out-Null
        } else {
            & $pythonArgs[0] $indexPy 2>&1 | Out-Null
        }
    } finally {
        Pop-Location
    }
} catch {
    exit 0
}
exit 0
