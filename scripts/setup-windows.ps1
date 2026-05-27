#Requires -Version 5.1
# Junction .cursor/skills, .cursor/rules, .cursor/vault + ai-skills-vault.json
param(
    [Parameter(Mandatory)]
    [string]$InstallRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$InstallRoot = (Resolve-Path -LiteralPath $InstallRoot).Path

$Skills = Join-Path $RepoRoot 'ai-skills'
$Rules = Join-Path $RepoRoot 'ai-rules'
$Vault = Join-Path $RepoRoot 'vault'

foreach ($dir in @($Skills, $Rules, $Vault)) {
    if (-not (Test-Path -LiteralPath $dir)) {
        throw "Missing: $dir"
    }
}

function Set-Junction([string]$Link, [string]$Target) {
    $targetAbs = (Resolve-Path -LiteralPath $Target).Path
    $parent = Split-Path -Parent $Link
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    if (Test-Path -LiteralPath $Link) {
        $item = Get-Item -LiteralPath $Link -Force
        if ($item.LinkType -eq 'Junction') {
            $current = $item.Target
            if ($current -is [array]) { $current = $current[0] }
            if ($current -eq $targetAbs) {
                Write-Host "OK  $Link"
                return
            }
        }
        Remove-Item -LiteralPath $Link -Force -Recurse
    }
    $out = cmd /c mklink /J "`"$Link`"" "`"$targetAbs`"" 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "mklink failed: $out`nRun PowerShell as Administrator once."
    }
    Write-Host "OK  $Link -> $targetAbs"
}

function Write-VaultPointer {
    $cursorDir = Join-Path $InstallRoot '.cursor'
    if (-not (Test-Path -LiteralPath $cursorDir)) {
        New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
    }

    $vaultRootAbs = (Resolve-Path -LiteralPath $Vault).Path
    $json = @{
        repoRoot          = $RepoRoot
        vaultRoot         = $vaultRootAbs
        issuesRelative    = '.cursor/vault/issues'
        learningsRelative = '.cursor/vault/learnings'
    } | ConvertTo-Json -Compress

    $path = Join-Path $cursorDir 'ai-skills-vault.json'
    [IO.File]::WriteAllText($path, $json, [Text.UTF8Encoding]::new($false))
    Write-Host "OK  $path"
}

function Ensure-VaultFolders {
    foreach ($rel in @('issues', 'learnings')) {
        $path = Join-Path $Vault $rel
        if (-not (Test-Path -LiteralPath $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-Host "OK  created vault/$rel"
        }
    }
}

function Bootstrap-DailyIssues {
    $today = Get-Date -Format 'yyyy-MM-dd'
    $file = Join-Path $Vault "issues\$today.md"
    if (Test-Path -LiteralPath $file) {
        Write-Host "OK  vault/issues/$today.md"
        return
    }

    $template = Join-Path $RepoRoot 'templates\template.issue.md'
    if (-not (Test-Path -LiteralPath $template)) {
        Write-Host '..  skip daily issues (no template)'
        return
    }

    $content = (Get-Content -LiteralPath $template -Raw -Encoding UTF8).Replace('{{YYYY-MM-DD}}', $today)
    [IO.File]::WriteAllText($file, $content, [Text.UTF8Encoding]::new($false))
    Write-Host "OK  created vault/issues/$today.md"
}

Write-Host "Install: $InstallRoot"
Write-Host "Repo:    $RepoRoot"
Write-Host ""

Set-Junction (Join-Path $InstallRoot '.cursor\skills') $Skills
Set-Junction (Join-Path $InstallRoot '.cursor\rules')  $Rules
Set-Junction (Join-Path $InstallRoot '.cursor\vault')  $Vault

Write-VaultPointer
Ensure-VaultFolders
Bootstrap-DailyIssues

Write-Host ""
Write-Host "Done. Reload Cursor."
