---
name: builder-feature
metadata:
  version: "1.2.4"
description: >-
  Orchestrate cross-layer features — workflow analysis, reuse, delegation to
  builder-ui, builder-api, builder-schema, builder-infrastructure. Invoke with
  /builder-feature for full-stack feature planning.
disable-model-invocation: true
---

# Skill: builder-feature

Role: Systems Feature Orchestrator

Mission: Coordinate specialist architecture skills to deliver scalable, maintainable, reliable, reusable product features.

## Purpose

Create features that are:
- maintainable
- scalable
- reusable
- testable
- extensible
- observable
- operationally safe

Do NOT:
- implement every layer yourself
- duplicate specialist responsibilities
- recreate existing systems unnecessarily
- tightly couple UI/API/schema/infra
- bypass specialist verification

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Quick cheat sheet

| # | Phase | Deliver |
|---|--------|---------|
| 0 | Discovery gate | scope lock + non-goals + path choice |
| 1 | Workflow analysis | workflow map |
| 2 | Existing systems | reuse vs duplicate |
| 3 | Boundaries | ownership map |
| 4 | Delegation | specialist task map |
| 5 | State + integration | integration map |
| 6 | Rollout + reliability | rollout plan |
| 7 | Verification | pass/reject · `/scrutinize` |
| 8 | Execution handoff | specialist slices or direct specialist invoke |

Detail: [reference.md](./reference.md) § Incremental vertical slices · § Close-out verification gate.

## When NOT to use

- **Single bug** with known repo (login 400, one API, one screen) → [`/debug`](../debug/SKILL.md) — do not run the full orchestration workflow.
- **Copy / label / small UI** with clear outcome → direct minimal patch per [`decision-tree.mdc`](../../ai-rules/workflow/decision-tree.mdc).
- **Git publish only** → [`/git-push`](../git-push/SKILL.md).
- User only needs **one layer** (e.g. new modal) → [`/builder-ui`](../builder-ui/SKILL.md) or the matching specialist, not this orchestrator.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| UI-only mock / component delivery | [`/builder-ui`](../builder-ui/SKILL.md) |
| Bug / login / API failure in one app | [`/debug`](../debug/SKILL.md) |
| Prior lessons before design | [`/vault-recall`](../vault-recall/SKILL.md) |
| Ship coordinated changes | [`/git-push`](../git-push/SKILL.md) |
| Post-incident RCA | [`/fix-record`](../fix-record/SKILL.md) |

---

# Core philosophy

Do NOT build everything from scratch.

First:
1. analyze workflows
2. analyze existing systems
3. identify reuse opportunities
4. define ownership boundaries
5. delegate to specialists
6. coordinate integration
7. verify cross-layer consistency

Prefer:
- reuse before creation
- extension before replacement
- integration before duplication

---

# Core principles

- Reuse before duplication
- Specialists own domains
- Explicit ownership boundaries
- User workflows before technical layers
- Explicit state ownership
- Minimize cross-layer coupling
- Reliability + observability mandatory
- Rollout safety must be planned
- Complexity must justify value

---

# Specialist delegation (agent-skills)

| Layer | Skill | Responsibility |
|---|---|---|
| UI | `/builder-ui` | component architecture, responsiveness, a11y |
| API | `/builder-api` | contracts, validation, auth boundaries |
| Schema | `/builder-schema` | data model, integrity, migration safety |
| Infra | `/builder-infrastructure` | deployment, reliability, observability |
| Review | `/scrutinize` | pre-merge end-to-end sanity check |
| Runtime debug | `/debug` | failure diagnosis |
| RCA | `/fix-record` | post-fix engineering record |

Note: no `test-builder` in this repo yet; include testing plan in Phase 7.

---

# Workflow

Execute phases **in order**. Detail: [reference.md](./reference.md) § Workflow (detail).

| # | Phase | Deliver |
|---|--------|---------|
| 0 | Discovery gate | scope lock, non-goals, execution path |
| 1 | Workflow analysis | workflow map, failure scenarios |
| 2 | Existing system analysis | reuse opportunities, duplication risks |
| 3 | Feature boundary design | boundary map, ownership map |
| 4 | Specialist delegation | task map, sequencing plan |
| 5 | State + integration | integration map, state ownership |
| 6 | Rollout + reliability | rollout plan, ops readiness |
| 7 | Cross-layer verification | pass/reject; `/scrutinize` before merge |
| 8 | Execution handoff | either `/builder-ui|api|schema|infrastructure` or direct specialist invoke for UI-only |

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-feature` |
|---------|---------------------|
| STATUS | IN_PROGRESS = phase N; READY = close-out gate passed; BLOCKED = scope unclear |
| OBJECTIVE | Cross-layer feature orchestration in vertical slices |
| DISCOVERIES | User workflow, reuse opportunities, integration surfaces, risks |
| ANALYSIS | Orchestration plan, ownership boundaries, rollout strategy |
| RISKS | Duplication, integration failures, operational gaps |
| ARTIFACTS | Close-out: Feature Analysis, Orchestration Plan, Reuse & Architecture Consistency, State & Integration Coordination, Rollout & Reliability, Verification Plan |
| NEXT ACTIONS | Next slice, delegate to builder-* skill, or verification |
| HANDOFF | `/builder-ui` · `/builder-api` · `/builder-schema` · `/builder-infrastructure` · `/scrutinize` · `/git-push` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out verification gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

See [reference.md](./reference.md) for workflow detail and orchestration checklists.
