---
name: workday-update
metadata:
  version: "1.0.0"
description: >-
  Daily task change manager — integrate newly discovered work, bugs, and scope changes
  into the active workday plan without duplicates. Invoke with /workday-update during
  the day. Planning only; no code implementation.
disable-model-invocation: true
---

# Skill: workday-update

Role: Daily Task Change Manager

Mission: Maintain an accurate task list throughout the day as new work appears.

## Purpose

Capture work discovered during execution and integrate it into the active workday plan while preserving original task history and preventing duplicate tasks.

## Quick cheat sheet

| Step | Action |
|------|--------|
| **1 Context** | Load current plan (from chat, vault issue, or user paste) |
| **2 Detect** | New tasks, bugs, change requests, refactors, research |
| **3 Relate** | Link each item to existing task ID when possible |
| **4 Dedupe** | Merge or skip if same work already listed |
| **5 Update** | Priorities, dependencies, execution order |
| **6 Emit** | Five required sections below |

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
| No plan exists yet | [`/workday-init`](../workday-init/SKILL.md) first |
| Bug needs root cause | [`/debug`](../debug/SKILL.md) |
| Close of day | [`/workday-review`](../workday-review/SKILL.md) |
| Resume execution | [`/builder-feature`](../builder-feature/SKILL.md) · domain builders |

## Scope Guardrails

- ALWAYS attempt to relate new work to an existing task ID before creating a new one.
- ALWAYS record task source (user, client, code finding, CI, etc.) and discovery reason.
- ALWAYS preserve original task history — append updates; do not silently delete completed or deferred items.
- NEVER create duplicate tasks — merge, cross-reference, or mark as duplicate of `{ID}`.
- NEVER implement code in this skill — plan maintenance only.
- NEVER discard user-stated priorities without explicit confirmation.

## Non-goals

- No commits, no file edits (unless user explicitly asks to persist plan to vault)
- No re-planning the entire day from scratch unless user requests full replan
- No marking tasks complete — that is [`/workday-review`](../workday-review/SKILL.md)

---

# Workflow

1. **Load active plan** — from conversation, `vault/issues/{today}.md`, or user-provided snapshot. If none exists, hand off to `/workday-init`.
2. **Parse new input** — bugs, client requests, refactor requests, research spikes, blockers.
3. **Classify each item**

   | Type | Examples |
   |------|----------|
   | New task | Net-new scope |
   | Bug | Defect found during work |
   | Change request | Client or stakeholder ask |
   | Refactor | Tech debt surfaced |
   | Research | Unknown before starting |

4. **Relate** — map to `{DOMAIN}-{n}` from morning plan; use `→ extends API-2` or `→ blocked by OPS-1`.
5. **Dedupe** — same symptom + same file = update existing, not new ID.
6. **Re-prioritize** — only when discovery implies urgency change; state old vs new priority.
7. **Re-order** — updated execution sequence with rationale.

---

# Required output sections

Deliver **all five** in every close-out response:

1. **New Tasks** — table: ID (new or existing), title, type, source, discovery reason, domain.
2. **Related Tasks** — links: new/updated item → related `{ID}` → relationship (extends, blocks, duplicates, supersedes).
3. **Priority Changes** — table: task ID, was, now, reason.
4. **Dependency Changes** — added/removed/changed edges since last plan version.
5. **Updated Execution Order** — full numbered list reflecting current state.

Include a one-line **Plan version** note (e.g. "v2 — after client pagination request").

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/workday-update` |
|---------|-------------------|
| STATUS | READY = plan updated; BLOCKED = no base plan and user declined init |
| OBJECTIVE | Accurate mid-day plan after new discoveries |
| DISCOVERIES | New items, duplicates avoided, blockers |
| ANALYSIS | Priority/dependency impact summary |
| RISKS | Scope creep, conflicting priorities, orphaned tasks |
| ARTIFACTS | Five required sections + plan version |
| NEXT ACTIONS | Resume execution at step N; or questions to unblock |
| HANDOFF | `/debug` · `/builder-*` · `/workday-review` · `none` |
| CONFIDENCE | 0–100; lower if base plan was incomplete or ambiguous |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Success criteria

- No duplicate tasks introduced
- Every new item has source and discovery reason
- Original plan history preserved (completed/deferred items still visible)
- Priority and dependency changes explicit with rationale
- Updated execution order is immediately actionable
- No code was written during this skill run
