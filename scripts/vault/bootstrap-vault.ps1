#Requires -Version 5.1
# Bootstrap greenfield vault: projects/{slug}/{hub,daily,sessions,decisions} + _agent + .obsidian
# PackRoot (templates) = script pack; Vault runtime = RepoRoot
param(
    [string]$RepoRoot = '',
    [string]$Project = '',
    [switch]$Verify
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$PackRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
if (-not $RepoRoot) {
    $RepoRoot = $PackRoot
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

if (-not $Project.Trim()) {
    $Project = [string]$env:VAULT_PROJECT
}

$Vault = Join-Path $RepoRoot 'vault'
$Agent = Join-Path $Vault '_agent'
$ProjectsRoot = Join-Path $Vault 'projects'
$TemplatesPack = Join-Path $PackRoot 'templates\vault'
$MetaPack = Join-Path $TemplatesPack 'meta'
$NotesPack = Join-Path $TemplatesPack 'notes'
$ObsidianPack = Join-Path $TemplatesPack 'obsidian'
$ObsidianRuntime = Join-Path $Vault '.obsidian'
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

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

function Write-VaultText([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Ensure-ProjectTree {
    param([string]$Slug)
    $slug = $Slug.Trim().ToLowerInvariant()
    if ($slug -notmatch '^[a-z0-9_-]+$' -or $slug.Length -gt 64) {
        throw "Project slug must be [a-z0-9_-] length 1-64"
    }
    $root = Join-Path $ProjectsRoot $slug
    foreach ($sub in @('daily', 'sessions', 'decisions')) {
        New-Item -ItemType Directory -Path (Join-Path $root $sub) -Force | Out-Null
    }
    $hub = Join-Path $root 'hub.md'
    $hubTemplate = Join-Path $NotesPack 'template.vault-project.md'
    if (-not (Test-Path -LiteralPath $hub)) {
        if (-not (Test-Path -LiteralPath $hubTemplate)) {
            throw "Missing template: $hubTemplate"
        }
        $iso = Get-Date -Format 'yyyy-MM-dd'
        $content = [System.IO.File]::ReadAllText($hubTemplate, [System.Text.Encoding]::UTF8)
        $content = $content.Replace('proj-SLUG', "proj-$slug").Replace('TITLE', $slug).Replace('"PROJECT"', "`"$slug`"").Replace('CREATED', $iso).Replace('UPDATED', $iso)
        $content = $content.Replace('[[sessions/slug]]', "[[projects/$slug/sessions/]]").Replace('[[decisions/slug]]', "[[projects/$slug/decisions/]]")
        Write-VaultText $hub $content
        Write-Host "INIT hub: $hub"
    }
    $date = Get-Date -Format 'yyyy-MM-dd'
    $dailyIso = Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'
    $dailyFile = Join-Path $root "daily\$date.md"
    $dailyTemplate = Join-Path $NotesPack 'template.vault-daily.md'
    if (-not (Test-Path -LiteralPath $dailyFile)) {
        if (-not (Test-Path -LiteralPath $dailyTemplate)) {
            throw "Missing template: $dailyTemplate"
        }
        $dailyId = "daily-${date}__${slug}"
        $content = [System.IO.File]::ReadAllText($dailyTemplate, [System.Text.Encoding]::UTF8)
        $content = $content.Replace('__VAULT_DAILY_ID__', $dailyId).Replace('__VAULT_DATE__', $date).Replace('__VAULT_ISO__', $dailyIso).Replace('__VAULT_PROJECT__', $slug)
        Write-VaultText $dailyFile $content
        Write-Host "INIT daily: $dailyFile"
    }
    return $root
}

New-Item -ItemType Directory -Path $Vault -Force | Out-Null
$gitkeep = Join-Path $Vault '.gitkeep'
if (-not (Test-Path -LiteralPath $gitkeep)) { New-Item -ItemType File -Path $gitkeep -Force | Out-Null }
New-Item -ItemType Directory -Path $ProjectsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $Agent -Force | Out-Null

Ensure-FileFromTemplate (Join-Path $Agent 'tiers.json') (Join-Path $MetaPack 'tiers.template.json') | Out-Null
Ensure-FileFromTemplate (Join-Path $Agent 'manifest.json') (Join-Path $MetaPack 'manifest.template.json') | Out-Null

if (Test-Path -LiteralPath $ObsidianPack) {
    New-Item -ItemType Directory -Path $ObsidianRuntime -Force | Out-Null
    Get-ChildItem -LiteralPath $ObsidianPack -File | ForEach-Object {
        Copy-IfMissing $_.FullName (Join-Path $ObsidianRuntime $_.Name) | Out-Null
    }
}

if ($Project.Trim()) {
    Ensure-ProjectTree -Slug $Project | Out-Null
} else {
    Write-Host "SKIP project subtree - set VAULT_PROJECT or -Project to seed projects/{slug}/"
}

if ($Verify) {
    $missing = @()
    if (-not (Test-Path -LiteralPath $ProjectsRoot)) { $missing += 'projects' }
    foreach ($file in @('tiers.json', 'manifest.json')) {
        if (-not (Test-Path -LiteralPath (Join-Path $Agent $file))) { $missing += "_agent/$file" }
    }
    foreach ($t in $PackTemplateNames) {
        if (-not (Test-Path -LiteralPath (Join-Path $NotesPack $t))) { $missing += "templates/vault/notes/$t" }
    }
    if ($Project.Trim()) {
        $slug = $Project.Trim().ToLowerInvariant()
        $root = Join-Path $ProjectsRoot $slug
        foreach ($sub in @('daily', 'sessions', 'decisions')) {
            if (-not (Test-Path -LiteralPath (Join-Path $root $sub))) { $missing += "projects/$slug/$sub" }
        }
        if (-not (Test-Path -LiteralPath (Join-Path $root 'hub.md'))) { $missing += "projects/$slug/hub.md" }
    }
    if ($missing.Count -gt 0) {
        throw "Verify failed: missing $($missing -join ', ')"
    }
}

Write-Host "OK  vault bootstrap: $Vault"
