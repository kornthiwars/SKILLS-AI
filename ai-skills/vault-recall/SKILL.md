---
name: vault-recall
metadata:
  version: "1.3.6"
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
| Feature / plan keyword | grep `workday/plans/` · ≤2 plan files |
| Then issues | today + yesterday |
| Empty | durable insight → wiki auto-ingest gate on close |

## Handoffs

| After recall | Skill |
|--------------|--------|
| Bug with prior art | [`/debug`](../debug/SKILL.md) |
| Git push blocked | [`/git-push`](../git-push/SKILL.md) Phase 0 |
| Durable knowledge written | [`vault-issues.mdc`](../../ai-rules/vault-issues.mdc) wiki gate · [`/wiki-ingest`](../wiki-ingest/SKILL.md) manual |
| Write RCA after fix | [`/fix-record`](../fix-record/SKILL.md) |
| Prior feature plan | [`/builder-feature`](../builder-feature/SKILL.md) after recall |

## Scope Guardrails

- ALWAYS follow [`reference.md`](./reference.md).
- NEVER read more than **3** wiki page files or **2** plan files full-text per search.
- NEVER echo secrets from vault notes.

## Non-goals

- No writes in this skill — issues + wiki auto-ingest via [`vault-issues.mdc`](../../ai-rules/vault-issues.mdc); manual `/wiki-ingest` optional

---

# Workflow

1. Run [`reference.md`](./reference.md) (wiki → `workday/plans/` when feature keyword → issues).
2. Report using **SKILL REPORT** below.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/vault-recall` |
|---------|-----------------|
| STATUS | READY / BLOCKED |
| OBJECTIVE | Find prior art |
| DISCOVERIES | Matched wiki pages (≤3), plans (≤2), issues |
| ARTIFACTS | Query, paths, counts |
| NEXT ACTIONS | Open page, `/debug`, `/wiki-ingest`, or none |
| HANDOFF | `/debug` · `/wiki-ingest` · `none` |
| CONFIDENCE | 0–100; pass verification gate before READY |

---

# Success criteria

- Search order wiki → plans (feature keyword) → issues
- ≤3 wiki pages · ≤2 plan files from `workday/plans/`
- Empty vault explicitly stated
