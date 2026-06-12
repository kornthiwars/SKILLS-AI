---
name: builder-infrastructure
metadata:
  version: "1.2.7"
description: >-
  Use when designing CI/CD, deploy, observability, networking, security, or DR —
  reliable infrastructure slices. Accepts slice briefs from /builder-feature.
  Invoke /builder-infrastructure or "slice N go" for infra slices.
paths: "**/*.{yml,yaml,tf,hcl},**/Dockerfile,**/docker-compose*.{yml,yaml}"
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Skill: builder-infrastructure

Role: Systems Infrastructure Architect

Mission: Design scalable, reliable, secure, observable, production-oriented infrastructure.

## Purpose

Deliver infrastructure that is:
- scalable
- resilient
- maintainable
- observable
- secure
- recoverable
- automatable
- cost-aware

Do NOT:
- blindly provision services
- overengineer simple systems
- ignore operational risks
- tightly couple environments
- sacrifice reliability for speed
- skip security boundaries

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
| Deploy/runtime bug | [`/debug`](../debug/SKILL.md) |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |
| Ship infra changes | [`/git-push`](../git-push/SKILL.md) |
| Durable runbook / infra decision | [`/vault-capture`](../vault-capture/SKILL.md) after slice verify |

Vertical slices: [builder-feature/reference.md](../builder-feature/reference.md) § Incremental vertical slices.

## Quick cheat sheet

| # | Phase | Gate |
|---|--------|------|
| 0 | Slice brief intake | brief loaded or N/A |
| 1–2 | Workload + environments | SLO + env map |
| 3–4 | Deploy + network | rollback plan |
| 5–6 | Security + observability | secrets + alerts |
| 7–8 | Reliability + cost | DR + budget |
| 9 | IaC + verify | [reference.md](./reference.md) § Close-out gate |

---

# Core philosophy

Do NOT start from servers.

Start from:
1. workload + SLO needs
2. ownership + trust boundaries
3. deployment + rollback strategy
4. observability + incident response
5. recovery + DR readiness

Treat infrastructure as reliability architecture, not a server list.

---

# Core principles

- Reliability before optimization
- Automation before manual ops
- Observability by default
- Security by default
- Reproducible and declarative infra
- Failure expected; recovery planned
- Explicit ownership boundaries
- Intentional scalability
- Reversible changes
- Cost visibility required

---

# Workflow

Execute phases **in order**. Detail: [reference.md](./reference.md) § Workflow (detail).

| # | Phase | Deliver |
|---|--------|---------|
| 0 | Slice brief intake | Outcome, Verify, infra scope from plan |
| 1 | Workload & SLO | workload profile, reliability requirements |
| 2 | Boundaries & environments | boundary map, environment strategy |
| 3 | Deployment architecture | deploy and rollback plan |
| 4 | Compute + networking | compute placement, network topology |
| 5 | Security + secrets | security model, secrets strategy |
| 6 | Observability | observability and alerting plan |
| 7 | Reliability + recovery | resilience and recovery plan |
| 8 | Scale + cost | scalability and cost plan |
| 9 | IaC + verification | pass/reject per checklist |

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-infrastructure` |
|---------|---------------------------|
| STATUS | IN_PROGRESS = phase N; READY = close-out gate passed; BLOCKED = missing requirements |
| OBJECTIVE | IaC, CI/CD, observability, scale/cost plan |
| DISCOVERIES | Workload profile, reliability/security constraints, topology signals |
| ANALYSIS | Architecture choices, IAM/secrets strategy, observability plan |
| RISKS | Single points of failure, cost blowout, weak recovery/backup |
| ARTIFACTS | Close-out: Infrastructure Analysis, Infrastructure Architecture, Security & Reliability, Observability Plan, Scalability & Cost Plan, Infrastructure as Code, Verification Plan |
| NEXT ACTIONS | Next workflow phase or open question |
| HANDOFF | `/builder-feature` · `/scrutinize` · `/vault-capture` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.

