# vault-daily reference

## Note templates (SSoT)

All templates: `scripts/vault/` — detail in [TEMPLATES.md](../../scripts/vault/TEMPLATES.md).

| Tier | Template | Output |
|------|----------|--------|
| Daily | `daily.template.md` | `notes/daily/DATE.md` |
| Session | `session.template.md` | `notes/sessions/SLUG.md` |
| Decision | `decision.template.md` | `notes/decisions/SLUG.md` |
| Project | `project.template.md` | `notes/projects/SLUG.md` |

## Daily file

Path: `vault/notes/daily/YYYY-MM-DD.md`

**Template:** `scripts/vault/daily.template.md` — replace `DATE`, `ISO`; optional `project` in frontmatter.

## Triage values

| triage | Action |
|--------|--------|
| keep_decision | `decision.template.md` → `notes/decisions/<slug>.md` + manifest |
| keep_learning | `session.template.md` → `notes/sessions/<slug>.md` + manifest |
| keep_project | `project.template.md` → `notes/projects/<slug>.md` + manifest |
| daily_only | Stay in daily only |
| carry_over | Add to frontmatter `carry_over` |

Dedupe before promote: `Read` manifest + match slug in `path`.

## Decision file (promoted)

**Template:** `decision.template.md` — `SLUG`, `TITLE`, `PROJECT`, `CREATED`, `UPDATED`. Default `status: draft` unless user says active.

## Session file (promoted)

**Template:** `session.template.md` — same placeholders.

## Project file (promoted)

**Template:** `project.template.md` — same placeholders. Manifest: `tier: semantic`, `id: proj-<slug>`.

## Merge same day

- Append new tasks/issues; dedupe rows by `id`
- `runs: <previous + 1>`
- `updated_at: now`

## สรุปส่งรายงาน (output block)

Plain Thai bullets — completed, in-progress, carry-over, promoted links.
