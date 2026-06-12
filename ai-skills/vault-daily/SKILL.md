---
name: vault-daily
metadata:
  version: "1.0.0"
description: >-
  Daily task summary and triage for local vault — one file per calendar day,
  preview before promote, index semantic/episodic tiers only. Invoke with
  /vault-daily at end of day or when reporting tasks.
disable-model-invocation: true
---

# Vault daily

End-of-day workflow: merge into **one** `vault/notes/daily/YYYY-MM-DD.md`, triage issues, promote durable notes after user confirm, index, deliver copy-paste report.

## Iron law

**Do not promote** to `vault/notes/decisions/`, `vault/notes/sessions/`, or `vault/notes/projects/` until user confirms triage preview (`ok`, `yes`, `go`).

## Scope Guardrails

- ALWAYS use exactly one daily file per calendar day: `vault/notes/daily/YYYY-MM-DD.md`
- ALWAYS merge on re-run same day (increment `runs`, update `updated_at`) — never create a second daily file
- NEVER embed daily content in index (excluded by design)
- NEVER store secrets, API keys, or credentials in vault notes

## CLI (run from agent-skills repo root)

```bash
python scripts/vault/search.py --dedupe "<topic>" --json
python scripts/vault/index.py
python scripts/vault/daily.py --date YYYY-MM-DD
```

## Workflow

1. Resolve today's date → `vault/notes/daily/YYYY-MM-DD.md`
2. If file exists → load and **merge**; else create from template in [reference.md](./reference.md)
3. Gather tasks/issues from chat today (+ optional `git log --since=midnight`)
4. Update sections: สรุปงานวันนี้, Issues วันนี้, carry_over in frontmatter
5. For each `keep_*` triage → `python scripts/vault/search.py --dedupe "<title>" --json`
6. Present **Triage preview** table (issue, triage, target path, reason) — **STOP for confirm**
7. After confirm → promote:
   - `keep_decision` → `vault/notes/decisions/<topic-slug>.md` (one topic one file; update if exists)
   - `keep_learning` → `vault/notes/sessions/<topic-slug>.md`
   - `keep_project` → `vault/notes/projects/<name>.md`
   - New promoted decisions default `status: draft` unless user says active
8. Link from daily `## Promoted` with wikilinks — do not duplicate full decision body
9. Run `python scripts/vault/index.py` (indexes non-daily tiers only)
10. Output **สรุปส่งรายงาน** block (Thai bullets, copy-paste ready)

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/vault-daily` |
|---------|----------------|
| STATUS | BLOCKED = awaiting triage confirm; READY = daily saved + index run |
| OBJECTIVE | One daily file + optional promotes + task report |
| ARTIFACTS | `vault/notes/daily/YYYY-MM-DD.md`, promoted paths, index updated |
| NEXT ACTIONS | User edits preview · missing confirm |

Pack integration (end-of-day from debug / builder-feature): [vault-capture/reference.md](../vault-capture/reference.md) § Integration with pack skills

Detail: [reference.md](./reference.md)
