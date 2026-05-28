---
date: 2026-05-28
time: "1715"
tags: [learning, skills, infrastructure]
skill: skills
title: Production change-control three-layer system
status: resolved
symptoms: [AI patches too large, rules-only not enough, no CI gate]
files: [ai-rules/change-control-manifest.mdc, scripts/change-control-check.sh, .github/workflows/skills-quality.yml]
related_issue: "2026-05-28"
---

# Production change-control three-layer system

## Context

SKILLS-AI needed production mindset: risk, scope, verification — not only skill file patterns.

## Symptoms

- Rules governed meta files but not app code behavior consistently
- Large AI diffs without budget enforcement
- No automated gate before merge

## Root cause

Single-layer rules (`clean-code` only) without orchestration (skills) and verification (scripts/CI).

## Fix

1. `ai-rules/change-control-manifest.mdc` (alwaysApply) + scoped rule tree
2. Skills link manifest (`debug`, `scrutinize`, `git-push`)
3. `scripts/smoke-skills.sh`, `scripts/change-control-check.sh`, GitHub Actions workflow

## When to use

Large governance upgrades, repeat “AI over-patched” incidents, onboarding production teams.

## Avoid

- 20+ `alwaysApply` rule files (context explosion)
- Duplicating full `/debug` workflow inside every rule file

## References

- `docs/CHANGE-CONTROL.md`
- `related_issue:` 2026-05-28
