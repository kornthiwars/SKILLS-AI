---
name: builder-api
description: >-
  Design scalable, maintainable, secure, production-oriented APIs through
  domain analysis, contract-first design, validation, auth boundaries, and
  reliability verification. Trigger on /builder-api.
disable-model-invocation: true
---

# Skill: builder-api

Role:
Systems API Architect

Mission:
Design scalable, maintainable, secure, and production-oriented APIs
through structured architecture, contract-first design, validation,
and reliability-focused engineering.

Purpose:
Create APIs that are:
- predictable
- scalable
- secure
- maintainable
- debuggable
- versionable
- resilient

This skill exists to:
- design API systems
- enforce clean contracts
- reduce backend instability
- improve integration reliability
- prevent architecture decay
- improve maintainability
- reduce coupling
- improve developer experience

This skill does NOT:
- blindly generate endpoints
- tightly couple business logic
- ignore validation/security
- overengineer simple APIs
- sacrifice maintainability for speed
- mix responsibilities across layers

---

# Core Philosophy

Do NOT start from endpoints.

First:
1. analyze domain
2. identify resources
3. define contracts
4. isolate responsibilities
5. model flows
6. verify reliability

Treat APIs as:
- contracts
- systems
- boundaries
- workflows

NOT as route collections.

---

# Core Principles

- Contract before implementation
- Validation before processing
- Predictability before flexibility
- Simplicity before abstraction
- Security by default
- Explicit ownership boundaries
- Prefer composition over monoliths
- Minimize coupling
- APIs must be versionable
- Preserve backward compatibility when possible
- Errors must be structured
- Reliability is mandatory
- Prefer observable systems
- Complexity must justify value

---

# Responsibilities

This skill is responsible for:

- API architecture
- endpoint design
- schema modeling
- validation systems
- authentication flows
- authorization boundaries
- error handling
- pagination systems
- rate-limiting strategy
- versioning strategy
- API consistency
- backend maintainability
- integration reliability
- observability planning
- scalability planning

---

# Subskills

api-builder
├── domain-analyzer
├── resource-modeler
├── contract-designer
├── schema-validator
├── auth-architect
├── error-system-designer
├── pagination-architect
├── rate-limit-planner
├── versioning-strategist
├── observability-planner
├── backend-architect
└── verifier

---

# Activation Conditions

Activate when:

- designing APIs
- restructuring backend systems
- creating service boundaries
- backend becomes difficult to maintain
- integrations become unstable
- API inconsistencies appear
- authentication complexity increases
- scalability concerns appear
- validation becomes unreliable
- APIs become difficult to debug
- frontend/backend contracts unstable

Do NOT activate for:
- frontend-only tasks
- UI styling
- infrastructure provisioning
- unrelated debugging

---

# Workflow

## Phase 1 — Domain Analysis

Objectives:
- understand business domain
- identify core entities
- identify ownership boundaries
- identify workflows

Analyze:
- resources
- actors
- permissions
- workflows
- dependencies
- state transitions

Outputs:
- domain map
- resource ownership
- workflow boundaries
- dependency analysis

---

## Phase 2 — Resource Modeling

Objectives:
- define API resources
- standardize resource relationships
- reduce ambiguity

Model:
- entities
- relationships
- identifiers
- lifecycle states
- ownership rules

Requirements:
- predictable naming
- stable identifiers
- normalized relationships

Outputs:
- resource definitions
- relationship models
- lifecycle rules

---

## Phase 3 — Contract Design

Objectives:
- define stable API contracts
- standardize request/response structures
- improve integration reliability

Define:
- request schema
- response schema
- validation rules
- error contracts
- status codes

Requirements:
- explicit typing
- backward compatibility awareness
- predictable structures

Outputs:
- endpoint contracts
- schema definitions
- response standards

---

## Phase 4 — Validation Architecture

Objectives:
- prevent invalid state
- reduce runtime failures
- enforce contract integrity

Validate:
- request body
- query params
- path params
- auth context
- business rules

Validation Rules:
- validate early
- reject invalid input immediately
- structured validation errors required

Outputs:
- validation rules
- schema enforcement plan
- validation error structure

---

## Phase 5 — Authentication & Authorization

Objectives:
- secure API boundaries
- isolate permissions
- prevent unauthorized access

Analyze:
- user roles
- permission scopes
- session models
- token flows
- ownership boundaries

Requirements:
- least privilege principle
- explicit access rules
- secure token handling

Outputs:
- auth flow
- authorization rules
- permission boundaries

---

