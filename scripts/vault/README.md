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

Schemas live in `templates/vault/notes/` (git). `bootstrap-vault` seeds today's `daily/*.md` if missing; bullets via `append-daily` or autolog.

## Skills

| Skill | Purpose |
|-------|---------|
| `/vault-daily` | Daily task summary + triage (1 file per day) |
| `/vault-capture` | Session / ADR + infer project + auto hub ensure |
| `/vault-recall` | Grep/Read vault + cite (uses `manifest.json`) |

| Script | Purpose |
|--------|---------|
| `bootstrap-vault.ps1` / `.sh` | Layout + Obsidian seed + today's daily if missing |
| `append-daily.ps1` / `.sh` | **Autolog** — append daily bullet (UTF-8 safe; first `##` after frontmatter) |
| `archive-daily.ps1` / `.sh` | Move stale `daily/*.md` → `daily/archive/YYYY/` |
| `grep-vault.ps1` / `.sh` | **Recall** — search gitignored notes (`rg --no-ignore`) |

## Schema (git)

Templates: [`templates/vault/`](../../templates/vault/README.md) — not in `scripts/vault/`.

| Template | Runtime path |
|----------|--------------|
| `template.vault-daily.md` | `daily/DATE.md` |
| `template.vault-session.md` | `sessions/SLUG.md` |
| `template.vault-decision.md` | `decisions/SLUG.md` |
| `template.vault-project.md` | `projects/SLUG.md` |

Agent `Read` → replace placeholders → `Write`.

## Obsidian

1. Open folder → `agent-skills/vault` (legacy `SKILLS-AI/vault`) or `.cursor/vault` junction
2. Daily notes → `daily/`, format `YYYY-MM-DD` (blank file; agent adds schema)
3. Wikilinks: `[[sessions/slug]]` (flat tier folders)
4. `_agent/` excluded from graph (agent catalog only)
5. Schemas: `templates/vault/notes/` in repo — core **Templates** plugin off

### Seed policy

| Target | Policy |
|--------|--------|
| `.obsidian/*` | Copy-if-missing (never overwrite user settings) |
| Note schemas | Pack git only — never copied into `vault/` |

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
| `append-daily` path error | Re-run bootstrap; `append-daily` auto-creates daily from template |
| `append-daily` missing summary section | Ensure daily has YAML frontmatter + `##` summary heading; re-seed from template if corrupt |
| Archive daily | `archive-daily.ps1 -DryRun` first; files move to `daily/archive/YYYY/` |
| Recall empty | Use `grep-vault.ps1 -Pattern "..."` (not directory Grep) |
| Duplicate decisions | Check `vault/_agent/manifest.json` — merge by `id` |
