---
name: workday-review
metadata:
  version: "1.1.0"
description: >-
  End-of-day auditor — fill WORKDAY PROGRESS and EVIDENCE from git/code vs plan.
  Invoke with /workday-review. Never marks complete from conversation alone.
disable-model-invocation: true
---

# Skill: workday-review

Role: Daily Work Auditor

Mission: Produce an evidence-based end-of-day WORKDAY report using code, git activity, and the planned work.

## Purpose

Determine what was actually accomplished and what remains unfinished — grounded in repository evidence, not conversation alone.

Output contract: [`templates/template.workday.md`](../../templates/template.workday.md).

## Quick cheat sheet

| Step | Source (priority) | Action |
|------|-------------------|--------|
| **1 Evidence** | Codebase + git | `git status`, `git log`, `git diff` |
| **2 Plan** | WORKDAY block | Match `{DOMAIN}-{NNN}` to changes |
| **3 Classify** | Compare | **PROGRESS** · `[x]`/`[~]`/`[ ]` · unplanned |
| **4 Emit** | Synthesize | Full **WORKDAY** with **EVIDENCE** + **DAY SCORE** |

**Evidence rule:** every `✓` in **PROGRESS** and every `[x]` in **ACTIVE TASKS** requires **EVIDENCE** citation.

## When to use

- `/workday-review` or "end of day review" / "สรุปวันนี้"
- Close of day when you need honest progress vs plan
- Before tomorrow's [`/workday-init`](../workday-init/SKILL.md) — **NEXT** becomes carry-over

## When NOT to use

- Morning planning → [`/workday-init`](../workday-init/SKILL.md)
- Mid-day scope change → [`/workday-update`](../workday-update/SKILL.md)
- RCA for a specific bug → [`/fix-record`](../fix-record/SKILL.md)

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Plan tomorrow | [`/workday-init`](../workday-init/SKILL.md) — seed from **NEXT** |
| Unplanned bug found | [`/debug`](../debug/SKILL.md) |
| Ship today's work | [`/git-push`](../git-push/SKILL.md) |
| Document reusable lesson | vault learning per `vault-issues.mdc` |

## Scope Guardrails

- ALWAYS gather git/code evidence before filling **PROGRESS** or `[x]`.
- ALWAYS fill **EVIDENCE** section from inspection (commit, files, tests, docs).
- ALWAYS use `[UNVERIFIED]` on **PROGRESS** lines when evidence is insufficient.
- NEVER mark `[x]` or `✓` from conversation or user claim alone.
- NEVER skip git inspection when repository is available.

## Non-goals

- No new feature implementation during review
- No amending git history

---

# Data source priority

1. **Codebase** — file contents, new files, test results
2. **Git history** — commits, diff since day start
3. **WORKDAY block** — init/update output in chat or vault
4. **User notes** — supplementary only
5. **Conversation context** — lowest

### Evidence gathering (mandatory when repo present)

```bash
git status
git log --oneline -20
git diff --stat
git diff --stat HEAD@{1.day.ago}
```

Detail: [reference.md](./reference.md) § Evidence mapping.

---

# Required close-out output

Emit the **full WORKDAY** block — see [`template.workday.md`](../../templates/template.workday.md).

| Section | review fills |
|---------|--------------|
| DATE / MISSION | preserve from plan |
| ACTIVE TASKS | `[x]` done · `[~]` partial · `[ ]` not started / carry-over |
| PROGRESS | `✓ {ID} title` — one line per verified completion |
| PROBLEMS | final blockers; append uncommitted-work risk if dirty tree |
| DISCOVERED TODAY | preserve + `+` unplanned work with evidence |
| NEXT | carry-over and tomorrow priorities as `→` lines |
| EVIDENCE | **required** — commit SHAs, file paths, test paths, doc paths |
| DAY SCORE | evidence-based Focus / Progress / Risk |

Unplanned work: add to **DISCOVERED TODAY** as `+ UNPLANNED-{DOMAIN}-{NNN} …` with evidence.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/workday-review` |
|---------|-------------------|
| STATUS | READY = audit complete; BLOCKED = repo inaccessible and user declined manual evidence |
| OBJECTIVE | Evidence-based WORKDAY close-out |
| DISCOVERIES | Git summary, file changes, plan gaps |
| ANALYSIS | Verified vs claimed; abandonment signals |
| RISKS | Uncommitted work, `[UNVERIFIED]` items |
| ARTIFACTS | Full **WORKDAY** block |
| NEXT ACTIONS | **NEXT** arrows · `/workday-init` tomorrow · `/git-push` if ready |
| HANDOFF | `/workday-init` · `/git-push` · `/fix-record` · `none` |
| CONFIDENCE | 0–100; cap ~60 without git; cap ~85 without test evidence |

---

# Success criteria

- **WORKDAY** block matches template; all sections filled or `—`
- Git/code inspected when repo available
- Every `✓` and `[x]` has **EVIDENCE** backing or `[UNVERIFIED]` tag
- Unplanned work in **DISCOVERED TODAY**
- **NEXT** actionable for tomorrow's init
- Report reflects codebase state, not perception alone
