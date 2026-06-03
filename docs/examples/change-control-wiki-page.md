---
date: 2026-05-28
tags: [wiki, skills, infrastructure]
title: Production change-control three-layer system
status: active
related: [change-control]
---

#wiki #skills #infrastructure

# Production change-control three-layer system

## Summary

agent-skills needed production mindset: risk, scope, verification — not only skill file patterns.

## Key points

- Single-layer rules (`clean-code` only) lacked orchestration and CI verification
- Symptoms: large AI diffs, rules-only governance, no automated gate before merge
- Fix: manifest + scoped rules + skills linking manifest + smoke/change-control scripts + GitHub Actions

## Details

1. `ai-rules/change-control-manifest.mdc` (alwaysApply) + scoped rule tree
2. Skills link manifest (`debug`, `scrutinize`, `git-push`)
3. `scripts/smoke-skills.sh`, `scripts/change-control-check.sh`, GitHub Actions workflow

## When to use

Large governance upgrades, repeat “AI over-patched” incidents, onboarding production teams.

## Avoid

- 20+ `alwaysApply` rule files (context explosion)
- Duplicating full `/debug` workflow inside every rule file

## Related

- `docs/CHANGE-CONTROL.md`
- issues: 2026-05-28
