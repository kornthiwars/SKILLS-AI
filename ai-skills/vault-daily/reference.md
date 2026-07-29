# vault-daily reference

## Note templates (SSoT)

All templates: `templates/vault/notes/` — detail in [templates/vault/README.md](../../templates/vault/README.md).

| Tier | Template | Output |
|------|----------|--------|
| Daily | `template.vault-daily.md` | `projects/{slug}/daily/DATE.md` |
| Session | `template.vault-session.md` | `projects/{slug}/sessions/SLUG.md` |
| Decision | `template.vault-decision.md` | `projects/{slug}/decisions/SLUG.md` |
| Project hub | `template.vault-project.md` | `projects/{slug}/hub.md` |

## Daily file

Path: `vault/projects/{slug}/daily/YYYY-MM-DD.md` (`VAULT_PROJECT` / `-Project` required).

**Template:** `templates/vault/notes/template.vault-daily.md` — replace `__VAULT_DATE__`, `__VAULT_ISO__`, `__VAULT_PROJECT__`. Prefer `append-daily` script (auto-creates file).

## Triage values

| triage | Action |
|--------|--------|
| keep_decision | `template.vault-decision.md` → `projects/<slug>/decisions/<topic>.md` + manifest + **hub ensure** |
| keep_learning | `template.vault-session.md` → `projects/<slug>/sessions/<topic>.md` + manifest + **hub ensure** |
| keep_project | `template.vault-project.md` → `projects/<slug>/hub.md` + manifest |
| daily_only | Stay in daily only |
| carry_over | Add to frontmatter `carry_over` |

Dedupe before promote: `Read` `vault/_agent/manifest.json` + match slug in `path`.

## Infer project + hub ensure (sessions/decisions promote)

After promote + manifest upsert for `keep_decision` or `keep_learning`:

1. **Infer `project`** — [vault-capture/reference.md](../vault-capture/reference.md) § Infer project
2. **Hub ensure** — [vault-capture/reference.md](../vault-capture/reference.md) § Project hub auto-ensure

Skip hub ensure for `keep_project` (note is the hub) and `daily_only`.

Report in **สรุปส่งรายงาน**: `Inferred project: <slug> (<reason>)`, hub `created` | `updated`.

## Promoted wikilinks

In daily `## Promoted`, use Obsidian wikilinks: `[[projects/slug/decisions/note]]`, `[[projects/slug/sessions/note]]`, `[[projects/slug/hub]]`.

## Archive stale dailies

```powershell
.\scripts\vault\archive-daily.ps1
.\scripts\vault\archive-daily.ps1 -Project platform -BeforeDate 2026-07-01
.\scripts\vault\archive-daily.ps1 -DryRun
```

Moves `projects/*/daily/*.md` → `projects/*/daily/archive/YYYY/`.

## สรุปส่งรายงาน (output block)

Plain Thai bullets — completed, in-progress, carry-over, promoted links.

## Close-out verification gate

Before STATUS=READY: triage confirm when promote; paths under `projects/{slug}/`; hub ensure when applicable; manifest `tags` present.
