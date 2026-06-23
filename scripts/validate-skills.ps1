#Requires -Version 5.1
# Static validation for ai-skills/* - frontmatter, version, paths, line budget, doc sync.
param(
    [string]$RepoRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$SkillsRoot = Join-Path $RepoRoot 'ai-skills'
$AppendixTh = Join-Path $RepoRoot 'docs/th/APPENDIX-TH.md'
$ReadmeMd = Join-Path $RepoRoot 'README.md'
if (-not (Test-Path -LiteralPath $SkillsRoot)) {
    Write-Error "Missing ai-skills at $SkillsRoot"
}

$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()
$checked = 0
$skillVersions = @{}

$AbsPathPatterns = @(
    '/Users/[A-Za-z0-9_-]+',
    'C:\\Users\\',
    '/home/[a-z][a-z0-9_-]*/'
)

function Test-AbsolutePaths([string]$RelativePath, [string]$Content) {
    foreach ($pat in $AbsPathPatterns) {
        if ($Content -match $pat) {
            $errors.Add("${RelativePath}: machine-specific absolute path ($pat)")
        }
    }
}

function Get-FrontmatterBlock([string]$Content) {
    if ($Content -notmatch '(?s)\A---\r?\n(.*?)\r?\n---') {
        return $null
    }
    return $Matches[1]
}

function Get-DescriptionLength([string]$Content) {
    $fm = Get-FrontmatterBlock $Content
    if (-not $fm) { return 0 }
    $lines = $fm -split "`r?`n"
    $parts = [System.Collections.Generic.List[string]]::new()
    $i = 0
    while ($i -lt $lines.Count) {
        if ($lines[$i] -match '^description:\s*(.*)$') {
            $rest = $Matches[1].Trim()
            if ($rest -and $rest -notin @('>-', '>', '|')) { $parts.Add($rest) }
            $i++
            while ($i -lt $lines.Count -and ($lines[$i] -match '^[ \t]')) {
                $parts.Add($lines[$i].Trim())
                $i++
            }
            break
        }
        $i++
    }
    return (($parts -join '').Length)
}

Get-ChildItem -LiteralPath $SkillsRoot -Directory | ForEach-Object {
    $dirName = $_.Name
    $skillMd = Join-Path $_.FullName 'SKILL.md'
    $relSkill = "ai-skills/$dirName/SKILL.md"
    $checked++

    if (-not (Test-Path -LiteralPath $skillMd)) {
        $errors.Add("${relSkill}: missing SKILL.md")
        return
    }

    $refMd = Join-Path $_.FullName 'reference.md'
    if (-not (Test-Path -LiteralPath $refMd)) {
        $errors.Add("${relSkill}: missing reference.md (required for all skills)")
    }

    $content = Get-Content -LiteralPath $skillMd -Raw
    $lines = ($content -split "`n").Count
    if ($lines -gt 500) {
        $errors.Add("${relSkill}: $lines lines (max 500)")
    }

    $refLines = 0
    if (Test-Path -LiteralPath $refMd) {
        $refLines = ((Get-Content -LiteralPath $refMd -Raw) -split "`n").Count
        $refContent = Get-Content -LiteralPath $refMd -Raw
        Test-AbsolutePaths "ai-skills/$dirName/reference.md" $refContent
    }
    if ($lines -gt 200 -and $refLines -lt 50) {
        $warnings.Add("${relSkill}: $lines lines but reference.md has $refLines lines (progressive disclosure - expand reference.md)")
    }

    Test-AbsolutePaths $relSkill $content

    $fm = Get-FrontmatterBlock $content
    if (-not $fm) {
        $errors.Add("${relSkill}: missing YAML frontmatter (---)")
        return
    }

    if ($fm -notmatch '(?m)^name:\s*(\S+)\s*$') {
        $errors.Add("${relSkill}: missing name:")
    } elseif ($Matches[1] -ne $dirName) {
        $errors.Add("${relSkill}: name '$($Matches[1])' != folder '$dirName'")
    }

    if ($fm -notmatch '(?m)^description:\s') {
        $errors.Add("${relSkill}: missing description:")
    } else {
        $descLen = Get-DescriptionLength $content
        if ($descLen -gt 1024) {
            $errors.Add("${relSkill}: description length $descLen (max 1024)")
        }
    }

    if ($fm -notmatch '(?m)^compatibility:\s') {
        $errors.Add("${relSkill}: missing compatibility:")
    }

    if ($fm -notmatch '(?m)^metadata:\s*$') {
        $errors.Add("${relSkill}: missing metadata:")
    } elseif ($fm -notmatch '(?m)^\s+version:\s*"([^"]+)"\s*$') {
        $errors.Add("${relSkill}: missing metadata.version")
    } else {
        $skillVersions[$dirName] = $Matches[1]
    }

    if ($fm -notmatch '(?m)^disable-model-invocation:\s*true\s*$') {
        $errors.Add("${relSkill}: disable-model-invocation must be true")
    }

    if ($dirName -eq 'builder-feature' -and $content -notmatch 'template\.feature-plan\.md') {
        $errors.Add("${relSkill}: must link templates/template.feature-plan.md (plan mode contract)")
    }
}

function Test-VersionTable {
    param([string]$Path, [string]$Label)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($line -cnotmatch '^\| ([a-z][a-z0-9-]+) \|') { continue }
        $skill = $Matches[1]
        if ($skill -eq 'Skill') { continue }
        $cols = $line.Split('|') | ForEach-Object { $_.Trim() }
        if ($cols.Count -lt 5) { continue }
        $invoke = $cols[2].Trim('`')
        if ($invoke -cnotmatch '^/[a-z]') { continue }
        $docVer = $cols[3]
        if (-not $skillVersions.ContainsKey($skill)) {
            $errors.Add("${Label}: skill '$skill' in version table but no ai-skills/$skill/SKILL.md")
            continue
        }
        if ($skillVersions[$skill] -ne $docVer) {
            $errors.Add("${Label}: $skill version '$docVer' != SKILL.md metadata.version '$($skillVersions[$skill])'")
        }
    }
}

Test-VersionTable -Path $AppendixTh -Label 'docs/th/APPENDIX-TH.md'
Test-VersionTable -Path $ReadmeMd -Label 'README.md'
if (-not (Test-Path -LiteralPath $AppendixTh) -and -not (Test-Path -LiteralPath $ReadmeMd)) {
    $warnings.Add('docs/th/APPENDIX-TH.md and README.md missing - skip version sync check')
}

foreach ($w in $warnings) { Write-Warning $w }
if ($errors.Count -gt 0) {
    foreach ($e in $errors) { Write-Host "ERROR: $e" -ForegroundColor Red }
    Write-Host "validate-skills: $($errors.Count) error(s), $($warnings.Count) warning(s)" -ForegroundColor Red
    exit 1
}

$warnSuffix = if ($warnings.Count -gt 0) { ", $($warnings.Count) warning(s)" } else { '' }
Write-Host "OK validate-skills: $checked skill(s)$warnSuffix"
exit 0
