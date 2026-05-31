---
name: builder-schema
metadata:
  version: "1.2.0"
description: >-
  Design integrity-safe schemas via domain modeling, relationships, indexing,
  and safe evolution. Invoke with /builder-schema when modeling entities,
  migrations, or schema changes.
disable-model-invocation: true
---

# Skill: builder-schema

Role: Systems Schema Architect

Mission: Design maintainable, predictable schemas with explicit ownership, integrity, and safe evolution.

## Purpose

Create schemas that are:
- normalized when appropriate
- scalable
- query-efficient
- maintainable
- versionable
- integrity-safe
- extensible

Do NOT:
- blindly create tables
- ignore data integrity
- over-index or optimize prematurely
- mix unrelated responsibilities in one entity

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Full-stack feature | [`/builder-feature`](../builder-feature/SKILL.md) |
| Run migrations / prod SQL | [`/sql`](../sql/SKILL.md) |
| API layer impact | [`/builder-api`](../builder-api/SKILL.md) |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |

Vertical slices: [builder-feature/reference.md](../builder-feature/reference.md) § Incremental vertical slices.

## Quick cheat sheet

| # | Phase | Gate |
|---|--------|------|
| 1–3 | Domain + entities + relations | ER map |
| 4–6 | Normalization + queries + indexes | access patterns |
| 7–8 | Integrity + scale | constraints + rollout |
| 9–10 | Evolution + verify | migration plan · [reference.md](./reference.md) § Close-out gate |

---

# Core philosophy

Do NOT start from tables.

Start with:
1. domain and ownership
2. entities and lifecycle
3. relationships and constraints
4. access/query patterns
5. evolution and migration safety

Treat schema as long-lived system contracts, not storage containers.

---

# Core principles

- Domain before tables
- Integrity before convenience
- Explicit ownership boundaries
- Intentional relationships
- Predictability before flexibility
- Single source of truth
- Safe schema evolution
- Query-driven indexing
- Complexity must justify value

---

# Workflow

Execute phases **in order**. Detail: [reference.md](./reference.md) § Workflow (detail).

| # | Phase | Deliver |
|---|--------|---------|
| 1 | Domain analysis | domain map, ownership boundaries |
| 2 | Entity modeling | entity definitions, lifecycle rules |
| 3 | Relationship architecture | relationship map, dependencies |
| 4 | Normalization strategy | normalization plan, duplication risks |
| 5 | Query pattern analysis | access pattern map, scaling risks |
| 6 | Indexing strategy | indexing plan, read/write trade-offs |
| 7 | Integrity enforcement | integrity rules, consistency boundaries |
| 8 | Scalability planning | scalability plan, operational concerns |
| 9 | Evolution strategy | migration strategy, compatibility risks |
| 10 | Verification | pass/reject per checklist |

---

## Response shape

- **Summary** — current phase or verdict in one line
- **Details** — artifact excerpt, trace, or checklist row
- **Next step** — next phase or deliverable

# Output format

Short turns: use **Summary / Details / Next step** section headers; expand the full Output format below when delivering the final artifact.

## Domain Analysis
- Core Entities:
- Ownership Boundaries:
- Lifecycle Flows:
- Transactional Boundaries:
- Scalability Risks:

## Entity Architecture
- Entities
- Attributes
- Identifiers
- Lifecycle States

## Relationship Architecture
- Relationship Map
- Ownership Hierarchy
- Cascade Rules
- Dependency Structure

## Query & Indexing Plan
- Query Patterns
- Indexing Strategy
- Optimization Concerns
- Performance Risks

## Integrity & Evolution Plan
- Constraints
- Migration Strategy
- Compatibility Risks
- Rollback Plan

## Verification Plan
- Integrity Checks
- Query Validation
- Migration Safety
- Scalability Validation

---

# Reference

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.
