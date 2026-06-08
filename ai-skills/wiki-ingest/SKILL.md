---
name: wiki-ingest
metadata:
  version: "1.1.0"
description: >-
  Wiki curator — auto-ingest durable insights (no ask-first) or manual ingest of
  papers and closed knowledge into vault/wiki. LLM Wiki Pattern. /wiki-ingest.
disable-model-invocation: true
---

# Skill: wiki-ingest

Role: Wiki curator

Mission: Turn sources and closed insights into linked, mergeable Markdown pages in `vault/wiki/` — knowledge that survives chat history.

## Purpose

Curate a personal knowledge wiki: read input, update concept pages, maintain `index.md` and `log.md`, link related topics.

Protocol: [reference.md](./reference.md).

## Quick cheat sheet

| Step | Action |
|------|--------|
| **1 Search** | Grep `wiki/pages/` — existing slug? |
| **2 Source** | Optional `sources/{slug}.md` for URL/paper |
| **3 Page** | Create or **merge** `pages/{slug}.md` |
| **4 Index** | Update `index.md` |
| **5 Log** | Append `log.md` |
| **6 Report** | Paths + summary in chat |
| **7 Verify** | [reference.md](./reference.md) § Close-out verification gate |

## When to use

**Automatic (no ask):** end of work turns — [`vault-issues.mdc`](../../ai-rules/vault-issues.mdc) runs [reference.md](./reference.md) § **Auto-ingest gate**.

**Manual invoke:**

- `/wiki-ingest` or "save to wiki" / "เก็บลง wiki"
- After reading paper, article, long research summary
- After `/fix-record` — export reusable mechanism to wiki
- After `/workday-review` — insight worth keeping

## When NOT to use

- Daily Q&A → `issues/` (rule)
- Daily plan → `/workday-*`
- Bug still open → `/debug` first
- Trivial one-liner → `issues/` only

## Handoffs

| Situation | Skill |
|-----------|--------|
| Search before ingest | [`/vault-recall`](../vault-recall/SKILL.md) |
| RCA source material | [`/fix-record`](../fix-record/SKILL.md) |
| Plan-driven research | [`/workday-init`](../workday-init/SKILL.md) |

## Scope Guardrails

- ALWAYS merge into existing page when topic matches — never duplicate slugs.
- ALWAYS update `index.md` and append `log.md`.
- ALWAYS write files per [reference.md](./reference.md).
- NEVER ingest on chitchat or open bugs — only when [reference.md](./reference.md) § Auto-ingest gate passes.
- NEVER ask "save to wiki?" when the gate passes — write and report `Wiki → path`.

## Non-goals

- No app code implementation
- No replacing `/fix-record` for long RCA in chat

---

# Workflow

1. Resolve wiki root — [reference.md](./reference.md) § Resolve.
2. Optional: `/vault-recall` for related pages.
3. Derive slug + title from input.
4. Execute write protocol — [reference.md](./reference.md) § Write protocol.
5. Emit summary: what was created/updated, wikilinks added.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/wiki-ingest` |
|---------|----------------|
| STATUS | READY = files written; BLOCKED = no input |
| OBJECTIVE | Durable wiki page(s) from input |
| DISCOVERIES | Existing pages merged, new slugs |
| ANALYSIS | What was merged vs created |
| RISKS | Duplicate topic, stale merge, over-ingest |
| ARTIFACTS | Paths under `vault/wiki/` |
| NEXT ACTIONS | Open in Obsidian; `/vault-recall` next time |
| HANDOFF | `/vault-recall` · `/workday-update` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out verification gate before READY |

---

# Success criteria

- `pages/{slug}.md` created or merged
- `index.md` and `log.md` updated
- No duplicate page for same topic
- User can find topic via `/vault-recall` without chat history
