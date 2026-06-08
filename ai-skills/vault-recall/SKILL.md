---
name: vault-recall
metadata:
  version: "1.3.3"
description: >-
  Grep vault wiki pages, feature plans (workday/plans), and recent issues;
  keyword strategy, recall verification gate. Invoke with /vault-recall.
disable-model-invocation: true
---

# Skill: vault-recall

Role: Vault librarian

Mission: Find prior knowledge and same-day context before repeating work.

> Search steps: [`reference.md`](./reference.md).

## Purpose

Search **local** vault and return a short, actionable summary. Does **not** write vault files.

## Quick cheat sheet

| Step | Limit |
|------|-------|
| Resolve vault root | `reference.md` § Resolve |
| Grep `wiki/pages/` | ≤3 files full read |
| Then issues | today + yesterday |
| Empty | suggest `/wiki-ingest` after close |

## Handoffs

| After recall | Skill |
|--------------|--------|
| Bug with prior art | [`/debug`](../debug/SKILL.md) |
| Git push blocked | [`/git-push`](../git-push/SKILL.md) Phase 0 |
| Save durable knowledge | [`/wiki-ingest`](../wiki-ingest/SKILL.md) |
| Write RCA after fix | [`/fix-record`](../fix-record/SKILL.md) |

## Scope Guardrails

- ALWAYS follow [`reference.md`](./reference.md).
- NEVER read more than **3** wiki page files full-text per search.
- NEVER echo secrets from vault notes.

## Non-goals

- No automatic writes — issues via rule; wiki via `/wiki-ingest`

---

# Workflow

1. Run [`reference.md`](./reference.md) (wiki pages → issues).
2. Report using **SKILL REPORT** below.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/vault-recall` |
|---------|-----------------|
| STATUS | READY / BLOCKED |
| OBJECTIVE | Find prior art |
| DISCOVERIES | Matched wiki pages, issues (≤3) |
| ARTIFACTS | Query, paths, counts |
| NEXT ACTIONS | Open page, `/debug`, `/wiki-ingest`, or none |
| HANDOFF | `/debug` · `/wiki-ingest` · `none` |
| CONFIDENCE | 0–100; pass verification gate before READY |

---

# Success criteria

- Search order wiki → issues
- ≤3 wiki pages read
- Empty vault explicitly stated
