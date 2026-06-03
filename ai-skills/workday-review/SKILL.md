---
name: workday-review
metadata:
  version: "1.0.0"
description: >-
  End-of-day auditor — evidence-based report from codebase and git vs morning plan.
  Invoke with /workday-review. Requires git/code inspection; never marks complete
  from conversation alone.
disable-model-invocation: true
---

# Skill: workday-review

Role: Daily Work Auditor

Mission: Produce an evidence-based end-of-day report using code, git activity, and the planned work.

## Purpose

Determine what was actually accomplished and what remains unfinished — grounded in repository evidence, not conversation alone.

## Quick cheat sheet

| Step | Source (priority) | Action |
|------|-------------------|--------|
| **1 Evidence** | Codebase | `git status`, `git log`, `git diff`; scan changed paths |
| **2 Plan** | Daily plan | Match tasks to evidence (init/update output or vault issue) |
| **3 Classify** | Compare | Completed · in progress · blocked · unplanned |
| **4 Report** | Synthesize | Seven required sections below |

**Evidence rule:** task completion requires at least one of: new/modified files, tests, commits, docs updates — with path or hash cited.

## When to use

- `/workday-review` or "end of day review" / "สรุปวันนี้"
- Close of day when you need honest progress vs plan
- Before planning tomorrow — input for [`/workday-init`](../workday-init/SKILL.md)

## When NOT to use

- Morning planning → [`/workday-init`](../workday-init/SKILL.md)
- Mid-day scope change → [`/workday-update`](../workday-update/SKILL.md)
- RCA for a specific bug → [`/fix-record`](../fix-record/SKILL.md)

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Plan tomorrow | [`/workday-init`](../workday-init/SKILL.md) with Carry Over section |
| Unplanned bug found | [`/debug`](../debug/SKILL.md) |
| Ship today's work | [`/git-push`](../git-push/SKILL.md) |
| Document reusable lesson | vault learning per `vault-issues.mdc` |

## Scope Guardrails

- ALWAYS gather git/code evidence before classifying completion.
- ALWAYS cite evidence (file paths, commit SHAs, diff summary) per completed task.
- ALWAYS report uncertainty when evidence is insufficient — use `[UNVERIFIED]` not "done."
- NEVER mark a task complete based solely on conversation or user claim.
- NEVER skip git inspection when repository is available.
- NEVER perform speculative rewrites — audit only.

## Non-goals

- No new feature implementation during review
- No amending git history
- No replacing `/fix-record` for detailed RCA

---

# Data source priority

When evidence conflicts, trust in this order:

1. **Codebase** — file contents, new files, test results
2. **Git history** — commits, branches, diff since day start (or since plan timestamp)
3. **Daily plan** — `/workday-init` or `/workday-update` output in chat or vault
4. **User notes** — supplementary; cannot override missing git/code evidence for "complete"
5. **Conversation context** — lowest; use for intent and blockers only

### Evidence gathering (mandatory when repo present)

Run before writing the report:

```bash
git status
git log --oneline -20
git diff --stat
git diff --stat HEAD@{1.day.ago}   # or since morning commit if known
```

Scan changed paths against planned task IDs. Note untracked files and unstaged work.

Detail: [reference.md](./reference.md) § Evidence mapping.

---

# Required output sections

Deliver **all seven** in every close-out response:

1. **Completed** — task ID, title, evidence (paths/commits), confidence.
2. **In Progress** — task ID, what exists, what remains, partial evidence.
3. **Blocked** — task ID, blocker, since when, unblocking action.
4. **Unplanned Work** — work done without plan ID; evidence; suggest tag for tomorrow.
5. **Carry Over** — not started or incomplete; priority for next day.
6. **Tomorrow Recommendations** — ordered suggestions derived from carry-over + blockers.
7. **Overall Progress** — % vs plan (qualitative if no numeric baseline), headline summary.

Use `[UNVERIFIED]` when completion cannot be confirmed from git/code.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/workday-review` |
|---------|-------------------|
| STATUS | READY = audit complete; BLOCKED = repo inaccessible and user declined manual evidence |
| OBJECTIVE | Evidence-based end-of-day report vs plan |
| DISCOVERIES | Git summary, file changes, plan gaps |
| ANALYSIS | Completed vs claimed; unplanned work; abandonment signals |
| RISKS | Uncommitted work, false completion claims, missing tests |
| ARTIFACTS | Seven required sections |
| NEXT ACTIONS | `/workday-init` inputs; `/git-push` if ready; open blockers |
| HANDOFF | `/workday-init` · `/git-push` · `/fix-record` · `none` |
| CONFIDENCE | 0–100; cap ~60 without git access; cap ~85 without test evidence |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES (git stats), NEXT ACTIONS, CONFIDENCE.

---

# Success criteria

- Git/code inspected when repository available
- Every "completed" item has cited evidence
- Uncertain items marked `[UNVERIFIED]`, not marked done
- Unplanned and abandoned work explicitly called out
- Carry-over list actionable for tomorrow's `/workday-init`
- Report reflects codebase state, not user perception alone
