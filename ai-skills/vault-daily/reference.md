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
| keep_decision | `template.vault-decision.md` → `decisions/<slug>.md` + manifest + **hub ensure** |
| keep_learning | `template.vault-session.md` → `sessions/<slug>.md` + manifest + **hub ensure** |
| keep_project | `template.vault-project.md` → `projects/<slug>.md` + manifest |
| daily_only | Stay in daily only |
| carry_over | Add to frontmatter `carry_over` |

Dedupe before promote: `Read` `vault/_agent/manifest.json` + match slug in `path`.

## Infer project + hub ensure (sessions/decisions promote)

After promote + manifest upsert for `keep_decision` or `keep_learning`:

1. **Infer `project`** — [vault-capture/reference.md](../vault-capture/reference.md) § Infer project (signals from daily Issues, patched paths, manifest `proj-*`; ask once on tie)
2. **Hub ensure** — same algorithm as [vault-capture/reference.md](../vault-capture/reference.md) § Project hub auto-ensure

Skip hub ensure for `keep_project` (note is the hub) and `daily_only`.

Report in **สรุปส่งรายงาน**: `Inferred project: <slug> (<reason>)`, hub `created` | `updated`.

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

---

## Close-out verification gate

Before STATUS=READY:

| Step | Action |
|------|--------|
| 1 IDENTIFY | Daily path, promote candidates, manifest entries |
| 2 RUN | Triage preview confirmed (`ok`/`yes`/`go`); promotes use SSoT templates; manifest upserted; hub ensure for session/decision promotes |
| 3 READ | **สรุปส่งรายงาน** block emitted; promoted + hub wikilinks in daily |
| 4 AUTOLOG | **Skip** unless this session also applied a verified app patch (autolog rule applies separately) |
