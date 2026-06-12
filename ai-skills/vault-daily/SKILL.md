---
name: vault-daily
metadata:
  version: "2.1.0"
description: >-
  End-of-day triage and promote — Issues table, carry-over, report. Routine
  bullets autolog after patches (vault-autolog rule). No Python. /vault-daily optional.
disable-model-invocation: true
---

# Vault daily

**Optional** end-of-day workflow — not required after every task. Routine work is appended automatically per [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc). Use `/vault-daily` for **triage**, **Issues** review, **promote**, and **สรุปส่งรายงาน**.

## Iron law

**Do not promote** to `vault/notes/decisions/`, `sessions/`, or `projects/` until user confirms triage preview (`ok`, `yes`, `go`).

## Scope Guardrails

- ALWAYS one daily file per calendar day — merge on re-run (increment `runs`, `updated_at`)
- NEVER store secrets in vault notes
- ALWAYS upsert manifest after each promote

## Workflow

0. If today's daily **missing** → create from `daily.template.md` per [vault-capture/reference.md](../vault-capture/reference.md) § Daily file
1. Resolve today → daily path per [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) § Path resolution
2. Load and **merge** if exists; else create from [reference.md](./reference.md)
3. Gather tasks/issues from chat (+ optional `git log --since=midnight`)
4. Update sections: สรุปงานวันนี้, Issues วันนี้, `carry_over` in frontmatter
5. `Read` `vault/_meta/manifest.json` — for each `keep_*` triage, dedupe by `id`/slug/title
6. Present **Triage preview** — **STOP for confirm**
7. After confirm → promote (from `scripts/vault/*.template.md`):
   - `keep_decision` → `decision.template.md` → `vault/notes/decisions/<topic-slug>.md`
   - `keep_learning` → `session.template.md` → `vault/notes/sessions/<topic-slug>.md`
   - `keep_project` → `project.template.md` → `vault/notes/projects/<name>.md`
   - New decisions default `status: draft` unless user says active
8. Upsert manifest for each promoted/updated durable file
9. Link from daily `## Promoted` — no duplicate full decision body
10. Output **สรุปส่งรายงาน** block (Thai bullets, copy-paste ready)

## SKILL REPORT

| Section | `/vault-daily` |
|---------|----------------|
| STATUS | BLOCKED = awaiting triage confirm; READY = daily saved + manifest updated |
| OBJECTIVE | One daily file + optional promotes + task report |
| ARTIFACTS | daily path, promoted paths, manifest entries |

Pack integration: [vault-capture/reference.md](../vault-capture/reference.md) § Integration with pack skills

Detail: [reference.md](./reference.md)