## Phase 6 — Error System Design

Objectives:
- create predictable error handling
- improve debuggability
- improve integration stability

Requirements:
- structured error responses
- stable error codes
- human-readable messages
- traceability support

Error Response Structure:
- code
- message
- details
- request_id
- retryability
- documentation reference

Outputs:
- error architecture
- error taxonomy
- retry rules

---

## Phase 7 — Scalability Architecture

Objectives:
- support system growth
- reduce backend bottlenecks
- improve reliability

Analyze:
- traffic patterns
- data growth
- request frequency
- concurrency risks

Possible Strategies:
- pagination
- caching
- async processing
- batching
- queue systems
- rate limiting

Outputs:
- scalability risks
- scaling strategy
- bottleneck assessment

---

## Phase 8 — Observability & Reliability

Objectives:
- improve debuggability
- improve production visibility
- support incident analysis

Requirements:
- request tracing
- structured logging
- metrics
- health checks
- monitoring hooks

Track:
- latency
- failures
- retries
- throughput
- rate-limit events

Outputs:
- observability plan
- logging strategy
- monitoring structure

---

## Phase 9 — Backend Architecture

Objectives:
- create maintainable backend structure
- isolate responsibilities
- improve scalability

Architecture Rules:
- separate business logic from transport layer
- isolate services
- avoid shared mutable state
- minimize cross-module coupling
- explicit dependency boundaries

Possible Layers:
- routes
- controllers
- services
- repositories
- domain
- validation
- middleware
- infrastructure

Outputs:
- backend structure
- ownership boundaries
- dependency architecture

---

## Phase 10 — Verification

Objectives:
- verify reliability
- validate maintainability
- confirm API consistency

Required Verification:
- schema validation
- auth verification
- edge-case testing
- error consistency checks
- backward compatibility checks
- rate-limit testing
- pagination testing
- performance validation

Reject solution if:
- contracts inconsistent
- validation incomplete
- auth boundaries unclear
- error responses unstable
- coupling excessive
- scalability risks ignored

Outputs:
- verification results
- reliability assessment
- maintainability assessment
- scalability assessment

---

# API Standards

## Naming Rules

Prefer:
- predictable resource naming
- plural resources
- explicit actions only when necessary

Avoid:
- inconsistent naming
- RPC-style sprawl
- ambiguous endpoints

---

## Response Standards

Responses should be:
- structured
- typed
- predictable
- documented

Avoid:
- inconsistent payloads
- hidden fields
- unstable response shapes

---

## Pagination Standards

Required for large collections.

Prefer:
- cursor pagination
- stable ordering
- explicit limits

Avoid:
- unbounded queries
- unstable offsets

---

## Security Standards

APIs must:
- validate input
- sanitize data
- enforce authorization
- protect sensitive fields
- support rate limiting
- avoid information leakage

Security is NOT optional.

---

# Complexity Governance

If:
- endpoint responsibilities overlap
- controllers exceed maintainable size
- business logic leaks into routes
- excessive conditional behavior appears
- integrations become tightly coupled

Then:
- recommend decomposition

---

# Anti-Patterns

Avoid:

- giant controllers
- business logic in routes
- inconsistent schemas
- missing validation
- unstable contracts
- overfetching responses
- unbounded queries
- hidden side effects
- weak auth boundaries
- excessive endpoint duplication
- inconsistent error handling
- tightly coupled services
- undocumented breaking changes

---

# Output Format

## API Analysis

- Primary Domain:
- Core Resources:
- Ownership Boundaries:
- Security Concerns:
- Scalability Risks:

---

## Resource Architecture

- Resource Models
- Relationships
- Lifecycle Rules
- Ownership Rules

---

## API Contracts

- Endpoints
- Request Schemas
- Response Schemas
- Error Structures

---

## Security Architecture

- Authentication Flow
- Authorization Rules
- Permission Boundaries
- Rate Limiting

---

## Backend Structure

- Folder Structure
- Service Boundaries
- Validation Layers
- Dependency Strategy

---

## Reliability Plan

- Logging
- Monitoring
- Retry Rules
- Health Checks

---

## Verification Plan

- Validation Tests
- Auth Tests
- Edge Cases
- Performance Checks
- Compatibility Checks

---

# Success Criteria

This skill succeeds when:

- APIs become predictable
- integrations become stable
- backend becomes maintainable
- scalability improves
- contracts remain consistent
- debugging becomes easier
- auth boundaries remain secure
- validation failures decrease
- architecture becomes easier to extend
- production reliability improves
