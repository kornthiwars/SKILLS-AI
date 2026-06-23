---
name: builder-feature
metadata:
  version: "1.8.3"
description: >-
  Use when planning a cross-layer feature (UI+API+schema+infra) — durable plan file
  (Plan mode / *.plan.md), goal-driven design reasoning, slice backlog, handoff to builder-*.
  Plan-only: does not write application code. Invoke /builder-feature.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
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
| Create/update **plan file** only at **`.cursor/plans/<slug>.plan.md`** (`CreatePlan` preferred; see [reference.md](./reference.md) § Plan path resolution) | Scaffolding, "quick stub"; write plan **only** to `docs/plans/` without `.cursor/plans/` |
| Workflow map, slice backlog, ownership tables (in plan file) | Claim feature is built or READY with code changes |
| Offer handoff to `/builder-ui`, … per slice todos | Implement slice; duplicate specialist work; skip flow before backlog; code after phase 7 |

**User says "ทำเลย" / "implement now":** finish phases 0–7 if incomplete → **Slice 1 brief** → **stop** → user invokes owner skill or **`slice 1 go`** in a new turn.

**Change-control:** plan-only iron law overrides [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) steps 7–8.

Depth: [reference.md](./reference.md) (index) · [reference-design-reasoning.md](./reference-design-reasoning.md) · [reference-workflow.md](./reference-workflow.md) · [reference-slice-handoff.md](./reference-slice-handoff.md) · [`template.feature-plan.md`](../../templates/template.feature-plan.md) · [`template.slice-brief.md`](../../templates/template.slice-brief.md).

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails. Skill-specific:

- Workflow map (phase 1) before slice backlog; non-goals before close-out.
- **Design reasoning** mandatory — [reference-design-reasoning.md](./reference-design-reasoning.md): `Goal → Hypotheses → Hierarchy → Constraints → Consistency → Self-review`.
- **Iron law:** no slice backlog until one approach survives hypothesis elimination and passes constraints.

## Quick cheat sheet

| Mode | When | Output | Code? |
|------|------|--------|-------|
| **PLAN** (default) | `/builder-feature` or cross-layer feature request | Plan file + phases 0–7 + slice todos | **No** |
| **Express** | Phase 0 `Path: ui-only-express` (UI mock / static HTML / single page) | Short plan file → `plan_ready` | **No** |
| **Iterate** | User refines scope while plan active | Update plan file only | **No** |
| **Handoff** | `plan_ready` + user confirms slice N | Slice brief + owner skill | Specialist writes code |

## Plan mode (summary)

Plan file = **SSoT** — emit per [`template.feature-plan.md`](../../templates/template.feature-plan.md); path `.cursor/plans/<slug>.plan.md` (never `docs/plans/` alone). Phases 0–7 → plan sections → `plan_ready` → await confirm → `slice N go` → hand off → **end turn**. Detail: [reference.md](./reference.md) § Plan mode alignment · [reference-workflow.md](./reference-workflow.md) § Workflow (detail).

## When NOT to use

- **Single bug** (login 400, one screen) → [`/debug`](../debug/SKILL.md)
- **Copy / label / small UI** with clear outcome → direct minimal patch per [`decision-tree.mdc`](../../ai-rules/workflow/decision-tree.mdc)
- **Git publish only** → [`/git-push`](../git-push/SKILL.md)
- **One layer only** (modal, one endpoint) → matching specialist — not this orchestrator
- User wants **code now** on one layer → specialist directly

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Implement slice (UI / API / schema / infra) | [`/builder-ui`](../builder-ui/SKILL.md) · [`/builder-api`](../builder-api/SKILL.md) · [`/builder-schema`](../builder-schema/SKILL.md) · [`/builder-infrastructure`](../builder-infrastructure/SKILL.md) + slice brief |
| UI-only + still planning (`ui-only-express`) | Stay in builder-feature — express lane → plan file |
| UI-only + implement now (no plan) | [`/builder-ui`](../builder-ui/SKILL.md) — exit orchestrator |
| Bug during build | [`/debug`](../debug/SKILL.md) |
| Review implemented slice PR | [`/scrutinize`](../scrutinize/SKILL.md) |
| Ship after slices verified | [`/git-push`](../git-push/SKILL.md) |
| Durable decisions — **after plan complete only** | [`/vault-capture`](../vault-capture/SKILL.md) |
| End of planning day | [`/vault-daily`](../vault-daily/SKILL.md) |

Vault handoffs **after** `PLAN_READY` only.

---

# Workflow

Phases **0–7 in order** — outputs in DISCOVERIES/ARTIFACTS before next phase. After phase 7 → `plan_ready` → confirm → slice 1 brief → **stop**.

Detail: [reference-workflow.md](./reference-workflow.md) · [reference-design-reasoning.md](./reference-design-reasoning.md).

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-feature` |
|---------|---------------------|
| STATUS | IN_PROGRESS = phase N; **PLAN_READY** = plan `plan_ready`, no app code; **CANCELLED**; BLOCKED = scope unclear |
| OBJECTIVE | Cross-layer **plan** in vertical slices — not implementation |
| DISCOVERIES | **Goal**, constraints, **hypothesis table**, workflow map, hierarchical layers, reuse, risks |
| ANALYSIS | Orchestration plan, ownership, rollout |
| RISKS | Duplication, integration gaps, agent jump-to-code |
| ARTIFACTS | Plan file path · slice todos · slice brief per [`template.slice-brief.md`](../../templates/template.slice-brief.md) |
| NEXT ACTIONS | User approves slice N → invoke owner skill |
| HANDOFF | `/builder-ui` · `/builder-api` · `/builder-schema` · `/builder-infrastructure` · `/vault-capture` · `/vault-daily` · `none` |
| CONFIDENCE | 0–100; pass [`template.feature-plan.md`](../../templates/template.feature-plan.md) § Close-out gate before PLAN_READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

[reference.md](./reference.md) — index · [reference-design-reasoning.md](./reference-design-reasoning.md) · [reference-workflow.md](./reference-workflow.md) · [reference-slice-handoff.md](./reference-slice-handoff.md).
