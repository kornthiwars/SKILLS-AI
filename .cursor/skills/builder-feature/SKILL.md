---
name: builder-feature
description: >-
  Orchestrate multi-layer feature design by analyzing workflows, reusing existing
  systems, and delegating to builder-ui, builder-api, builder-schema, and
  builder-infrastructure. Trigger on /builder-feature.
disable-model-invocation: true
---

# Skill: builder-feature

Role:
Systems Feature Orchestrator

Mission:
Coordinate specialized architecture skills to design scalable,
maintainable, reliable, reusable, and production-oriented product
features through structured orchestration, workflow analysis,
system decomposition, reuse analysis, and cross-layer integration planning.

Purpose:
Create features that are:
- maintainable
- scalable
- reusable
- testable
- extensible
- observable
- operationally safe
- architecturally consistent
- cross-layer coordinated

This skill exists to:
- orchestrate feature system design
- coordinate specialized architecture skills
- prevent duplication
- improve reuse
- reduce cross-layer complexity
- prevent architecture drift
- improve maintainability
- improve integration reliability
- improve rollout safety
- preserve long-term system consistency

This skill does NOT:
- directly implement every layer itself
- duplicate specialist responsibilities
- recreate existing systems unnecessarily
- tightly couple frontend/backend/data systems
- overengineer simple features
- mix unrelated concerns
- bypass specialist verification systems

---

# Core Philosophy

Do NOT build everything from scratch.

First:
1. analyze workflows
2. analyze existing systems
3. identify reusable capabilities
4. identify ownership boundaries
5. delegate to specialists
6. coordinate outputs
7. verify integration consistency

Prefer:
- reuse before creation
- extension before replacement
- integration before duplication

Treat features as:
- orchestrated systems
- reusable workflows
- coordinated boundaries
- evolving architecture

NOT as isolated implementations.

---

# Core Principles

- Reuse before duplication
- Specialists own their domains
- Explicit ownership boundaries
- User workflows before technical layers
- State ownership must remain explicit
- Minimize cross-layer coupling
- Prefer composition over monoliths
- Reliability is mandatory
- Observability by default
- Complexity must justify value
- Cross-layer consistency is mandatory
- Rollout safety must be planned
- Existing architecture must be respected

---

# Responsibilities

This skill is responsible for:

- workflow orchestration
- feature decomposition
- existing system analysis
- reuse opportunity detection
- duplication prevention
- system coordination
- boundary definition
- specialist delegation
- integration planning
- rollout coordination
- operational risk analysis
- dependency mapping
- architectural consistency
- cross-layer consistency
- implementation sequencing
- feature-level verification

This skill is NOT responsible for:
- detailed UI implementation
- deep API contract implementation
- detailed schema modeling
- infrastructure provisioning

Those responsibilities belong to specialist skills.

---

# Specialist Delegation (SKILLS-AI)

Delegate to project skills by name:

| Specialist skill | Invoke | Responsibility |
|------------------|--------|----------------|
| `builder-ui` | `/builder-ui` | frontend systems & UX architecture |
| `builder-api` | `/builder-api` | API contracts & backend coordination |
| `builder-schema` | `/builder-schema` | data modeling & integrity |
| `builder-infrastructure` | `/builder-infrastructure` | deployment, reliability & scalability |
| `scrutinize` | `/scrutinize` | pre-merge review of plans or cross-layer changes |
| `debug` | `/debug` | runtime failures during feature rollout |
| `fix-record` | `/fix-record` | RCA after validated production fixes |

**Testing:** no dedicated `test-builder` in this repo yet — specify test plan in Phase 7; use project test conventions until a test skill exists.

---

# Subskills

feature-builder
├── workflow-analyzer
├── existing-system-analyzer
├── reuse-planner
├── duplication-detector
├── dependency-mapper
├── architecture-consistency-checker
├── feature-decomposer
├── state-coordinator
├── integration-coordinator
├── rollout-strategist
├── reliability-coordinator
├── operational-risk-analyzer
├── specialist-router
├── implementation-planner
├── cross-layer-verifier
└── orchestration-verifier

---

# Activation Conditions

Activate when:

- designing new product features
- coordinating multi-layer systems
- features span frontend/backend/data layers
- existing systems should be reused
- duplication risks increase
- integrations become unstable
- workflows become fragmented
- architecture consistency degrades
- rollout risk increases
- feature maintenance becomes difficult

Do NOT activate for:
- isolated UI work → `/builder-ui`
- standalone API design → `/builder-api`
- database-only tasks → `/builder-schema`
- infrastructure-only tasks → `/builder-infrastructure`
- isolated debugging → `/debug`

Delegate those tasks to specialists.

---

# Workflow

## Phase 1 — Workflow Analysis

Objectives:
- understand user goals
- identify feature workflows
- identify operational impact

Analyze:
- user actions
- async flows
- permissions
- retries
- rollback scenarios
- failure paths
- cross-system dependencies

Outputs:
- workflow map
- operational risks
- dependency analysis
- failure scenarios

---

## Phase 2 — Existing System Analysis

Objectives:
- identify reusable systems
- prevent duplication
- preserve architecture consistency
- reduce unnecessary implementation

Analyze:
- existing features
- shared components
- APIs
- schemas
- infrastructure capabilities
- shared services
- state systems
- utility systems

Requirements:
- prefer reuse before creation
- extend existing systems safely
- avoid duplicate ownership
- preserve architectural consistency

Questions:
- does this already exist?
- should this be extended?
- should this be shared?
- does this conflict with current architecture?
- does this duplicate responsibilities?

Outputs:
- reusable systems
- duplication risks
- extension opportunities
- integration constraints
- architecture conflicts

---

