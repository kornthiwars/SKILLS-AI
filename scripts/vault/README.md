# Vault (Obsidian-native + agent memory)

Markdown notes under `vault/` — **no Python**, no embeddings, no indexer. Open as Obsidian vault root.

## User setup

Run once after clone (from repo root):

- Windows: `scripts\setup-windows.bat`
- macOS/Linux: `./scripts/setup-macos-linux.sh`

Creates:

- `vault/{daily,decisions,sessions,projects}/` (empty dirs OK)
- `vault/_agent/{manifest.json,tiers.json}`
- `vault/Templates/` (Obsidian Templates plugin)
- `vault/Home.md` (MOC landing)
- `vault/.obsidian/` (seed — copy-if-missing)

Does **not** create `daily/YYYY-MM-DD.md` — agent `Write` from `templates/vault/notes/template.vault-daily.md` when needed (`/vault-daily`, autolog).

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
| `bootstrap-vault.ps1` / `.sh` | Layout + Obsidian seed + Templates copy |
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
| `template.vault-home.md` | `Home.md` |

Agent `Read` → replace placeholders → `Write` — no auto-seed scripts.

## Obsidian

1. Open folder → `SKILLS-AI/vault` (or `.cursor/vault` junction)
2. Daily notes → `daily/`, format `YYYY-MM-DD`
3. Wikilinks: `[[sessions/slug]]` (no `notes/` prefix)
4. `_agent/` excluded from graph (agent catalog only)

### Seed policy

| Target | Policy |
|--------|--------|
| `.obsidian/*` | Copy-if-missing (never overwrite user settings) |
| `Templates/*` | Copy-if-missing; `-RefreshTemplates` adds new pack files |
| `Home.md` | Create if missing |

## Manual bootstrap

```powershell
powershell -File scripts/vault/bootstrap-vault.ps1 -Verify
powershell -File scripts/vault/bootstrap-vault.ps1 -RefreshTemplates
```

```bash
./scripts/vault/bootstrap-vault.sh --verify
./scripts/vault/bootstrap-vault.sh --refresh-templates
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Missing: vault` | Re-run setup or `bootstrap-vault.ps1 -Verify` |
| Legacy `vault/notes/` | Run `migrate-vault.ps1` then bootstrap |
| `append-daily` path error | Bootstrap + Write daily from `template.vault-daily.md` if missing |
| Recall empty | Use `grep-vault.ps1 -Pattern "..."` (not directory Grep) |
| Duplicate decisions | Check `vault/_agent/manifest.json` — merge by `id` |
