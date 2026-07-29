---
name: vault-capture
metadata:
  version: "2.4.0"
description: >-
  Use after meaningful work to save session notes or ADRs to local vault — infer project
  hub, manifest dedupe, wikilinks, agent Write only. Use whenever durable context should
  survive the chat. No Python. Invoke with /vault-capture.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Vault capture

Save meaningful context to `vault/{daily,sessions,decisions,projects}/` and update `vault/_agent/manifest.json`.

## Quick cheat sheet

| When | Action | Daily bullets? |
|------|--------|----------------|
| After verified fix / substantive session | Session or decision note + project hub | **No** — autolog owns daily |
| After `/fix-record` or builder plan complete | ADR or session with `intent` | **No** |
| User asks durable memory only | Infer project → write → manifest upsert | **No** |

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Recall before breaking change | [`/vault-recall`](../vault-recall/SKILL.md) |
| Full RCA after production fix | [`/fix-record`](../fix-record/SKILL.md) then capture |
| End-of-day triage / promote | [`/vault-daily`](../vault-daily/SKILL.md) |
| Routine patch bullet | [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) — not this skill |
| Bug during capture session | [`/debug`](../debug/SKILL.md) |

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails. Skill-specific:

- ALWAYS dedupe via manifest `id` + slug in `path` before creating a new file
- ALWAYS one topic per file (`<topic-slug>.md`, not date-prefixed for sessions/decisions)
- ALWAYS upsert manifest after every write — include `tags: []` (or populated array) on every doc entry (schema v2)
- NEVER store secrets or credentials
- Link from today's daily if relevant — do not duplicate full content in daily
- ALWAYS run **Project hub ensure** after writing `sessions/` or `decisions/` (see step 8)
- ALWAYS **infer `project`** yourself for sessions/decisions — user does not need to name the slug each time

## Workflow

0. **Optional daily link** — if `vault/projects/<project>/daily/<today>.md` exists, wikilink in step 8e; do not auto-create daily
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
   - `sessions` → `vault/projects/<project>/sessions/<slug>.md` from `template.vault-session.md`
   - `decisions` → `vault/projects/<project>/decisions/<slug>.md`
   - `projects` → `vault/projects/<project>/hub.md`
7. Upsert manifest entry for primary: `{id, path, title, tier, project, status, updated, tags}` — **`tags` required**; set `updated_at` on manifest
8. **Project hub ensure** (mandatory when tier is `sessions/` or `decisions/`):
   - `hubPath` = `projects/<project>/hub.md` (slug equals inferred `project`)
   - If hub **missing** → `Read` `template.vault-project.md` → replace placeholders → `Write` hub (Overview: one line from capture context)
   - If hub **exists** → `Read` hub → **append** in `## Links` only: `- [[projects/<project>/sessions/slug]]` or `- [[projects/<project>/decisions/slug]]` if that line absent
   - **Backlink** primary: append `Hub: [[projects/<project>/hub]]` at end of **Context** if absent
   - If `vault/projects/<project>/daily/<today>.md` **exists** → append in `## Promoted`: `[[projects/<project>/hub]]` and primary wikilink if absent
   - Upsert manifest `proj-<project>` (`path: projects/<project>/hub.md`, `tier: semantic`, `tags: []` or `[project]`)
9. Report: **Inferred project** + one-line reason, primary path, hub path (`created` | `updated`), manifest ids touched

**Do not** run `append-daily` bullet in capture — autolog / `/vault-daily` owns daily bullets.

## Manifest upsert

Path in manifest is relative to `vault/`, e.g. `projects/platform/sessions/auth-fix.md`.

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/vault-capture` |
|---------|------------------|
| STATUS | READY when primary + hub (if applicable) written + manifest updated; BLOCKED when project inference tie / missing manifest |
| OBJECTIVE | Persist session/ADR/project note with dedupe, hub link, manifest upsert |
| DISCOVERIES | Manifest state, dedupe hits, project inference signals, template tier chosen |
| ANALYSIS | Merge vs create, hub action (`created` \| `updated`), tags/manifest consistency |
| RISKS | Secrets in notes, duplicate slug, manifest drift, wrong inferred project |
| ARTIFACTS | `Inferred project: <slug> (<reason>)`, note path(s), hub path, manifest ids |
| NEXT ACTIONS | `/vault-recall` before breaking change · `/vault-daily` triage · `none` |
| HANDOFF | `/vault-recall` · `/vault-daily` · `/fix-record` · `/debug` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out verification gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE. Close-out: all sections.

Detail: [reference.md](./reference.md)
