# Vault templates (SSoT)

Pack schema for Obsidian-native + agent dual-use vault. Runtime notes live in `vault/` (gitignored); this folder is committed in git.

## Layout

| Path | Purpose |
|------|---------|
| `notes/template.vault-*.md` | Note schemas — agent `Read` → replace placeholders → `Write` |
| `meta/*.template.json` | Agent catalog seeds → `vault/_agent/` |
| `obsidian/` | Obsidian config seed → `vault/.obsidian/` (copy-if-missing) |

## Runtime paths (Obsidian vault root = `vault/`)

| Tier | Schema | Runtime | Manifest `tier` |
|------|--------|---------|-----------------|
| Home | `template.vault-home.md` | `Home.md` | — |
| Ephemeral | `template.vault-daily.md` | `daily/DATE.md` | `ephemeral` |
| Episodic | `template.vault-session.md` | `sessions/SLUG.md` | `episodic` |
| Semantic (ADR) | `template.vault-decision.md` | `decisions/SLUG.md` | `semantic` |
| Semantic (project) | `template.vault-project.md` | `projects/SLUG.md` | `semantic` |

Manifest paths are relative to `vault/`, e.g. `sessions/auth-fix.md` (no `notes/` prefix).

## Placeholders

| Token | Use in | Meaning |
|-------|--------|---------|
| `DATE` | daily | `YYYY-MM-DD` |
| `ISO` | daily | ISO8601 for `updated_at` |
| `SLUG` | session, decision, project | kebab-case filename stem |
| `TITLE` | session, decision, project | Note title |
| `PROJECT` | session, decision, project | Workspace project id (e.g. `web`) |
| `CREATED` | session, decision, project | `YYYY-MM-DD` |
| `UPDATED` | session, decision, project | `YYYY-MM-DD` |

## Manifest entry (schema v2)

```json
{
  "id": "sess-SLUG | dec-SLUG | proj-SLUG | daily-DATE",
  "path": "sessions/SLUG.md",
  "title": "TITLE",
  "tier": "ephemeral | episodic | semantic",
  "project": "PROJECT",
  "status": "active",
  "updated": "YYYY-MM-DD",
  "tags": []
}
```

Daily manifest entry is optional. Durable tiers: **always upsert** after `Write`.

## Obsidian conventions

- **Daily Notes:** folder `daily/`, format `YYYY-MM-DD.md`
- **Wikilinks:** `[[sessions/slug]]` in body for graph edges (not `notes/` prefix)
- **`related:` YAML** — agent metadata only; does not create Obsidian graph edges without Dataview
- **Templates plugin:** folder `vault/Templates/` (copied from `notes/` on bootstrap)
- **Excluded:** `_agent/**` from graph (seed in `obsidian/app.json`)

## Tag taxonomy (optional)

| Tag | Use |
|-----|-----|
| `#session` | Episodic capture |
| `#decision` | ADR |
| `#project` | Project MOC |
| `project:web` | Workspace scope in frontmatter `project` field |

## Ephemeral retention

`daily/` is not indexed for broad recall (`index_exclude` in `tiers.json`). Promote durable items via `/vault-daily` triage.

## Obsidian quick start

1. Obsidian → Open folder → `SKILLS-AI/vault` (or `.cursor/vault` junction)
2. Run `scripts/vault/bootstrap-vault.ps1 -Verify` once
3. Daily notes hotkey → creates/opens `daily/YYYY-MM-DD.md`
4. Templates → folder `Templates/`

## Migration from v1 (`notes/` + `_meta/`)

```powershell
powershell -File scripts/vault/migrate-vault.ps1
```

Moves `notes/*` → flat folders, `_meta/` → `_agent/`, rewrites manifest paths. Fails on file collision.

## Seed policy

| Target | Policy |
|--------|--------|
| `vault/.obsidian/*` | Copy-if-missing only (never overwrite user settings) |
| `vault/Templates/*` | Copy-if-missing; use `bootstrap-vault -RefreshTemplates` to add new pack templates |
| `vault/Home.md` | Create from template if missing |
| `vault/_agent/*` | Create from meta template if missing |

No script auto-writes daily or durable notes — agent or Obsidian creates them.
