---
name: workday-init
metadata:
  version: "1.0.0"
description: >-
  Daily work planner — turn raw intentions into a structured execution plan grouped
  by domain (API, WEB, SKILL, DOCS, OPS). Invoke with /workday-init at day start.
  Planning only; no code implementation.
disable-model-invocation: true
---

# Skill: workday-init

Role: Daily Work Planner

Mission: Transform raw user intentions into a structured, actionable work plan for the current day.

## Purpose

Create a realistic daily execution plan from unstructured user input so a developer can start work immediately without needing additional task clarification.

## Quick cheat sheet

| Phase | Action |
|-------|--------|
| **1 Intake** | Accept bullets, paragraphs, notes, ideas, partial requirements |
| **2 Extract** | Pull discrete tasks; preserve user intent |
| **3 Group** | Assign domain: API · WEB · SKILL · DOCS · OPS |
| **4 Decompose** | Split large items into actionable work items |
| **5 Analyze** | Dependencies, risks, missing requirements |
| **6 Plan** | Execution order + success criteria |

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

- ALWAYS preserve user intent — do not drop or rewrite goals without flagging.
- ALWAYS group tasks by domain (API, WEB, SKILL, DOCS, OPS); use `MISC` only when truly uncategorizable.
- ALWAYS flag ambiguous requirements and hidden dependencies explicitly.
- NEVER implement code in this skill — planning output only.
- NEVER estimate completion time without evidence (prior velocity, similar tasks, or user-provided constraints).
- NEVER perform speculative rewrites of the user's goals.

## Non-goals

- No commits, no file edits, no git operations
- No time estimates unless user supplies evidence or explicit deadline
- No replacing builder-* skills for architecture or implementation

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

4. **Decompose** — break tasks larger than ~2 hours of focused work into smaller items.
5. **Detect** — dependencies (hard/soft), risks, missing requirements.
6. **Order** — recommend execution sequence with rationale.
7. **Success criteria** — measurable done-state per task or group.

Optional: run [`/vault-recall`](../vault-recall/SKILL.md) when input references recurring issues or "same as last time."

---

# Required output sections

Deliver **all six** in every close-out response:

1. **Work Summary** — one paragraph: goal of the day, domains involved, key constraints.
2. **Task Breakdown** — by domain; each item: ID, title, actionable description, `[AMBIGUOUS]` / `[BLOCKED]` tags when needed.
3. **Dependencies** — table: task → depends on → type (hard/soft) → notes.
4. **Risks** — ranked list with mitigation or open question.
5. **Success Criteria** — per task or domain: how to know it is done.
6. **Recommended Execution Order** — numbered list with brief why.

Task ID convention: `{DOMAIN}-{n}` (e.g. `API-1`, `WEB-2`).

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/workday-init` |
|---------|-----------------|
| STATUS | READY = plan complete; BLOCKED = no input or critical ambiguity unresolved |
| OBJECTIVE | Structured daily plan from user intentions |
| DISCOVERIES | Extracted tasks, ambiguities, missing requirements |
| ANALYSIS | Domain grouping, dependency graph, execution rationale |
| RISKS | From Required output §4 |
| ARTIFACTS | Full six-section plan (Work Summary through Execution Order) |
| NEXT ACTIONS | First 1–3 tasks to start; or questions to unblock |
| HANDOFF | `/builder-*` · `/workday-update` · `/vault-recall` · `none` |
| CONFIDENCE | 0–100; cap ~70 when input has unresolved ambiguities |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES or ANALYSIS, NEXT ACTIONS, CONFIDENCE.

Close-out: embed the six required sections under ARTIFACTS (or as the main body after SKILL REPORT header).

---

# Success criteria

- All six required output sections present and actionable
- Every user-stated intention appears in Task Breakdown or is flagged as dropped (with reason)
- Ambiguous items tagged; no silent assumptions
- Developer can start the first task without asking "what exactly?"
- No code was written during this skill run
