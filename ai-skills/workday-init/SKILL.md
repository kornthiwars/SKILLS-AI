---
name: workday-init
metadata:
  version: "1.2.1"
description: >-
  Daily work planner — emit WORKDAY block + write vault/workday/YYYY-MM-DD.md.
  Invoke with /workday-init at day start. Planning only; no app code.
disable-model-invocation: true
---

# Skill: workday-init

Role: Daily Work Planner

Mission: Transform raw user intentions into a structured, actionable WORKDAY plan for the current day.

## Purpose

Create a realistic daily execution plan from unstructured user input so a developer can start work immediately without needing additional task clarification.

Output contract: [`templates/template.workday.md`](../../templates/template.workday.md).

## Quick cheat sheet

| Phase | Action |
|-------|--------|
| **1 Intake** | Accept bullets, paragraphs, notes, ideas, partial requirements |
| **2 Extract** | Pull discrete tasks; preserve user intent |
| **3 Group** | Assign domain: API · WEB · SKILL · DOCS · OPS |
| **4 Decompose** | Split large items into actionable work items |
| **5 Analyze** | Risks, ambiguities, dependencies → **PROBLEMS** |
| **6 Emit** | Full **WORKDAY** block + write `vault/workday/YYYY-MM-DD.md` |

## When to use

- `/workday-init` or "plan my day" / "วางแผนวันนี้"
- Start of day with raw task list, notes, or mixed intentions
- Before execution when scope is unclear or scattered

## When NOT to use

- Mid-day scope changes → [`/workday-update`](../workday-update/SKILL.md)
- End-of-day audit → [`/workday-review`](../workday-review/SKILL.md)
- Implementing code — hand off to builder-* skills after plan is ready

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Plan ready — start building | [`/builder-feature`](../builder-feature/SKILL.md) · [`/builder-api`](../builder-api/SKILL.md) · [`/builder-ui`](../builder-ui/SKILL.md) |
| Scope changes during day | [`/workday-update`](../workday-update/SKILL.md) |
| Close of day | [`/workday-review`](../workday-review/SKILL.md) |
| Prior art before planning | [`/vault-recall`](../vault-recall/SKILL.md) |

## Scope Guardrails

- ALWAYS **write** `vault/workday/YYYY-MM-DD.md` per [reference.md](./reference.md) § Persistence.
- ALWAYS emit the **WORKDAY** block in chat and in the vault file.
- ALWAYS use task IDs `{DOMAIN}-{NNN}` (e.g. `API-001`, `WEB-002`).
- ALWAYS put risks and ambiguities in **PROBLEMS**; tag titles with `[AMBIGUOUS]` / `[BLOCKED]` when needed.
- NEVER implement code in this skill — planning output only.
- NEVER estimate completion time without evidence.
- NEVER perform speculative rewrites of the user's goals.

## Non-goals

- No app code commits
- No writing WORKDAY to `vault/issues/`
- No filling **PROGRESS** or **EVIDENCE** with fabricated completion — leave `—` or empty lists

---

# Workflow

1. **Intake** — accept all input formats (bullets, paragraphs, fragments).
2. **Extract tasks** — one line per actionable item; note source phrase when ambiguous.
3. **Group by domain**

   | Domain | Examples |
   |--------|----------|
   | **API** | Endpoints, contracts, backend logic, integrations |
   | **WEB** | UI, pages, components, client-side behavior |
   | **SKILL** | Cursor skills, rules, agent pack changes |
   | **DOCS** | README, runbooks, comments, user-facing docs |
   | **OPS** | Deploy, CI/CD, env, monitoring, infra |

4. **Decompose** — break tasks larger than ~2 hours of focused work into smaller items; assign next `{NNN}` per domain.
5. **PROBLEMS** — dependencies (as blockers), risks, missing requirements, ambiguities.
6. **NEXT** — ordered `→` lines; reference task IDs where helpful.
7. **DAY SCORE** — planned assessment (Focus / Progress=None or Weak / Risk) — not evidence-based yet.
8. **Persist** — write file per [reference.md](./reference.md) § Persistence; report path to user.

Optional: run [`/vault-recall`](../vault-recall/SKILL.md) when input references recurring issues.

---

# Required close-out output

Emit the full **WORKDAY** block — see [`template.workday.md`](../../templates/template.workday.md).

| Section | init fills |
|---------|------------|
| DATE | today |
| MISSION | one-line day goal |
| ACTIVE TASKS | all `[ ]` with `{DOMAIN}-{NNN} title` |
| PROGRESS | `—` |
| PROBLEMS | `•` risks, blockers, ambiguities |
| DISCOVERED TODAY | `—` |
| NEXT | `→` execution order (3+ when plan allows) |
| EVIDENCE | all fields `—` |
| DAY SCORE | Focus / Progress / Risk (planned, not verified) |

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/workday-init` |
|---------|-----------------|
| STATUS | READY = WORKDAY complete; BLOCKED = no input or critical ambiguity unresolved |
| OBJECTIVE | WORKDAY plan from user intentions |
| DISCOVERIES | Extracted tasks, ambiguities, missing requirements |
| ANALYSIS | Domain grouping, **NEXT** rationale |
| RISKS | Summarized from **PROBLEMS** |
| ARTIFACTS | Full **WORKDAY** block + path `vault/workday/YYYY-MM-DD.md` |
| NEXT ACTIONS | First **NEXT** arrow items |
| HANDOFF | `/builder-*` · `/workday-update` · `/vault-recall` · `none` |
| CONFIDENCE | 0–100; cap ~70 when **PROBLEMS** has unresolved ambiguities |

Close-out: render **WORKDAY** block as main body (after optional SKILL REPORT header).

---

# Success criteria

- **WORKDAY** block matches template exactly
- **`vault/workday/YYYY-MM-DD.md`** written (see [reference.md](./reference.md))
- Every user-stated intention appears in **ACTIVE TASKS** or **PROBLEMS** (as dropped-with-reason)
- Task IDs use `{DOMAIN}-{NNN}` format
- Developer can start first **NEXT** item without clarification
- No code was written during this skill run
