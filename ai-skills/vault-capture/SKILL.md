---
name: vault-capture
metadata:
  version: "2.3.0"
description: >-
  Capture session or ADR into local vault — infer project hub, manifest dedupe,
  agent Write only. No Python. Invoke with /vault-capture.
disable-model-invocation: true
---

# Vault capture

Save meaningful context to `vault/{daily,sessions,decisions,projects}/` and update `vault/_agent/manifest.json`.

## Scope Guardrails

- ALWAYS dedupe via manifest `id` + slug in `path` before creating a new file
- ALWAYS one topic per file (`<topic-slug>.md`, not date-prefixed for sessions/decisions)
- ALWAYS upsert manifest after every write — include `tags: []` (or populated array) on every doc entry (schema v2)
- NEVER store secrets or credentials
- Link from today's daily if relevant — do not duplicate full content in daily
- ALWAYS run **Project hub ensure** after writing `sessions/` or `decisions/` (see step 8)
- ALWAYS **infer `project`** yourself for sessions/decisions — user does not need to name the slug each time

## Workflow

0. **Optional daily link** — if `vault/daily/<today>.md` exists, wikilink in step 8e; do not auto-create daily
1. Infer topic slug and tier (`sessions` episodic, `decisions` semantic ADR, `projects` semantic)
2. **Infer project** (mandatory for `sessions/` and `decisions/`; skip when tier is `projects/`):
   - Collect signals: patched paths, git root / cwd, conversation topic, manifest `proj-*` entries, dedupe frontmatter `project`
   - Pick best kebab-case slug (`api`, `web`, `app`, …); ask user **only** if confidence low or tie between candidates
   - Set `project` in primary frontmatter before write
3. `Read` `vault/_agent/manifest.json`
4. Dedupe:
   - Match existing `id` (`sess-*`, `dec-*`, `proj-*`) or slug in `path`
   - `Grep` `title` in target tier if unsure
   - If match → update existing file at `path`; else create new
5. Write frontmatter: `id`, `title`, `tags`, `project`, `related`, `status` (+ `intent` when from fix-record/builder)
6. Sections — by tier (`templates/vault/notes/template.vault-*.md`):
   - `sessions`: `template.vault-session.md`
   - `decisions`: `template.vault-decision.md`
   - `projects`: `template.vault-project.md`
7. Upsert manifest entry for primary: `{id, path, title, tier, project, status, updated, tags}` — **`tags` required**; set `updated_at` on manifest
8. **Project hub ensure** (mandatory when tier is `sessions/` or `decisions/`):
   - `hubPath` = `projects/<project>.md` (slug equals inferred `project`)
   - If hub **missing** → `Read` `template.vault-project.md` → replace placeholders → `Write` hub (Overview: one line from capture context)
   - If hub **exists** → `Read` hub → **append** in `## Links` only: `- [[sessions/slug]]` or `- [[decisions/slug]]` if that line absent
   - **Backlink** primary: append `Hub: [[projects/<project>]]` at end of **Context** if absent
   - If `vault/daily/<today>.md` **exists** → append in `## Promoted`: `[[projects/<project>]]` and primary wikilink if absent
   - Upsert manifest `proj-<project>` (`tier: semantic`, `tags: []` or `[project]`)
9. Report: **Inferred project** + one-line reason, primary path, hub path (`created` | `updated`), manifest ids touched

**Do not** run `append-daily` bullet in capture — autolog / `/vault-daily` owns daily bullets.

## Manifest upsert

Path in manifest is relative to `vault/`, e.g. `sessions/auth-fix.md`.

## SKILL REPORT

| Section | `/vault-capture` |
|---------|------------------|
| STATUS | READY when primary + hub (if applicable) written + manifest updated |
| ARTIFACTS | `Inferred project: <slug> (<reason>)`, note path(s), manifest entries |

Detail: [reference.md](./reference.md)
