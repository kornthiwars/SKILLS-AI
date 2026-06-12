# Vault (agent-only local memory)

Markdown notes under `vault/notes/` — **no Python**, no embeddings, no indexer.

## User setup

Run once after clone (from repo root):

- Windows: `scripts\setup-windows.bat`
- macOS/Linux: `./scripts/setup-macos-linux.sh`

Creates:

- `vault/notes/{daily,decisions,sessions,projects}/` (empty dirs OK)
- `vault/_meta/{manifest.json,tiers.json}`

Does **not** create `notes/daily/YYYY-MM-DD.md` — agent `Write` from `daily.template.md` when needed (`/vault-daily`, autolog).

Content (tasks, Issues rows, triage) comes from **`/vault-daily`** and **autolog** (`append-daily`).

**New calendar day:** create today's daily from template before first autolog or `/vault-daily` — bootstrap/setup does not seed it.

## Skills

| Skill | Purpose |
|-------|---------|
| `/vault-daily` | Daily task summary + triage (1 file per day) |
| `/vault-capture` | Save session / ADR note |
| `/vault-recall` | Grep/Read vault + cite (uses `manifest.json`) |

| Script | Purpose |
|--------|---------|
| `append-daily.ps1` / `.sh` | **Autolog** — append daily bullet (**requires** existing daily file + vault layout from bootstrap) |
| `grep-vault.ps1` / `.sh` | **Recall** — search gitignored notes (`rg --no-ignore`) |

| Template | Path | Output |
|----------|------|--------|
| Daily | `daily.template.md` | `notes/daily/DATE.md` |
| Session | `session.template.md` | `notes/sessions/SLUG.md` |
| Decision (ADR) | `decision.template.md` | `notes/decisions/SLUG.md` |
| Project | `project.template.md` | `notes/projects/SLUG.md` |

Placeholders: see [TEMPLATES.md](./TEMPLATES.md). Agent `Read` → replace → `Write` — no auto-seed scripts.

## Migration from Python indexer

If you have `vault/_index/` from an older setup, it is **ignored**. Notes in `vault/notes/` still work; delete `_index/` when convenient.

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
| `append-daily` / vault path error | Run `bootstrap-vault` once (creates `notes/*` dirs); then `Write` daily from `daily.template.md` if today's file missing |
| Recall empty | Re-run setup + `/vault-capture`; recall uses per-file paths (directory Grep skipped — gitignore) |
| Grep vault returns 0 | Use `grep-vault.ps1 -Pattern "..."` (not directory Grep) |
| Autolog skipped | Create today's daily from `daily.template.md` if missing, then `append-daily.ps1 -Bullet "..."`; include `Vault daily:` in reply |
| “Issue วันนี้” ว่าง | สร้าง `notes/daily/<today>.md` จาก `daily.template.md` หรือรัน `/vault-daily` |
| Duplicate decisions | Check `vault/_meta/manifest.json` — merge by `id` |
