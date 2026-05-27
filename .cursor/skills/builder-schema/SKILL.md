---
name: builder-schema
description: >-
  Design scalable, integrity-safe schemas through domain modeling,
  relationship architecture, indexing, migration safety, and evolution planning.
  Trigger on /builder-schema.
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

# Activation

Use when:
- designing databases
- restructuring schemas
- scaling backend data systems
- duplication/integrity issues appear
- migrations become risky
- query performance degrades

Do NOT use for:
- frontend-only tasks
- infra-only tasks
- cosmetic refactors

---

# Workflow

## 1) Domain analysis

Identify:
- actors, workflows, permissions
- entity ownership boundaries
- lifecycle and state transitions
- transactional boundaries

Output:
- domain map
- ownership boundaries

## 2) Entity modeling

Define:
- entities and attributes
- stable identifiers
- lifecycle states
- ownership rules

Output:
- entity definitions
- lifecycle rules

## 3) Relationship architecture

Model:
- one-to-one
- one-to-many
- many-to-many
- hierarchical/polymorphic where justified

Require:
- explicit FKs
- clear ownership
- predictable cascade behavior

Avoid:
- circular dependencies
- ambiguous ownership

Output:
- relationship map
- dependency structure

## 4) Normalization strategy

Evaluate:
- normalization level
- denormalization trade-offs
- read/write/update patterns

Require:
- controlled denormalization only
- duplicate source-of-truth avoidance

Output:
- normalization plan
- duplication risk assessment

## 5) Query pattern analysis

Analyze:
- read-heavy/write-heavy paths
- filters, sorts, aggregations
- pagination needs

Output:
- access pattern map
- scaling risks

## 6) Indexing strategy

Design:
- primary/unique/composite indexes
- partial/full-text where justified

Rule:
- index must map to real query patterns
- avoid over-indexing write-heavy paths

Output:
- indexing plan
- write/read trade-offs

## 7) Integrity enforcement

Require:
- FK constraints
- uniqueness constraints
- check constraints
- transactional guarantees

Output:
- integrity rules
- consistency boundaries

## 8) Scalability planning

Assess:
- data and query growth
- concurrency risks
- partitioning/replica/caching needs

Output:
- scalability plan
- operational concerns

## 9) Evolution strategy

Plan:
- backward compatibility
- safe migration sequencing
- rollback strategy
- deprecation lifecycle

Consider:
- nullable transitions
- dual-write windows

Output:
- migration strategy
- compatibility risks

## 10) Verification

Verify:
- relationship stability
- integrity constraints
- migration safety
- indexing validity
- query performance profile
- duplication/ownership clarity

Reject if:
- ownership unclear
- relationships unstable
- migrations unsafe
- indexing unjustified

---

# Output format

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

Use `.cursor/skills/builder-schema/reference.md` for extended checklists and anti-patterns.
