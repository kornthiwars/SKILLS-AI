# Vault templates (SSoT)

Pack schema for Obsidian-native + agent dual-use vault. Runtime notes live in `vault/` (gitignored); this folder is committed in git.

Bootstrap: **PackRoot** = pack that owns `templates/vault/` (script location); **RepoRoot** = where `vault/` runtime is written (`-RepoRoot` / `--repo-root`).

## Layout

| Path | Purpose |
|------|---------|
| `notes/template.vault-*.md` | Note schemas — agent `Read` → replace placeholders → `Write` |
| `meta/*.template.json` | Agent catalog seeds → `vault/_agent/` |
| `obsidian/` | Obsidian config seed → `vault/.obsidian/` (copy-if-missing) |

## Runtime paths (Obsidian vault root = `vault/`)

Canonical (no top-level `daily/` / `sessions/` / `decisions/`):

```text
vault/projects/{slug}/
  hub.md
  daily/YYYY-MM-DD.md
  sessions/SLUG.md
  decisions/SLUG.md
```

| Tier | Schema | Runtime | Manifest `tier` |
|------|--------|---------|-----------------|
| Ephemeral | `template.vault-daily.md` | `projects/{slug}/daily/DATE.md` | `ephemeral` |
| Episodic | `template.vault-session.md` | `projects/{slug}/sessions/SLUG.md` | `episodic` |
| Attempt ledger | `template.attempt-ledger.md` | `projects/{slug}/sessions/attempt-SLUG.md` | *(retry only)* |
| Semantic (ADR) | `template.vault-decision.md` | `projects/{slug}/decisions/SLUG.md` | `semantic` |
| Semantic (hub) | `template.vault-project.md` | `projects/{slug}/hub.md` | `semantic` |

Manifest paths are relative to `vault/`, e.g. `projects/platform/sessions/auth-fix.md`.

## Placeholders

| Token | Use in | Meaning |
|-------|--------|---------|
| `__VAULT_DATE__` | daily | `YYYY-MM-DD` — literal replace only |
| `__VAULT_ISO__` | daily | ISO8601 for `updated_at` |
| `__VAULT_PROJECT__` | daily | project slug |
| `SLUG` / `TITLE` / `PROJECT` / `CREATED` / `UPDATED` | session, decision, hub | as named |

## Manifest entry (schema v2)

```json
{
  "id": "sess-SLUG | dec-SLUG | proj-SLUG | daily-DATE__SLUG",
  "path": "projects/PROJECT/sessions/SLUG.md",
  "title": "TITLE",
  "tier": "ephemeral | episodic | semantic",
  "project": "PROJECT",
  "status": "active",
  "updated": "YYYY-MM-DD",
  "tags": []
}
```

## Obsidian conventions

- **Daily Notes:** seeded `daily-notes.json` sets `"folder": "projects"`. Core plugin does not expand `{slug}` — set folder to `projects/<slug>/daily` per vault/workspace, or open the file the agent creates.
- **Wikilinks:** `[[projects/slug/sessions/note]]`, `[[projects/slug/decisions/note]]`, `[[projects/slug/hub]]`
- **Excluded:** `_agent/**` from graph; `projects/*/daily/**` from default recall (`tiers.json`)

## Ephemeral retention

After triage, archive stale dailies:

```powershell
.\scripts\vault\archive-daily.ps1
.\scripts\vault\archive-daily.ps1 -Project platform -BeforeDate 2026-07-01
.\scripts\vault\archive-daily.ps1 -DryRun
```

Moves `projects/*/daily/*.md` → `projects/*/daily/archive/YYYY/`.

## Seed policy

| Target | Policy |
|--------|--------|
| `vault/.obsidian/*` | Copy-if-missing |
| `vault/_agent/*` | From meta templates if missing |
| `vault/projects/{slug}/…` | Bootstrap with `-Project` / `VAULT_PROJECT`; else empty `projects/` until first append/capture |

## Setup

```powershell
$env:VAULT_PROJECT = 'platform'
.\scripts\vault\bootstrap-vault.ps1 -Verify
.\scripts\vault\append-daily.ps1 -Project platform -Bullet "smoke"
```
