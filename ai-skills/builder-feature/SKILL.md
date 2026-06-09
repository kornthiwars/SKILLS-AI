---
name: builder-feature
metadata:
  version: "1.5.2"
description: >-
  Plan-only cross-layer feature orchestrator — workflow map, UI-only express
  lane, slice backlog, optional vault plan persist, delegation to
  builder-ui/api/schema/infrastructure. Does not write application code.
disable-model-invocation: true
---

# Skill: builder-feature

Role: Systems Feature Orchestrator (**plan-only**)

Mission: Design user flows, boundaries, and vertical slices — then **hand off** implementation to specialist skills. This skill **never** patches application source.

## Plan-only iron law

**While `/builder-feature` is active:**

| Allowed | Forbidden |
|---------|-----------|
| Read / grep / trace existing code | Edit `.ts`, `.tsx`, `.js`, `.py`, `.go`, `.rs`, `.vue`, `.css`, `.html`, SQL migrations, IaC |
| Workflow map, slice backlog, ownership tables | Scaffolding, "quick stub", "I'll start while we plan" |
| Offer handoff to `/builder-ui`, … · **optional** `vault/workday/plans/` persist (user opt-in) | Claim feature is built or READY with code changes |

**Never edit application files** in this skill — implementation belongs in `/builder-ui`, `/builder-api`, `/builder-schema`, or `/builder-infrastructure`.

**User says "ทำเลย" / "implement now":** finish or resume **phases 0–7** if incomplete → emit **Slice 1 brief** → **stop** → tell user to invoke the owner skill (e.g. `/builder-ui`) or say **"slice 1 go"** in a **new** turn with that specialist — do **not** write code in this skill.

Detail: [reference.md](./reference.md) § UI-only express lane · § Plan persistence · [`templates/template.slice-brief.md`](../../templates/template.slice-brief.md).

## Purpose

Deliver **plans** for features that are maintainable, scalable, reusable, testable, extensible, observable, and operationally safe.

Do NOT:
- implement any layer yourself (including HTML/CSS/API handlers)
- duplicate specialist responsibilities
- skip workflow / flow analysis before slice backlog
- continue into code after phase 7 in the same skill run
- bypass specialist verification on implementation

## Scope Guardrails

- ALWAYS complete **workflow map** (phase 1) before slice backlog.
- ALWAYS state explicit non-goals before closing plan.
- NEVER edit application files — orchestration and design artifacts in chat / SKILL REPORT only.
- NEVER treat "small feature" as excuse to skip flow check.

## Quick cheat sheet

| Mode | When | Output | Code? |
|------|------|--------|-------|
| **PLAN** (default) | `/builder-feature` or cross-layer feature request | Phases 0–7 + slice backlog | **No** |
| **Express** | Phase 0 = UI-only mock / static HTML / single page | Short workflow map + slice backlog → `PLAN_READY` | **No** |
| **Handoff** | Plan complete or user picks slice | Slice brief + owner skill | Specialist writes code |

Detail: [reference.md](./reference.md) § UI-only express lane · § Plan-only gate.

| # | Phase | Deliver |
|---|--------|---------|
| 0 | Discovery gate | scope lock + non-goals + path choice |
| 1 | **Workflow / flow** | numbered user journey + failure branches |
| 2 | Existing systems | reuse vs duplicate |
| 3 | Boundaries | ownership map |
| 4 | Delegation | specialist task map |
| 5 | State + integration | integration map |
| 6 | Rollout + reliability | rollout plan |
| 7 | Plan verification | plan pass/reject — **not** code merge |
| — | Slice backlog | ordered slices + owner + verify per slice |
| — | Handoff | `/builder-ui` · `/builder-api` · … — **end turn** |

## When NOT to use

- **Single bug** (login 400, one screen) → [`/debug`](../debug/SKILL.md)
- **Copy / label / small UI** with clear outcome → direct minimal patch per [`decision-tree.mdc`](../../ai-rules/workflow/decision-tree.mdc)
- **Git publish only** → [`/git-push`](../git-push/SKILL.md)
- **One layer only** (modal, one endpoint) → matching specialist (`/builder-ui`, `/builder-api`, …) — not this orchestrator
- User wants **code now** on one layer → specialist directly, not `/builder-feature`

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Implement slice (UI) | [`/builder-ui`](../builder-ui/SKILL.md) + slice brief from backlog |
| Implement slice (API) | [`/builder-api`](../builder-api/SKILL.md) |
| Implement slice (schema) | [`/builder-schema`](../builder-schema/SKILL.md) |
| Implement slice (infra) | [`/builder-infrastructure`](../builder-infrastructure/SKILL.md) |
| UI-only scope after phase 0 | [`/builder-ui`](../builder-ui/SKILL.md) — use **express lane** here if still planning; specialist implements after slice brief |
| Bug during build | [`/debug`](../debug/SKILL.md) |
| Prior art | [`/vault-recall`](../vault-recall/SKILL.md) |
| Review implemented slice PR | [`/scrutinize`](../scrutinize/SKILL.md) |
| Ship after slices verified | [`/git-push`](../git-push/SKILL.md) |

---

# Core philosophy

Do NOT build from scratch in this skill.

1. Map **user workflow** and failure paths (phase 1 — mandatory)
2. Analyze existing systems
3. Reuse before create
4. Define ownership boundaries
5. Emit **slice backlog**
6. Hand off **one slice at a time** to specialists

---

# Specialist delegation

| Layer | Skill | Responsibility |
|---|---|---|
| UI | `/builder-ui` | component architecture + **implementation** |
| API | `/builder-api` | contracts + **implementation** |
| Schema | `/builder-schema` | model + migrations |
| Infra | `/builder-infrastructure` | deploy + observability |
| Review | `/scrutinize` | pre-merge on **implemented** diffs |
| Debug | `/debug` | runtime failures |

Testing plan belongs in slice backlog; no `test-builder` in this repo yet.

---

# Workflow

Execute phases **in order**. Do **not** open phase N+1 until phase N outputs are in DISCOVERIES/ARTIFACTS.

Detail: [reference.md](./reference.md) § Workflow (detail).

After phase 7 + slice backlog → STATUS **PLAN_READY** → hand off slice 1 → **stop** (no code).

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-feature` |
|---------|---------------------|
| STATUS | IN_PROGRESS = phase N; **PLAN_READY** = plan + backlog complete, no code; BLOCKED = scope/flow unclear |
| OBJECTIVE | Cross-layer **plan** in vertical slices — not implementation |
| DISCOVERIES | **Workflow map**, reuse, integration surfaces, risks |
| ANALYSIS | Orchestration plan, ownership, rollout |
| RISKS | Duplication, integration gaps, agent jump-to-code |
| ARTIFACTS | Workflow map · Orchestration plan · **Slice backlog** · optional `vault/workday/plans/{slug}.md` · Slice brief per [`template.slice-brief.md`](../../templates/template.slice-brief.md) |
| NEXT ACTIONS | User approves slice N → invoke owner skill · offer plan persist |
| HANDOFF | `/builder-ui` · `/builder-api` · `/builder-schema` · `/builder-infrastructure` · `none` after plan |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Plan close-out gate before PLAN_READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES (include workflow map), NEXT ACTIONS, CONFIDENCE.

---

# Reference

[reference.md](./reference.md) — plan-only gate, workflow map format, slice backlog, anti-rationalizations.
