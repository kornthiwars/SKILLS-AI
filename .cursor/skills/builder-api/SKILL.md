---
name: builder-api
metadata:
  version: "1.0.1"
description: >-
  Design scalable, secure, contract-first APIs with clear validation,
  auth boundaries, error systems, versioning, and observability.
  Trigger on /builder-api. Use when designing or refactoring API contracts, endpoints, validation, auth, versioning, or backend service boundaries.
paths:
  - "**/*.{ts,tsx,js,jsx,py,go,java,kt,rb,php,cs,rs}"
  - "**/openapi*.{yml,yaml,json}"
  - "**/*api*.*"
disable-model-invocation: true
---

# Skill: builder-api

Role: Systems API Architect

Mission: Design maintainable, secure, production-oriented APIs with stable contracts and reliability controls.

## Purpose

Create APIs that are:
- predictable
- scalable
- secure
- maintainable
- debuggable
- versionable
- resilient

Do NOT:
- blindly generate endpoints
- couple business logic to transport layer
- skip validation/security
- overengineer simple APIs

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

---

# Core philosophy

Do NOT start from endpoints.

Start with:
1. domain and resources
2. ownership boundaries
3. contracts and validation
4. auth and error model
5. scalability and observability
6. verification and compatibility

Treat APIs as contracts and boundaries, not route collections.

---

# Core principles

- Contract before implementation
- Validation before processing
- Security by default
- Explicit ownership boundaries
- Structured errors mandatory
- Backward compatibility awareness
- Reliability + observability required
- Complexity must justify value

---

# Activation

Use when:
- designing APIs
- refactoring backend boundaries
- integration instability appears
- auth/validation complexity rises
- API consistency degrades

Do NOT use for:
- frontend-only tasks
- DB-only schema work (`/builder-schema`)
- infrastructure-only work (`/builder-infrastructure`)

---

# Workflow

## 1) Domain analysis

Identify:
- actors and permissions
- resources and workflows
- ownership boundaries
- state transitions

Output:
- domain map
- ownership map

## 2) Resource modeling

Define:
- entities and identifiers
- relationships and lifecycle states
- naming standards

Output:
- resource model
- lifecycle rules

## 3) Contract design

Define per endpoint:
- request schema
- response schema
- status code behavior
- error contract

Output:
- endpoint contract set
- schema definitions

## 4) Validation architecture

Validate:
- path/query/body
- auth context
- business invariants

Rules:
- validate early
- reject invalid input immediately
- structured validation errors

Output:
- validation plan
- error payload standard

## 5) AuthN/AuthZ

Design:
- session/token flow
- role/scope checks
- ownership-based access

Output:
- auth flow
- authorization matrix

## 6) Error system

Require fields:
- code
- message
- details
- request_id
- retryability
- docs reference

Output:
- error taxonomy
- retry guidance

## 7) Scalability architecture

Assess:
- traffic profile
- concurrency and hotspots
- pagination and caching
- batching/async opportunities
- rate limiting

Output:
- scaling strategy
- bottleneck risks

## 8) Observability + reliability

Require:
- structured logs
- metrics and tracing
- health checks
- latency/failure tracking

Output:
- observability plan

## 9) Backend architecture

Layer boundaries:
- routes/controllers
- services
- repositories/domain
- validation/middleware

Rules:
- separate transport from business logic
- minimize cross-module coupling

Output:
- backend structure
- dependency boundaries

## 10) Verification

Verify:
- contract consistency
- validation coverage
- auth boundaries
- error consistency
- backward compatibility
- pagination/rate-limit behavior
- performance basics

Reject if:
- inconsistent contracts
- unclear auth boundaries
- unstable error payloads
- missing validation

---

# Output format

## API Analysis
- Primary Domain:
- Core Resources:
- Ownership Boundaries:
- Security Concerns:
- Scalability Risks:

## Resource Architecture
- Resource Models
- Relationships
- Lifecycle Rules
- Ownership Rules

## API Contracts
- Endpoints
- Request Schemas
- Response Schemas
- Error Structures

## Security Architecture
- Authentication Flow
- Authorization Rules
- Permission Boundaries
- Rate Limiting

## Backend Structure
- Folder Structure
- Service Boundaries
- Validation Layers
- Dependency Strategy

## Reliability Plan
- Logging
- Monitoring
- Retry Rules
- Health Checks

## Verification Plan
- Validation Tests
- Auth Tests
- Edge Cases
- Performance Checks
- Compatibility Checks

---

# Reference

Use `.cursor/skills/builder-api/reference.md` for extended checklists and anti-patterns.
