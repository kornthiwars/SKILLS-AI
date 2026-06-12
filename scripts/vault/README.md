# Vault (Obsidian-native + agent memory)

Markdown notes under `vault/` — **no Python**, no embeddings, no indexer. Open as Obsidian vault root.

## User setup

Run once after clone (from repo root):

- Windows: `scripts\setup-windows.bat`
- macOS/Linux: `./scripts/setup-macos-linux.sh`

Creates:

- `vault/{daily,decisions,sessions,projects}/` (empty dirs OK)
- `vault/_agent/{manifest.json,tiers.json}`
- `vault/.obsidian/` (seed — copy-if-missing)

Does **not** create `vault/Templates/` — schemas live in `templates/vault/notes/` (git). Does **not** create `daily/YYYY-MM-DD.md` — use `append-daily` or agent autolog.

**Migration from v1 (`notes/` + `_meta/`):**

```powershell
powershell -File scripts/vault/migrate-vault.ps1
powershell -File scripts/vault/bootstrap-vault.ps1 -Verify
```

## Skills

| Skill | Purpose |
|-------|---------|
| `/vault-daily` | Daily task summary + triage (1 file per day) |
| `/vault-capture` | Save session / ADR note |
| `/vault-recall` | Grep/Read vault + cite (uses `manifest.json`) |

| Script | Purpose |
|--------|---------|
| `bootstrap-vault.ps1` / `.sh` | Layout + Obsidian seed; removes legacy `vault/Templates/` copy |
| `migrate-vault.ps1` / `.sh` | v1 → flat layout + `_agent/` |
| `append-daily.ps1` / `.sh` | **Autolog** — append daily bullet |
| `grep-vault.ps1` / `.sh` | **Recall** — search gitignored notes (`rg --no-ignore`) |

## Schema (git)

Templates: [`templates/vault/`](../../templates/vault/README.md) — not in `scripts/vault/`.

| Template | Runtime path |
|----------|--------------|
| `template.vault-daily.md` | `daily/DATE.md` |
| `template.vault-session.md` | `sessions/SLUG.md` |
| `template.vault-decision.md` | `decisions/SLUG.md` |
| `template.vault-project.md` | `projects/SLUG.md` |

Agent `Read` → replace placeholders → `Write` — no auto-seed scripts.

## Obsidian

1. Open folder → `SKILLS-AI/vault` (or `.cursor/vault` junction)
2. Daily notes → `daily/`, format `YYYY-MM-DD` (blank file; agent adds schema)
3. Wikilinks: `[[sessions/slug]]` (no `notes/` prefix)
4. `_agent/` excluded from graph (agent catalog only)
5. Schemas: open `templates/vault/notes/` in repo — core **Templates** plugin off

### Seed policy

| Target | Policy |
|--------|--------|
| `.obsidian/*` | Copy-if-missing (never overwrite user settings) |
| `Templates/` | Not created; bootstrap removes pack-identical legacy copy |

### Migrate existing Obsidian vault

1. Re-run `bootstrap-vault.ps1 -Verify`
2. Settings → Core plugins → disable **Templates**
3. Settings → Daily notes → clear **Template file location** (or delete `template` key in `.obsidian/daily-notes.json`)

## Manual bootstrap

```powershell
powershell -File scripts/vault/bootstrap-vault.ps1 -Verify
```

```bash
./scripts/vault/bootstrap-vault.sh --verify
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Missing: vault` | Re-run setup or `bootstrap-vault.ps1 -Verify` |
| Legacy `vault/notes/` | Run `migrate-vault.ps1` then bootstrap |
| `append-daily` path error | Re-run bootstrap; `append-daily` auto-creates daily from template |
| Recall empty | Use `grep-vault.ps1 -Pattern "..."` (not directory Grep) |
| Duplicate decisions | Check `vault/_agent/manifest.json` — merge by `id` |
| Old `vault/Templates/` still visible | Re-run bootstrap; Obsidian reload |
