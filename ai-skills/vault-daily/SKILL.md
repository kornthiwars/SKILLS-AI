---
name: vault-daily
metadata:
  version: "2.3.0"
description: >-
  Use for end-of-day triage, Issues review, promote to durable tiers, and สรุปส่งรายงาน.
  Routine bullets autolog after patches (vault-autolog rule). Invoke /vault-daily when
  triage or promote is needed — not required after every small task.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Vault daily

**Optional** end-of-day workflow — not required after every task. Routine work is appended automatically per [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc). Use `/vault-daily` for **triage**, **Issues** review, **promote**, and **สรุปส่งรายงาน**.

## Quick cheat sheet

| When | Action | Promote? |
|------|--------|----------|
| End of day / สรุปส่งรายงาน | Triage preview → confirm → daily update | Only after `ok` / `yes` |
| Issues review | Merge into `## Issues วันนี้` | — |
| `keep_decision` / `keep_learning` | Promote to `decisions/` or `sessions/` | After confirm |

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Durable note without full triage | [`/vault-capture`](../vault-capture/SKILL.md) |
| Search past decisions before triage | [`/vault-recall`](../vault-recall/SKILL.md) |
| Routine patch logging | [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) — automatic |
| RCA from today's fixes | [`/fix-record`](../fix-record/SKILL.md) |

## Iron law

**Do not promote** to `vault/decisions/`, `sessions/`, or `projects/` until user confirms triage preview (`ok`, `yes`, `go`).

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails. Skill-specific:

- ALWAYS one daily file per calendar day — merge on re-run (increment `runs`, `updated_at`)
- NEVER store secrets in vault notes
- ALWAYS upsert manifest after each promote
- ALWAYS **infer `project`** and run **project hub ensure** after promoting `keep_decision` or `keep_learning` — same rules as [`/vault-capture`](../vault-capture/SKILL.md) step 8 ([reference](../vault-capture/reference.md) § Infer project · § Project hub auto-ensure)

## Workflow

0. If today's daily **missing** → create from `template.vault-daily.md` per [vault-capture/reference.md](../vault-capture/reference.md) § Daily file
1. Resolve today → daily path per [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) § Path resolution
2. Load and **merge** if exists; else create from [reference.md](./reference.md)
3. Gather tasks/issues from chat (+ optional `git log --since=midnight`)
4. Update sections: สรุปงานวันนี้, Issues วันนี้, `carry_over` in frontmatter
5. `Read` `vault/_agent/manifest.json` — for each `keep_*` triage, dedupe by `id`/slug/title
6. Present **Triage preview** — **STOP for confirm**
7. After confirm → promote (from `templates/vault/notes/template.vault-*.md`):
   - `keep_decision` → `template.vault-decision.md` → `vault/decisions/<topic-slug>.md`
   - `keep_learning` → `template.vault-session.md` → `vault/sessions/<topic-slug>.md`
   - `keep_project` → `template.vault-project.md` → `vault/projects/<name>.md`
   - For `keep_decision` / `keep_learning`: **infer `project`** per [vault-capture/reference.md](../vault-capture/reference.md) § Infer project — set in frontmatter before write
   - New decisions default `status: draft` unless user says active
8. Upsert manifest for each promoted/updated durable file (`tags` required)
9. For each promoted **session or decision**: **project hub ensure** per [vault-capture/reference.md](../vault-capture/reference.md) § Project hub auto-ensure (hub create/update, primary backlink, `proj-*` manifest upsert)
10. Link from daily `## Promoted` using wikilinks — e.g. `[[decisions/slug]]`, `[[projects/<project>]]` — dedupe lines hub ensure already added; no duplicate full decision body
11. Output **สรุปส่งรายงาน** block (Thai bullets, copy-paste ready) — include inferred project + hub path when step 9 ran

## Obsidian (human)

Obsidian users may open today's daily via **Daily notes** hotkey (`daily/YYYY-MM-DD.md`). Agent path resolution unchanged — see [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc).

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/vault-daily` |
|---------|----------------|
| STATUS | BLOCKED = awaiting triage confirm; READY = daily saved + manifest updated |
| OBJECTIVE | One daily file + optional promotes + **สรุปส่งรายงาน** |
| DISCOVERIES | Daily sections loaded, Issues rows, optional `git log --since=midnight` |
| ANALYSIS | Triage preview summary, promote candidates, dedupe status |
| RISKS | Promote without user confirm, secrets in notes, manifest drift |
| ARTIFACTS | daily path, promoted paths, hub path (`created` \| `updated`) when applicable, manifest entries, triage preview summary |
| NEXT ACTIONS | Await user `ok`/`yes`/`go` · run promote step · `none` |
| HANDOFF | `/vault-capture` · `/vault-recall` · `/fix-record` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out verification gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE. Close-out: all sections + **สรุปส่งรายงาน**.

Pack integration: [vault-capture/reference.md](../vault-capture/reference.md) § Integration with pack skills

Detail: [reference.md](./reference.md)
