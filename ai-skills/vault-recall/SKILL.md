---
name: vault-recall
metadata:
  version: "1.2.1"
description: >-
  Grep vault learnings and recent issues; keyword strategy, recall verification gate,
  empty vault playbook. Invoke with /vault-recall or when user asks to search vault.
disable-model-invocation: true
---

# Skill: vault-recall

Role: Vault librarian

Mission: Find prior lessons and same-day context before repeating work.

> Search steps (resolve root, grep order, limits): [`reference.md`](./reference.md).

## Purpose

Search **local** vault and return a short, actionable summary. Does **not** write vault files — use `ai-rules/vault-issues.mdc` for writes.

## Quick cheat sheet

| Step | Limit |
|------|-------|
| Resolve vault root | `reference.md` § Resolve vault root |
| Grep learnings | ≤3 files full read |
| Then issues | today + yesterday only |
| Empty | suggest learning after close |

## Handoffs (other skills in this pack)

| After recall | Skill |
|--------------|--------|
| Bug with prior art | [`/debug`](../debug/SKILL.md) — fold hits into ledger |
| Git push blocked | [`/git-push`](../git-push/SKILL.md) Phase 0 |
| Write RCA after fix | [`/fix-record`](../fix-record/SKILL.md) |
| Upgrade skill from vault gap | [`/upgrade-ai`](../upgrade-ai/SKILL.md) |

## Scope Guardrails

- ALWAYS follow [`reference.md`](./reference.md) for root resolution and grep limits.
- NEVER read more than **3** learning files full-text per search.
- NEVER echo secrets from vault notes.

## Non-goals

- No commits, no skill edits, no RCA (`/fix-record`)
- No automatic write to issues/learnings

---

# Activate when

| Use | Do not use |
|-----|------------|
| `/vault-recall` or “search vault” / ค้น vault | Logging work (rule writes issues) |
| Repeat symptoms before long debug | Every casual message |
| User asks “any prior lesson?” | After you already grepped this turn |

Other skills call the same search via `reference.md` — you do not need `/vault-recall` if `/debug` or `/git-push` already ran recall.

---

# Workflow

1. Load and run [`reference.md`](./reference.md) (resolve root → search learnings → issues if needed).
2. Report using **SKILL REPORT** below.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/vault-recall` |
|---------|-----------------|
| STATUS | READY = search complete; BLOCKED = vault root unknown |
| OBJECTIVE | Find prior art in vault for current symptom or friction |
| DISCOVERIES | Matched paths, titles, symptoms, fix snippets (≤3 files) |
| ANALYSIS | Best match takeaway; empty-vault note if none |
| RISKS | Token overrun, fabricated prior fixes, wrong vault root |
| ARTIFACTS | Query, vault root, learnings/issues counts, top match list |
| NEXT ACTIONS | Open file, run `/debug`, or create learning after close |
| HANDOFF | `/debug` · `/git-push` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Recall verification gate before READY |

---

# Success criteria

- Correct vault root
- Token-bounded search per `reference.md`
- Actionable summary without duplicating entire notes
- Pass [reference.md](./reference.md) § Recall verification gate before closing
