#Requires -Version 5.1
# Static validation for ai-skills/* — frontmatter, version, paths, line budget.
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
if (-not (Test-Path -LiteralPath $SkillsRoot)) {
    Write-Error "Missing ai-skills at $SkillsRoot"
}

$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()
$checked = 0

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

Get-ChildItem -LiteralPath $SkillsRoot -Directory | ForEach-Object {
    $dirName = $_.Name
    $skillMd = Join-Path $_.FullName 'SKILL.md'
    $relSkill = "ai-skills/$dirName/SKILL.md"
    $checked++

    if (-not (Test-Path -LiteralPath $skillMd)) {
        $errors.Add("${relSkill}: missing SKILL.md")
        return
    }

    $content = Get-Content -LiteralPath $skillMd -Raw
    $lines = ($content -split "`n").Count
    if ($lines -gt 500) {
        $errors.Add("${relSkill}: $lines lines (max 500)")
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

    if ($fm -notmatch '(?m)^description:\s*(.+)$') {
        $errors.Add("${relSkill}: missing description:")
    }

    if ($fm -notmatch '(?m)^compatibility:\s') {
        $errors.Add("${relSkill}: missing compatibility:")
    }

    if ($fm -notmatch '(?m)^metadata:\s*$') {
        $errors.Add("${relSkill}: missing metadata:")
    } elseif ($fm -notmatch '(?m)^\s+version:\s*"([^"]+)"\s*$') {
        $errors.Add("${relSkill}: missing metadata.version")
    }

    if ($fm -notmatch '(?m)^disable-model-invocation:\s*true\s*$') {
        $errors.Add("${relSkill}: disable-model-invocation must be true")
    }

    $refMd = Join-Path $_.FullName 'reference.md'
    if (Test-Path -LiteralPath $refMd) {
        $refContent = Get-Content -LiteralPath $refMd -Raw
        Test-AbsolutePaths "ai-skills/$dirName/reference.md" $refContent
    }
}

foreach ($w in $warnings) { Write-Warning $w }
if ($errors.Count -gt 0) {
    foreach ($e in $errors) { Write-Host "ERROR: $e" -ForegroundColor Red }
    Write-Host "validate-skills: $($errors.Count) error(s)" -ForegroundColor Red
    exit 1
}

Write-Host "OK validate-skills: $checked skill(s)"
exit 0
