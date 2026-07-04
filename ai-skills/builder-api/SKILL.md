---
name: builder-api
metadata:
  version: "1.2.11"
description: >-
  Use when designing or implementing API endpoints, contracts, auth boundaries, or
  error shapes — validation, versioning, observability. Accepts slice briefs from
  /builder-feature. Invoke /builder-api or "slice N go" for API slices.
paths: "**/{api,routes,controllers,handlers,services}/**/*.{ts,js,py,go,rs}"
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
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

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails · app code: [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc).

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Full-stack feature (plan) | [`/builder-feature`](../builder-feature/SKILL.md) |
| Slice brief from feature plan | [reference.md](./reference.md) § Slice brief intake **before** phase 1 |
| Data model / migrations | [`/builder-schema`](../builder-schema/SKILL.md) |
| Execute migration plan / schema evolution | [`/builder-schema`](../builder-schema/SKILL.md) + project DB toolchain |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |
| API runtime bug | [`/debug`](../debug/SKILL.md) |
| Contract change | [`/vault-recall`](../vault-recall/SKILL.md) before breaking change · ADR after slice verify → [`/vault-capture`](../vault-capture/SKILL.md) |

Vertical slices: [builder-feature/reference-slice-handoff.md](../builder-feature/reference-slice-handoff.md) § Slice backlog.

## Quick cheat sheet

| # | Phase | Gate |
|---|--------|------|
| 0 | Slice brief intake | brief loaded or N/A (standalone API) |
| 1–2 | Domain + resources | ownership map |
| 3–4 | Contracts + validation | OpenAPI/schema draft |
| 5–6 | Auth + errors | auth matrix + error taxonomy |
| 7–8 | Scale + observability | SLO + metrics plan |
| 9–10 | Structure + verify | [reference.md](./reference.md) § Close-out gate |

Philosophy & phase detail: [reference.md](./reference.md) § Philosophy · § Workflow (detail).

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-api` |
|---------|----------------|
| STATUS | IN_PROGRESS = phase N; READY = close-out gate passed; BLOCKED = missing reference/input |
| OBJECTIVE | API contracts and backend boundaries from domain requirements |
| DISCOVERIES | Resources, ownership, security/scalability signals |
| ANALYSIS | Service boundaries, contract choices, reliability plan |
| RISKS | Auth gaps, breaking contracts, missing validation layers |
| ARTIFACTS | Close-out deliverables: [reference.md](./reference.md) § Close-out deliverables |
| NEXT ACTIONS | Next workflow phase or open question |
| HANDOFF | `/builder-feature` · `/builder-schema` · `/scrutinize` · `/vault-recall` · `/vault-capture` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.
