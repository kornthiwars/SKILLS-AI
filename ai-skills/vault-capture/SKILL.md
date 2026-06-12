---
name: vault-capture
metadata:
  version: "2.1.0"
description: >-
  Capture session or ADR into local vault — manifest dedupe, agent Write only.
  No Python. Invoke with /vault-capture.
disable-model-invocation: true
---

# Vault capture

Save meaningful context to `vault/notes/` and update `vault/_meta/manifest.json`.

## Scope Guardrails

- ALWAYS dedupe via manifest `id` + slug in `path` before creating a new file
- ALWAYS one topic per file (`<topic-slug>.md`, not date-prefixed for sessions/decisions)
- ALWAYS upsert manifest after every write
- NEVER store secrets or credentials
- Link from today's daily if relevant — do not duplicate full content in daily

## Workflow

0. **Optional daily link** — if `vault/notes/daily/<today>.md` exists, may wikilink in step 6; do not auto-create
1. Infer topic slug and tier (`sessions` episodic, `decisions` semantic ADR, `projects` semantic)
2. `Read` `vault/_meta/manifest.json`
3. Dedupe:
   - Match existing `id` (`sess-*`, `dec-*`, `proj-*`) or slug in `path`
   - `Grep` `title` in target tier if unsure
   - If match → update existing file at `path`; else create new
4. Write frontmatter: `id`, `title`, `tags`, `project`, `related`, `status` (+ `intent` when from fix-record/builder)
5. Sections — by tier (`scripts/vault/*.template.md`):
   - `sessions`: `session.template.md`
   - `decisions`: `decision.template.md`
   - `projects`: `project.template.md`
6. Optional: wikilink in `vault/notes/daily/<today>.md`
7. Upsert manifest entry: `{id, path, title, tier, project, status, updated}` — set `updated_at` on manifest
8. Report saved path

## Manifest upsert

Path in manifest is relative to `vault/`, e.g. `notes/sessions/auth-fix.md`.

## SKILL REPORT

| Section | `/vault-capture` |
|---------|------------------|
| STATUS | READY when file written + manifest updated |
| ARTIFACTS | note path, manifest entry |

Detail: [reference.md](./reference.md)
