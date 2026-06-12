# vault-daily reference

## Note templates (SSoT)

All templates: `templates/vault/notes/` — detail in [templates/vault/README.md](../../templates/vault/README.md).

| Tier | Template | Output |
|------|----------|--------|
| Daily | `template.vault-daily.md` | `daily/DATE.md` |
| Session | `template.vault-session.md` | `sessions/SLUG.md` |
| Decision | `template.vault-decision.md` | `decisions/SLUG.md` |
| Project | `template.vault-project.md` | `projects/SLUG.md` |

## Daily file

Path: `vault/daily/YYYY-MM-DD.md`

**Template:** `templates/vault/notes/template.vault-daily.md` — replace `__VAULT_DATE__`, `__VAULT_ISO__` (literal); optional `project` in frontmatter. Prefer `append-daily` script (auto-creates file).

## Triage values

| triage | Action |
|--------|--------|
| keep_decision | `template.vault-decision.md` → `decisions/<slug>.md` + manifest |
| keep_learning | `template.vault-session.md` → `sessions/<slug>.md` + manifest |
| keep_project | `template.vault-project.md` → `projects/<slug>.md` + manifest |
| daily_only | Stay in daily only |
| carry_over | Add to frontmatter `carry_over` |

Dedupe before promote: `Read` `vault/_agent/manifest.json` + match slug in `path`.

## Promoted wikilinks

In daily `## Promoted`, use Obsidian wikilinks: `[[decisions/slug]]`, `[[sessions/slug]]`, `[[projects/slug]]`.

## Decision file (promoted)

**Template:** `template.vault-decision.md` — `SLUG`, `TITLE`, `PROJECT`, `CREATED`, `UPDATED`. Default `status: draft` unless user says active.

## Session file (promoted)

**Template:** `template.vault-session.md` — same placeholders.

## Project file (promoted)

**Template:** `template.vault-project.md` — same placeholders. Manifest: `tier: semantic`, `id: proj-<slug>`.

## Merge same day

- Append new tasks/issues; dedupe rows by `id`
- `runs: <previous + 1>`
- `updated_at: now`

## สรุปส่งรายงาน (output block)

Plain Thai bullets — completed, in-progress, carry-over, promoted links.
