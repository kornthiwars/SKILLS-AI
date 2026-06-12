# Vault note templates

All under `scripts/vault/`. **No script auto-writes** note files — agent `Read` template, replace placeholders, `Write` to `vault/notes/`, upsert `manifest.json` when durable.

## Placeholders

| Token | Use in | Meaning |
|-------|--------|---------|
| `DATE` | daily | `YYYY-MM-DD` |
| `ISO` | daily | ISO8601 timestamp for `updated_at` |
| `SLUG` | session, decision, project | kebab-case filename stem |
| `TITLE` | session, decision, project | Note title |
| `PROJECT` | session, decision, project | Workspace project id (e.g. `web`) |
| `CREATED` | session, decision, project | `YYYY-MM-DD` |
| `UPDATED` | session, decision, project | `YYYY-MM-DD` |

## Files

| Tier | Template | Output path | Manifest `tier` |
|------|----------|-------------|-----------------|
| Ephemeral | `daily.template.md` | `notes/daily/DATE.md` | `ephemeral` |
| Episodic | `session.template.md` | `notes/sessions/SLUG.md` | `episodic` |
| Semantic (ADR) | `decision.template.md` | `notes/decisions/SLUG.md` | `semantic` |
| Semantic (project) | `project.template.md` | `notes/projects/SLUG.md` | `semantic` |

## Manifest entry shape

```json
{
  "id": "sess-SLUG | dec-SLUG | proj-SLUG | daily-DATE",
  "path": "notes/<tier-dir>/....md",
  "title": "TITLE",
  "tier": "ephemeral | episodic | semantic",
  "project": "PROJECT",
  "status": "active",
  "updated": "YYYY-MM-DD"
}
```

Daily manifest entry is optional. Durable tiers: **always upsert** after `Write`.
