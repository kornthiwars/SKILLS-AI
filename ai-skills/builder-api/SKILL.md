---
name: builder-api
metadata:
  version: "1.2.0"
description: >-
  Design scalable, secure, contract-first APIs with validation, auth boundaries,
  error systems, versioning, and observability. Invoke with /builder-api when
  designing or refactoring API contracts, endpoints, or backend service boundaries.
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

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Full-stack feature | [`/builder-feature`](../builder-feature/SKILL.md) |
| Data model / migrations | [`/builder-schema`](../builder-schema/SKILL.md) |
| Execute SQL / migrations | [`/sql`](../sql/SKILL.md) |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |
| API runtime bug | [`/debug`](../debug/SKILL.md) |

Vertical slices: [builder-feature/reference.md](../builder-feature/reference.md) § Incremental vertical slices.

## Quick cheat sheet

| # | Phase | Gate |
|---|--------|------|
| 1–2 | Domain + resources | ownership map |
| 3–4 | Contracts + validation | OpenAPI/schema draft |
| 5–6 | Auth + errors | auth matrix + error taxonomy |
| 7–8 | Scale + observability | SLO + metrics plan |
| 9–10 | Structure + verify | [reference.md](./reference.md) § Close-out gate |

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

# Workflow

Execute phases **in order**. Detail: [reference.md](./reference.md) § Workflow (detail).

| # | Phase | Deliver |
|---|--------|---------|
| 1 | Domain analysis | domain map, ownership map |
| 2 | Resource modeling | resource model, lifecycle rules |
| 3 | Contract design | endpoint contracts, schemas |
| 4 | Validation architecture | validation plan, error standard |
| 5 | AuthN/AuthZ | auth flow, authorization matrix |
| 6 | Error system | error taxonomy, retry guidance |
| 7 | Scalability architecture | scaling strategy, bottlenecks |
| 8 | Observability + reliability | observability plan |
| 9 | Backend architecture | structure, dependency boundaries |
| 10 | Verification | pass/reject per checklist |

---

## Response shape

- **Summary** — current phase or verdict in one line
- **Details** — artifact excerpt, trace, or checklist row
- **Next step** — next phase or deliverable

# Output format

Short turns: use **Summary / Details / Next step** section headers; expand the full Output format below when delivering the final artifact.

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

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.
