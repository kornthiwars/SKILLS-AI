#Requires -Version 5.1
# Junction .cursor/skills, .cursor/rules, .cursor/vault + ai-skills-vault.json
# Subprojects: vault-only wire for monorepo siblings (auto when agent-skills is child of install root).
param(
    [string]$InstallRoot = '',
    [string]$Subprojects = '',
    [switch]$NoAutoSubprojects
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

switch ($InstallRoot) {
    { $_ -in '', '--parent', 'parent' } {
        $InstallRoot = (Resolve-Path (Join-Path $RepoRoot '..')).Path
    }
    { $_ -in '--here', 'here', '.' } {
        $InstallRoot = $RepoRoot
    }
    default {
        $InstallRoot = (Resolve-Path -LiteralPath $InstallRoot).Path
    }
}

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

function Write-VaultPointerAt([string]$CursorDir) {
    if (-not (Test-Path -LiteralPath $CursorDir)) {
        New-Item -ItemType Directory -Path $CursorDir -Force | Out-Null
    }

    $vaultRootAbs = (Resolve-Path -LiteralPath $Vault).Path
    $json = @{
        repoRoot          = $RepoRoot
        vaultRoot         = $vaultRootAbs
        issuesRelative    = '.cursor/vault/issues'
        workdayRelative   = '.cursor/vault/workday'
        wikiRelative      = '.cursor/vault/wiki'
    } | ConvertTo-Json -Compress

    $path = Join-Path $CursorDir 'ai-skills-vault.json'
    [IO.File]::WriteAllText($path, $json, [Text.UTF8Encoding]::new($false))
    Write-Host "OK  $path"
}

function Write-VaultPointer {
    Write-VaultPointerAt (Join-Path $InstallRoot '.cursor')
}

function Wire-SubprojectVault([string]$SubRoot) {
    if (-not (Test-Path -LiteralPath $SubRoot)) { return }
    $subAbs = (Resolve-Path -LiteralPath $SubRoot).Path
    if ($subAbs -eq $InstallRoot) { return }

    $cursorDir = Join-Path $subAbs '.cursor'
    Set-Junction (Join-Path $cursorDir 'vault') $Vault
    Write-VaultPointerAt $cursorDir
    Write-Host "OK  subproject vault: $subAbs"
}

function Get-SubprojectRoots {
    if ($Subprojects) {
        foreach ($name in ($Subprojects -split ',')) {
            $name = $name.Trim()
            if (-not $name) { continue }
            if (Test-Path -LiteralPath $name) {
                (Resolve-Path -LiteralPath $name).Path
            } elseif (Test-Path -LiteralPath (Join-Path $InstallRoot $name)) {
                (Resolve-Path -LiteralPath (Join-Path $InstallRoot $name)).Path
            } else {
                Write-Host "..  skip subproject (missing): $name"
            }
        }
        return
    }

    if ($NoAutoSubprojects) { return }

    $agentSkillsInInstall = Join-Path $InstallRoot 'agent-skills'
    if (-not (Test-Path -LiteralPath $agentSkillsInInstall)) { return }
    $repoAbs = (Resolve-Path -LiteralPath $RepoRoot).Path
    $agentAbs = (Resolve-Path -LiteralPath $agentSkillsInInstall).Path
    if ($agentAbs -ne $repoAbs) { return }

    Get-ChildItem -LiteralPath $InstallRoot -Directory | ForEach-Object {
        if ($_.FullName -eq $agentAbs) { return }
        $_.FullName
    }
}

function Ensure-VaultFolders {
    foreach ($rel in @('issues', 'workday', 'workday/plans', 'wiki', 'wiki/pages', 'wiki/sources')) {
        $path = Join-Path $Vault $rel
        if (-not (Test-Path -LiteralPath $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-Host "OK  created vault/$rel"
        }
    }
}

function Bootstrap-WikiFiles {
    $today = Get-Date -Format 'yyyy-MM-dd'
    $wikiDir = Join-Path $Vault 'wiki'

    $indexFile = Join-Path $wikiDir 'index.md'
    if (Test-Path -LiteralPath $indexFile) {
        Write-Host 'OK  vault/wiki/index.md'
    } else {
        $template = Join-Path $RepoRoot 'templates\template.wiki-index.md'
        if (-not (Test-Path -LiteralPath $template)) {
            Write-Host '..  skip wiki index (no template)'
        } else {
            $content = (Get-Content -LiteralPath $template -Raw -Encoding UTF8).Replace('{{YYYY-MM-DD}}', $today)
            [IO.File]::WriteAllText($indexFile, $content, [Text.UTF8Encoding]::new($false))
            Write-Host 'OK  created vault/wiki/index.md'
        }
    }

    $logFile = Join-Path $wikiDir 'log.md'
    if (Test-Path -LiteralPath $logFile) {
        Write-Host 'OK  vault/wiki/log.md'
    } else {
        $template = Join-Path $RepoRoot 'templates\template.wiki-log.md'
        if (-not (Test-Path -LiteralPath $template)) {
            Write-Host '..  skip wiki log (no template)'
        } else {
            $content = (Get-Content -LiteralPath $template -Raw -Encoding UTF8).Replace('{{YYYY-MM-DD}}', $today)
            [IO.File]::WriteAllText($logFile, $content, [Text.UTF8Encoding]::new($false))
            Write-Host 'OK  created vault/wiki/log.md'
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

function Remove-InRepoCursorIfNeeded {
    if ($InstallRoot -eq $RepoRoot) { return }
    $skillsLink = Join-Path $RepoRoot '.cursor\skills'
    if (-not (Test-Path -LiteralPath $skillsLink)) { return }
    $item = Get-Item -LiteralPath $skillsLink -Force
    if ($item.LinkType -ne 'Junction') { return }
    $current = $item.Target
    if ($current -is [array]) { $current = $current[0] }
    $skillsAbs = (Resolve-Path -LiteralPath $Skills).Path
    if ($current -ne $skillsAbs) { return }
    Remove-Item -LiteralPath (Join-Path $RepoRoot '.cursor') -Force -Recurse
    Write-Host 'OK  removed in-repo .cursor (links now at parent)'
}

Write-Host "Install: $InstallRoot"
Write-Host "Repo:    $RepoRoot"
Write-Host ""

Remove-InRepoCursorIfNeeded

Set-Junction (Join-Path $InstallRoot '.cursor\skills') $Skills
Set-Junction (Join-Path $InstallRoot '.cursor\rules')  $Rules
Set-Junction (Join-Path $InstallRoot '.cursor\vault')  $Vault

Write-VaultPointer
Ensure-VaultFolders
Bootstrap-WikiFiles
Bootstrap-DailyIssues

foreach ($subRoot in Get-SubprojectRoots) {
    if ($subRoot) { Wire-SubprojectVault $subRoot }
}

Write-Host ""
Write-Host "Done. Reload Cursor."
