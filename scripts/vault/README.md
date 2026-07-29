# Vault greenfield (Obsidian-native + agent memory)

Layout mirrors vault-service API: everything under `projects/{slug}/`.

## Layout

```text
vault/
  _agent/{manifest.json,tiers.json}
  .obsidian/
  projects/
    {slug}/
      hub.md
      daily/YYYY-MM-DD.md
      sessions/
      decisions/
```

## Setup

From pack root (`AI/`):

```powershell
$env:VAULT_PROJECT = 'platform'
.\scripts\vault\bootstrap-vault.ps1 -Verify
```

Or: `.\scripts\vault\bootstrap-vault.ps1 -Project platform -Verify`

## Autolog (local primary)

```powershell
.\scripts\vault\append-daily.ps1 -Project platform -Bullet "smoke"
```

Optional dual-write when `VAULT_REMOTE_URL` + `VAULT_AGENT_TOKEN` set:

`POST {VAULT_REMOTE_URL}/vault/projects/{slug}/daily/{date}/entries`

Remote failure → `REMOTE skip` (local file still OK).

## Scripts

| Script | Purpose |
|--------|---------|
| `bootstrap-vault.ps1` / `.sh` | Greenfield tree + `_agent` + optional project seed |
| `append-daily.ps1` / `.sh` | Require `-Project`; write `projects/{slug}/daily/DATE.md` |
| `archive-daily.ps1` | Archive old dailies under each `projects/*/daily/archive/YYYY/` |
| `grep-vault.ps1` / `.sh` | Search gitignored notes |

## Templates

Schemas in [`templates/vault/notes/`](../../templates/vault/notes/). Bootstrap seeds `hub.md` from `template.vault-project.md` and today daily from `template.vault-daily.md`.
