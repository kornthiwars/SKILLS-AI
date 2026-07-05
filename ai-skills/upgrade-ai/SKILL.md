---
name: upgrade-ai
metadata:
  version: "1.3.6"
description: >-
  Use when skills or rules need diagnosis, doc drift audit, external parity review,
  or minimal upgrades — 8 phases, validate-skills preflight, version governance.
  Use after repeat failures or before shipping pack meta changes. Invoke /upgrade-ai
  (canonical); /upgrade is shorthand alias.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Skill: upgrade-ai

Role: Systems Diagnostician

Mission: Identify the true failure layer before proposing changes.

Purpose: Continuously improve existing skills through structured diagnosis, failure analysis, architecture review, decomposition, and verification — without blind rewrites.

> Depth (catalogs, governance, anti-patterns): see [`reference.md`](./reference.md). Load in Phase 6–8 or when a governance trigger fires.

## Quick cheat sheet

| Trigger | Action |
|---------|--------|
| Repeat failure ≥2× | Phase 1 reproduce (or structural audit if meta-only) |
| Meta audit (`/upgrade` alias) | Static pack checklist — cap confidence 85 |
| Before ship | Run `scripts/validate-skills.sh` — see [SKILL-EVAL-PROMPTS.md](../../docs/SKILL-EVAL-PROMPTS.md) |
| Phase 7 | Minimal fix first · version bump plan per touched skill |
| Phase 8 | Smoke + pass [reference.md](./reference.md) § Close-out verification gate |

Canonical invoke is **`/upgrade-ai`** in docs/routing tables. Use **`/upgrade`** only as chat shorthand alias for this same skill.

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails.

## Handoffs (other skills in this pack)

Use this skill only for **skills and rules** in agent-skills (or the user's skill pack). For other work, hand off:

| Situation | Skill |
|-----------|--------|
| App bug, stack trace, failing behavior | [`/debug`](../debug/SKILL.md) |
| Review plan, PR, or diff before merge | [`/scrutinize`](../scrutinize/SKILL.md) |
| Long RCA after a validated production fix | [`/fix-record`](../fix-record/SKILL.md) |
| Ship skill changes | [`/git-push`](../git-push/SKILL.md) |

Application-code patches: follow [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) — link only.

---

# Workflow (8 phases)

Run sequentially — detail per phase: [reference.md](./reference.md). Cap **85** for structural audit-only.

| Phase | Goal |
|-------|------|
| 1–5 | Reproduce → localize → isolate → hypotheses → root cause |
| 6 | Blast radius |
| 7 | Minimal upgrade proposal + version bump plan |
| 8 | Verify + vault autolog |

**Activate when:** repeat failures, inconsistent outputs, prompt bloat (>300 lines), skill overlap — not cosmetic-only requests.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/upgrade-ai` |
|---------|---------------|
| STATUS | IN_PROGRESS = phase N; READY = verified upgrade; BLOCKED = insufficient evidence |
| OBJECTIVE | Diagnose failure layer and propose minimal skill/rule upgrade |
| DISCOVERIES | Repro steps, layer signals, prior art hits, rejected hypotheses |
| ANALYSIS | Root cause, blast radius, regression risk, non-goals |
| RISKS | Prompt inflation, skipped verification, wrong layer, pack drift |
| ARTIFACTS | Upgrade proposal, version bump plan, audit scores if pack-wide |
| NEXT ACTIONS | Repro, patch plan, checklist, or read `reference.md` |
| HANDOFF | `/scrutinize` before merge · `/git-push` to ship · `none` |
| CONFIDENCE | 0–100; cap 85 for structural audit only; pass close-out gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES or ANALYSIS, NEXT ACTIONS, CONFIDENCE. Close-out: all sections + version bump plan in ARTIFACTS.

Principles & phase detail: [reference.md](./reference.md).
