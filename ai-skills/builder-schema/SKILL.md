---
name: builder-schema
metadata:
  version: "1.2.6"
description: >-
  Use when modeling data, migrations, indexes, or schema evolution — integrity-safe
  plans with rollback. Use before destructive prod changes. Accepts slice briefs from
  /builder-feature. Invoke /builder-schema or "slice N go" for schema slices.
paths: "**/{migrations,schema,prisma,db,database}/**/*,**/*.{sql,prisma}"
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
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
- Application patches: follow [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) (patch budget, observe→verify, Active skill precedence).

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Full-stack feature (plan) | [`/builder-feature`](../builder-feature/SKILL.md) |
| Slice brief from feature plan | [reference.md](./reference.md) § Slice brief intake **before** phase 1 |
| Plan and execute migrations safely | project DB toolchain + production confirmation gates |
| API layer impact | [`/builder-api`](../builder-api/SKILL.md) |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |
| Destructive migration approved | [`/vault-recall`](../vault-recall/SKILL.md) before migrate · durable schema decision → [`/vault-capture`](../vault-capture/SKILL.md) |

Vertical slices: [builder-feature/reference-slice-handoff.md](../builder-feature/reference-slice-handoff.md) § Slice backlog.

## Quick cheat sheet

| # | Phase | Gate |
|---|--------|------|
| 0 | Slice brief intake | brief loaded or N/A |
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
| 0 | Slice brief intake | Outcome, Contracts, Verify from plan |
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

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-schema` |
|---------|-------------------|
| STATUS | IN_PROGRESS = phase N; READY = close-out gate passed; BLOCKED = missing domain input |
| OBJECTIVE | Data model, relationships, migrations, integrity plan |
| DISCOVERIES | Entities, lifecycles, query patterns, evolution constraints |
| ANALYSIS | Relationship map, indexing strategy, migration approach |
| RISKS | Integrity gaps, unsafe migrations, scalability bottlenecks |
| ARTIFACTS | Close-out: Domain Analysis, Entity Architecture, Relationship Architecture, Query & Indexing Plan, Integrity & Evolution Plan, Verification Plan |
| NEXT ACTIONS | Next workflow phase or open question |
| HANDOFF | `/builder-api` · `/builder-feature` · `/scrutinize` · `/vault-recall` · `/vault-capture` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.
