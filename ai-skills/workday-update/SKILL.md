---
name: workday-update
metadata:
  version: "1.2.1"
description: >-
  Daily task change manager — merge discoveries into WORKDAY + vault/workday file.
  Invoke with /workday-update during the day. Planning only.
disable-model-invocation: true
---

# Skill: workday-update

Role: Daily Task Change Manager

Mission: Maintain an accurate WORKDAY plan throughout the day as new work appears.

## Purpose

Capture work discovered during execution and integrate it into the active WORKDAY block while preserving original task history and preventing duplicate tasks.

Output contract: [`templates/template.workday.md`](../../templates/template.workday.md).

## Quick cheat sheet

| Step | Action |
|------|--------|
| **1 Context** | Load current WORKDAY (chat, vault, or user paste) |
| **2 Detect** | New tasks, bugs, change requests, refactors, research |
| **3 Relate** | Link to existing `{DOMAIN}-{NNN}` before creating new ID |
| **4 Dedupe** | Merge or skip duplicates |
| **5 Update** | **DISCOVERED TODAY**, **ACTIVE TASKS**, **PROBLEMS**, **NEXT** |
| **6 Emit** | Full **WORKDAY** + overwrite `vault/workday/YYYY-MM-DD.md` |

## When to use

- `/workday-update` or "update my plan" / "มีงานเพิ่ม"
- New bug, client request, refactor need, or implementation finding mid-day
- Priority shift or blocker discovered during execution

## When NOT to use

- First plan of the day → [`/workday-init`](../workday-init/SKILL.md)
- End-of-day audit → [`/workday-review`](../workday-review/SKILL.md)
- Implementing the discovered work — hand off to builder-* or `/debug`

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| No WORKDAY exists yet | [`/workday-init`](../workday-init/SKILL.md) first |
| Bug needs root cause | [`/debug`](../debug/SKILL.md) |
| Close of day | [`/workday-review`](../workday-review/SKILL.md) |
| Resume execution | [`/builder-feature`](../builder-feature/SKILL.md) · domain builders |

## Scope Guardrails

- ALWAYS load from `vault/workday/YYYY-MM-DD.md` when present — see [workday-init/reference.md](../workday-init/reference.md) § Load protocol.
- ALWAYS **write** updated file in place per [workday-init/reference.md](../workday-init/reference.md) § Persistence (bump `plan_version`).
- ALWAYS re-emit the **full WORKDAY** block in chat and vault file.
- ALWAYS append to **DISCOVERED TODAY** with `+` lines (source + discovery reason).
- ALWAYS relate new work to existing `{DOMAIN}-{NNN}` before minting a new ID.
- NEVER create duplicate tasks — merge or note `duplicate of API-001` in **DISCOVERED TODAY**.
- NEVER remove completed **PROGRESS** lines or `[x]` tasks without explicit user request.
- NEVER implement code in this skill — plan maintenance only.

## Non-goals

- No app code commits
- No writing to `vault/issues/`
- No full replan from scratch unless user requests — preserve **MISSION** and history
- No evidence-based **PROGRESS** or **EVIDENCE** — that is [`/workday-review`](../workday-review/SKILL.md)

---

# Workflow

1. **Load WORKDAY** — from `vault/workday/YYYY-MM-DD.md`, chat, or user paste. If missing, hand off to `/workday-init`.
2. **Parse new input** — bugs, client requests, refactors, research, partial completions (user-reported only).
3. **Classify** — new task · bug · change request · refactor · research · blocker.
4. **DISCOVERED TODAY** — add `+ {DOMAIN}-{NNN} title — source: … — reason: …`
5. **ACTIVE TASKS** — add new `[ ]` rows; update `[~]` if user reports partial work; never `[x]` without review evidence.
6. **PROBLEMS** — append `•` for new blockers, scope creep, priority conflicts.
7. **NEXT** — re-order `→` lines with brief rationale in **DISCOVERED TODAY** or **PROBLEMS** if priority shifted.
8. **PROGRESS** — add `✓` only when user explicitly reports completion (mark `[UNVERIFIED]` until `/workday-review`).

8. **Persist** — overwrite file, bump `plan_version`, report path.

New task IDs: next `{NNN}` in that domain for the day.

---

# Required close-out output

Emit the **full updated WORKDAY** block — see [`template.workday.md`](../../templates/template.workday.md).

| Section | update changes |
|---------|----------------|
| DATE / MISSION | preserve unless user reframes goal |
| ACTIVE TASKS | add/merge; `[~]` for partial; dedupe |
| PROGRESS | append user-reported `✓` only `[UNVERIFIED]` optional |
| PROBLEMS | append new items |
| DISCOVERED TODAY | append `+` lines with source + reason |
| NEXT | re-prioritized `→` list |
| EVIDENCE | preserve or `—`; optional partial if user cites files |
| DAY SCORE | refresh Focus/Risk if priority shifted |

Include one `+` meta line: `+ plan v{N} — {reason for this update}`.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/workday-update` |
|---------|-------------------|
| STATUS | READY = WORKDAY updated; BLOCKED = no base plan and user declined init |
| OBJECTIVE | Accurate mid-day WORKDAY after discoveries |
| DISCOVERIES | New items, duplicates avoided, blockers |
| ANALYSIS | Impact on **NEXT** and **PROBLEMS** |
| RISKS | Scope creep, conflicting priorities |
| ARTIFACTS | Full **WORKDAY** block + path `vault/workday/YYYY-MM-DD.md` |
| NEXT ACTIONS | Top **NEXT** arrows |
| HANDOFF | `/debug` · `/builder-*` · `/workday-review` · `none` |
| CONFIDENCE | 0–100; lower if base WORKDAY was incomplete |

---

# Success criteria

- Full **WORKDAY** block emitted; **`vault/workday/YYYY-MM-DD.md`** updated
- No duplicate task IDs for the same work
- Every discovery has `+` line with source and reason
- Original tasks preserved; history visible in **DISCOVERED TODAY**
- **NEXT** reflects current priority
- No code was written during this skill run
