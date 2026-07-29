#Requires -Version 5.1
# Search vault notes (gitignored) - uses rg --no-ignore; roots from _agent/tiers.json.
param(
    [Parameter(Mandatory = $true)]
    [string]$Pattern,
    [ValidateSet('all', 'decisions', 'sessions', 'projects', 'daily')]
    [string]$Tier = 'all',
    [int]$MaxResults = 30,
    [string]$RepoRoot = '',
    [string]$Project = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$Vault = Join-Path $RepoRoot 'vault'
$ProjectsRoot = Join-Path $Vault 'projects'
$TiersFile = Join-Path $Vault '_agent\tiers.json'
$slug = if ($Project.Trim()) { $Project.Trim().ToLowerInvariant() } else { '' }

function Get-TierRoots {
    $defaults = @('projects')
    if (-not (Test-Path -LiteralPath $TiersFile)) {
        return $defaults | ForEach-Object { Join-Path $Vault $_ }
    }
    $json = Get-Content -LiteralPath $TiersFile -Raw -Encoding UTF8 | ConvertFrom-Json
    $recall = @($json.recall_search_tiers)
    if ($recall.Count -eq 0) {
        return $defaults | ForEach-Object { Join-Path $Vault $_ }
    }
    return $recall | ForEach-Object {
        $rel = $_ -replace '^notes/', ''
        Join-Path $Vault ($rel -replace '/', '\')
    }
}

$searchRoots = switch ($Tier) {
    'decisions' {
        if ($slug) { @(Join-Path $ProjectsRoot "$slug\decisions") }
        else { @(Join-Path $ProjectsRoot) }
    }
    'sessions' {
        if ($slug) { @(Join-Path $ProjectsRoot "$slug\sessions") }
        else { @(Join-Path $ProjectsRoot) }
    }
    'projects' {
        if ($slug) { @(Join-Path $ProjectsRoot $slug) }
        else { @(Join-Path $ProjectsRoot) }
    }
    'daily' {
        if ($slug) { @(Join-Path $ProjectsRoot "$slug\daily") }
        else { @(Join-Path $ProjectsRoot) }
    }
    default { @(Get-TierRoots) }
}

$existing = @($searchRoots | Where-Object { Test-Path -LiteralPath $_ })
if ($existing.Count -eq 0) {
    Write-Output '[]'
    exit 0
}

$rg = Get-Command rg -ErrorAction SilentlyContinue
$results = [System.Collections.Generic.List[object]]::new()
$globFilter = switch ($Tier) {
    'decisions' { if (-not $slug) { '**/decisions/**/*.md' } else { $null } }
    'sessions'  { if (-not $slug) { '**/sessions/**/*.md' } else { $null } }
    'daily'     { if (-not $slug) { '**/daily/**/*.md' } else { $null } }
    default     { $null }
}

if ($rg) {
    foreach ($root in $existing) {
        $rgArgs = @('--no-ignore', '-n', '--max-count', "$MaxResults", $Pattern, $root)
        if ($globFilter) { $rgArgs = @('--no-ignore', '-n', '--max-count', "$MaxResults", '-g', $globFilter, $Pattern, $root) }
        $out = @(& rg @rgArgs 2>&1)
        if ($LASTEXITCODE -gt 1) {
            throw "rg failed (exit $LASTEXITCODE): $($out -join '; ')"
        }
        foreach ($line in $out) {
            if ($line -match '^(.+):(\d+):(.+)$') {
                $rel = $Matches[1].Substring($RepoRoot.Length).TrimStart('\', '/').Replace('\', '/')
                $results.Add([ordered]@{
                        path    = $rel
                        line    = [int]$Matches[2]
                        excerpt = $Matches[3].Trim()
                    })
            }
            if ($results.Count -ge $MaxResults) { break }
        }
        if ($results.Count -ge $MaxResults) { break }
    }
} else {
    foreach ($root in $existing) {
        Get-ChildItem -LiteralPath $root -Filter '*.md' -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
            $file = $_
            $norm = $file.FullName.Replace('\', '/')
            if ($Tier -eq 'decisions' -and $norm -notmatch '/decisions/') { return }
            if ($Tier -eq 'sessions' -and $norm -notmatch '/sessions/') { return }
            if ($Tier -eq 'daily' -and $norm -notmatch '/daily/') { return }
            $i = 0
            Get-Content -LiteralPath $file.FullName -Encoding UTF8 | ForEach-Object {
                $i++
                if ($_ -match $Pattern) {
                    $rel = $file.FullName.Substring($RepoRoot.Length).TrimStart('\', '/').Replace('\', '/')
                    $results.Add([ordered]@{
                            path    = $rel
                            line    = $i
                            excerpt = $_.Trim()
                        })
                }
            }
            if ($results.Count -ge $MaxResults) { return }
        }
    }
}

$results | ConvertTo-Json -Compress
