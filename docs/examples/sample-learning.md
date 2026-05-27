---
date: 2026-05-27
time: "1600"
tags: [learning, vault, skills]
skill: vault
title: Wire vault recall before debug and git-push
status: resolved
symptoms: [repeat failures, skills ignore learnings, search duplicated in prompts]
files: [ai-skills/vault-recall/reference.md, ai-skills/debug/SKILL.md, ai-skills/git-push/SKILL.md]
related_issue: "2026-05-27"
---

# Wire vault recall before debug and git-push

## Context

SKILLS-AI — vault v2 split issues/learnings; search steps were copy-pasted across skills.

## Symptoms

- Agent repeats debug/git fixes
- Long prompts with duplicate grep tables

## Root cause

No single source of truth for vault search; `vault-issues.mdc` and skills each defined grep differently.

## Fix

1. Add [`ai-skills/vault-recall/reference.md`](../../ai-skills/vault-recall/reference.md) — link from rule, debug, git-push
2. Use `/vault-recall` for explicit search only
3. Run `docs/SKILL-SMOKE-CHECKLIST.md` after rule/skill changes

## When to use

Repeat symptoms, git/SSH/skills friction, after vault or skill edits.

## Avoid

- Copy issues format into learnings
- Commit `vault/issues/*.md`
- Duplicate grep tables in new skills

## References

- `related_issue:` 2026-05-27
- `docs/examples/sample-learning.md` (tracked author copy)