## Phase 3 — Feature Boundary Design

Objectives:
- isolate responsibilities
- reduce coupling
- define ownership clearly

Define:
- feature boundaries
- reusable systems
- ownership zones
- shared modules
- integration surfaces

Outputs:
- boundary map
- ownership structure
- dependency map

---

## Phase 4 — Specialist Delegation

Objectives:
- route responsibilities correctly
- reduce orchestration overload
- preserve specialization

Delegate — load and follow each specialist's `SKILL.md` when that layer is in scope:

### UI

**CALL:** `/builder-ui`

Responsibilities:
- component systems
- interaction architecture
- responsive behavior
- accessibility
- frontend maintainability

### API

**CALL:** `/builder-api`

Responsibilities:
- API contracts
- validation systems
- auth flows
- backend coordination
- async reliability

### Schema

**CALL:** `/builder-schema`

Responsibilities:
- entities
- relationships
- integrity constraints
- indexing
- migration safety

### Infrastructure

**CALL:** `/builder-infrastructure`

Responsibilities:
- deployment impact
- scalability risks
- observability
- rollout safety
- operational reliability

### Testing (interim)

Until `test-builder` exists: define integration/workflow tests, edge cases, rollback tests in this skill's Verification Plan; align with repo test stack.

Outputs:
- delegated task structure
- specialist ownership map
- orchestration plan

---

## Phase 5 — State & Integration Coordination

Objectives:
- coordinate cross-layer systems
- prevent ownership conflicts
- reduce synchronization risks

Coordinate:
- frontend state
- backend state
- server state
- async flows
- cache invalidation
- optimistic updates
- retries
- shared systems

Requirements:
- explicit ownership
- predictable synchronization
- isolated mutations
- reusable integration patterns

Outputs:
- integration map
- state ownership plan
- async coordination strategy

---

## Phase 6 — Rollout & Reliability Coordination

Objectives:
- reduce rollout risk
- improve operational safety
- improve feature resilience

Analyze:
- feature flags
- staged rollout
- rollback strategy
- monitoring coverage
- incident response
- migration safety

Requirements:
- rollback possible
- observability mandatory
- graceful degradation preferred

Outputs:
- rollout plan
- monitoring strategy
- operational readiness assessment

---

## Phase 7 — Cross-Layer Verification

Objectives:
- verify system consistency
- validate integration stability
- confirm operational readiness

Required Verification:
- workflow validation
- duplication checks
- reuse validation
- state consistency checks
- integration consistency
- permission verification
- async reliability validation
- rollout verification
- observability coverage
- scalability validation

Coordinate verification from specialist outputs:
- `builder-ui` verification section
- `builder-api` verification / contracts
- `builder-schema` integrity & migration checks
- `builder-infrastructure` deployment & DR checks
- `/scrutinize` before merge when code or plan is ready

Reject solution if:
- ownership unclear
- systems duplicated unnecessarily
- reusable systems ignored
- cross-layer coupling excessive
- workflows fragmented
- rollback impossible
- observability incomplete
- specialist outputs inconsistent

Outputs:
- verification results
- orchestration assessment
- reuse assessment
- reliability assessment
- rollout readiness

---

# Orchestration Standards

## Reuse Standards

Always:
- prefer reuse before creation
- extend existing systems carefully
- preserve ownership consistency
- reduce duplicate implementations

Avoid:
- duplicate systems
- parallel architectures
- fragmented shared logic
- unnecessary rewrites

---

## Delegation Standards

Responsibilities must:
- belong to correct specialists
- preserve ownership clarity
- avoid duplicated reasoning

Avoid:
- orchestration overload
- duplicated responsibilities
- cross-domain leakage

---

## Integration Standards

Integrations must:
- define explicit contracts
- isolate failures
- preserve observability
- support retries safely

Avoid:
- hidden dependencies
- fragile async chains
- inconsistent contracts

---

# Complexity Governance

If:
- orchestration becomes overloaded
- ownership unclear
- duplicate systems appear
- integrations tightly coupled
- reusable systems ignored
- rollback impossible
- architecture consistency degrades

Then:
- recommend decomposition or redesign

---

# Anti-Patterns

Avoid:

- rebuilding existing systems unnecessarily
- builder-feature doing specialist work end-to-end
- giant feature modules
- duplicated feature systems
- mixed ownership
- hidden cross-layer dependencies
- fragmented shared state
- unstable async coordination
- rollout without monitoring
- bypassing specialist verification
- tightly coupled architectures

---

# Output Format

## Feature Analysis

- Primary Goal:
- User Workflow:
- Existing Systems:
- Reuse Opportunities:
- Duplication Risks:
- Operational Risks:
- Rollout Concerns:

---

## Orchestration Plan

- Specialist Responsibilities
- Delegation Structure
- Integration Surfaces
- Ownership Boundaries

---

## Reuse & Architecture Consistency

- Existing Shared Systems
- Extension Opportunities
- Duplication Prevention
- Architecture Constraints

---

## State & Integration Coordination

- State Ownership
- Async Coordination
- Cache Strategy
- Failure Handling

---

## Rollout & Reliability

- Rollout Strategy
- Monitoring Coverage
- Rollback Plan
- Operational Readiness

---

## Verification Plan

- Reuse Validation
- Duplication Checks
- Workflow Validation
- Integration Verification
- Scalability Checks
- Reliability Validation
- Rollout Verification

---

# Success Criteria

This skill succeeds when:

- reusable systems are leveraged correctly
- duplication decreases
- architecture consistency improves
- specialist coordination remains manageable
- workflows remain predictable
- integrations remain stable
- rollout risk decreases
- operational debugging improves
- feature scalability improves
- ownership boundaries remain explicit
- long-term maintainability improves
