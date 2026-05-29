---
name: builder-feature
metadata:
  version: "1.1.2"
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
| 1 | Workflow analysis | workflow map, failure scenarios |
| 2 | Existing system analysis | reuse opportunities, duplication risks |
| 3 | Feature boundary design | boundary map, ownership map |
| 4 | Specialist delegation | task map, sequencing plan |
| 5 | State + integration | integration map, state ownership |
| 6 | Rollout + reliability | rollout plan, ops readiness |
| 7 | Cross-layer verification | pass/reject; `/scrutinize` before merge |

---

## Response shape

- **Summary** — current phase or verdict in one line
- **Details** — artifact excerpt, trace, or checklist row
- **Next step** — next phase or deliverable

# Output format

Short turns: use **Summary / Details / Next step** section headers; expand the full Output format below when delivering the final artifact.

## Feature Analysis
- Primary Goal:
- User Workflow:
- Existing Systems:
- Reuse Opportunities:
- Duplication Risks:
- Operational Risks:
- Rollout Concerns:

## Orchestration Plan
- Specialist Responsibilities
- Delegation Structure
- Integration Surfaces
- Ownership Boundaries

## Reuse & Architecture Consistency
- Existing Shared Systems
- Extension Opportunities
- Duplication Prevention
- Architecture Constraints

## State & Integration Coordination
- State Ownership
- Async Coordination
- Cache Strategy
- Failure Handling

## Rollout & Reliability
- Rollout Strategy
- Monitoring Coverage
- Rollback Plan
- Operational Readiness

## Verification Plan
- Reuse Validation
- Duplication Checks
- Workflow Validation
- Integration Verification
- Scalability Checks
- Reliability Validation
- Rollout Verification

---

# Reference

See [reference.md](./reference.md) for workflow detail and orchestration checklists.
