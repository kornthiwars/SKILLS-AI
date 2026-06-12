#Requires -Version 5.1
# Search vault notes (gitignored) — uses rg --no-ignore when available.
param(
    [Parameter(Mandatory = $true)]
    [string]$Pattern,
    [ValidateSet('all', 'decisions', 'sessions', 'projects', 'daily')]
    [string]$Tier = 'all',
    [int]$MaxResults = 30,
    [string]$RepoRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$Notes = Join-Path $RepoRoot 'vault\notes'
$searchRoots = switch ($Tier) {
    'decisions' { @(Join-Path $Notes 'decisions') }
    'sessions'  { @(Join-Path $Notes 'sessions') }
    'projects'  { @(Join-Path $Notes 'projects') }
    'daily'     { @(Join-Path $Notes 'daily') }
    default     {
        @(
            (Join-Path $Notes 'decisions'),
            (Join-Path $Notes 'sessions'),
            (Join-Path $Notes 'projects')
        )
    }
}

$existing = @($searchRoots | Where-Object { Test-Path -LiteralPath $_ })
if ($existing.Count -eq 0) {
    Write-Output '[]'
    exit 0
}

$rg = Get-Command rg -ErrorAction SilentlyContinue
$results = [System.Collections.Generic.List[object]]::new()

if ($rg) {
    foreach ($root in $existing) {
        $out = @(& rg --no-ignore -n --max-count $MaxResults $Pattern $root 2>&1)
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
