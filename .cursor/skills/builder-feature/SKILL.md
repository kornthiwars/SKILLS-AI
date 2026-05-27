---
name: builder-feature
description: >-
  Orchestrate multi-layer feature design by analyzing workflows, reusing
  existing systems, and delegating to builder-ui, builder-api,
  builder-schema, and builder-infrastructure. Trigger on /builder-feature.
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

# Specialist delegation (SKILLS-AI)

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

# Activation

Use when:
- designing new product features
- coordinating multi-layer systems
- feature spans frontend/backend/data/infra
- duplication risk is rising
- rollout risk increases

Do NOT use for:
- isolated UI/API/schema/infra-only tasks
- isolated debugging

Delegate those to specialists directly.

---

# Workflow

## 1) Workflow analysis

Analyze:
- user actions and success path
- async flows and retries
- permission boundaries
- rollback/failure scenarios
- cross-system dependencies

Output:
- workflow map
- failure scenarios
- dependency analysis

## 2) Existing system analysis

Inspect:
- current features/components/services
- shared APIs and schemas
- existing infra capabilities
- reusable utilities/state patterns

Questions:
- does this already exist?
- extend vs create?
- ownership conflicts?
- architectural drift risk?

Output:
- reuse opportunities
- duplication risks
- extension constraints

## 3) Feature boundary design

Define:
- feature boundary
- shared vs local modules
- ownership zones
- integration surfaces

Output:
- boundary map
- ownership map

## 4) Specialist delegation

Delegate layer decisions to the relevant builder skills.

Output:
- delegated task map
- specialist ownership matrix
- sequencing plan

## 5) State + integration coordination

Coordinate:
- frontend state vs server state ownership
- async updates, retries, cache invalidation
- optimistic updates and failure reconciliation

Require:
- predictable synchronization
- isolated mutations
- explicit contracts

Output:
- integration map
- state ownership plan

## 6) Rollout + reliability coordination

Plan:
- feature flags/staged rollout
- rollback strategy
- monitoring coverage
- migration/deployment safety
- incident response hooks

Output:
- rollout plan
- operational readiness assessment

## 7) Cross-layer verification

Verify:
- workflow continuity
- reuse vs duplication
- ownership clarity
- integration consistency
- permission correctness
- async reliability
- observability + rollback readiness

Use specialist outputs + `/scrutinize` before merge.

Reject if:
- ownership unclear
- duplicated systems
- excessive coupling
- rollback impossible
- observability incomplete

---

# Output format

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

Use `.cursor/skills/builder-feature/reference.md` for deep orchestration checklists.
