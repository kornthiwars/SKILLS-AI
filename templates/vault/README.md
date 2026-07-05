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
| Ephemeral | `template.vault-daily.md` | `daily/DATE.md` | `ephemeral` |
| Episodic | `template.vault-session.md` | `sessions/SLUG.md` | `episodic` |
| Semantic (ADR) | `template.vault-decision.md` | `decisions/SLUG.md` | `semantic` |
| Semantic (project) | `template.vault-project.md` | `projects/SLUG.md` | `semantic` |

Manifest paths are relative to `vault/`, e.g. `sessions/auth-fix.md` (no `notes/` prefix).

## Placeholders

| Token | Use in | Meaning |
|-------|--------|---------|
| `__VAULT_DATE__` | daily | `YYYY-MM-DD` — literal replace only (`.Replace` / `sed`) |
| `__VAULT_ISO__` | daily | ISO8601 for `updated_at` |
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

- **Daily Notes:** folder `daily/`, format `YYYY-MM-DD.md` (blank file from hotkey; agent fills schema from pack)
- **Wikilinks:** `[[sessions/slug]]` in body for graph edges (not `notes/` prefix)
- **`related:` YAML** — agent metadata only; does not create Obsidian graph edges without Dataview
- **Note schemas (SSoT):** `templates/vault/notes/template.vault-*.md` in git — agent `Read`/`Write`
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

### Daily archive (optional)

After triage, move stale dailies off the hot folder:

| Script | Purpose |
|--------|---------|
| `scripts/vault/archive-daily.ps1` | Move `daily/*.md` older than N days → `daily/archive/YYYY/` |
| `scripts/vault/archive-daily.sh` | Same on macOS/Linux |

```powershell
# Default: older than 14 days (excludes recent dailies)
.\scripts\vault\archive-daily.ps1

# Archive everything before a date (after promote)
.\scripts\vault\archive-daily.ps1 -BeforeDate 2026-07-01

# Preview only
.\scripts\vault\archive-daily.ps1 -DryRun
```

Archived paths stay under `daily/**` — still excluded from default recall. Use `grep-vault` with path if needed.

Frontmatter dates: prefer `YYYY-MM-DD` for `created`/`updated`; ISO8601 acceptable for `updated_at` on daily files only.

## Obsidian quick start

1. Obsidian → Open folder → `agent-skills/vault` (legacy `SKILLS-AI/vault`) or `.cursor/vault` junction
2. Run `scripts/vault/bootstrap-vault.ps1 -Verify` once
3. Daily notes hotkey → creates/opens blank `daily/YYYY-MM-DD.md`
4. Schemas → `templates/vault/notes/` in repo (not inside vault)

## Seed policy

| Target | Policy |
|--------|--------|
| `vault/.obsidian/*` | Copy-if-missing only (never overwrite user settings) |
| `vault/_agent/*` | Create from meta template if missing |
| `vault/daily/YYYY-MM-DD.md` | Bootstrap seeds from template if missing (today only) |

Durable notes (sessions, decisions, projects) — agent or Obsidian creates them.
