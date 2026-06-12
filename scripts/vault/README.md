# Vault (agent-only local memory)

Markdown notes under `vault/notes/` — **no Python**, no embeddings, no indexer.

## User setup

Run once after clone (from repo root):

- Windows: `scripts\setup-windows.bat`
- macOS/Linux: `./scripts/setup-macos-linux.sh`

Creates:

- `vault/notes/{daily,decisions,sessions,projects,inbox}/`
- `vault/_meta/{manifest.json,tiers.json}`
- **`vault/notes/daily/YYYY-MM-DD.md`** for **today** (empty Issues table) if missing
- manifest entry `daily-YYYY-MM-DD` when missing (PowerShell always; bash needs `jq`)

Content (tasks, Issues rows, triage) still comes from **`/vault-daily`** — bootstrap only seeds the shell so `/vault-recall` “issue วันนี้” has a file to read.

**New calendar day:** you do **not** run setup again. First `/vault-recall`, `/vault-capture`, or `/vault-daily` that day runs the same ensure step (bootstrap or agent Write from `daily.template.md`).

## Skills

| Skill | Purpose |
|-------|---------|
| `/vault-daily` | Daily task summary + triage (1 file per day) |
| `/vault-capture` | Save session / ADR note |
| `/vault-recall` | Grep/Read vault + cite (uses `manifest.json`) |

Agent tools: `Glob`, `Grep`, `Read`, `Write` on `vault/notes/` — not CLI scripts.

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
| `Missing: vault` | Re-run setup or `bootstrap-vault` |
| Recall empty | Re-run setup (seeds today’s daily) + `/vault-capture` or `/vault-daily` |
| “Issue วันนี้” ว่าง | Bootstrap seeds empty daily; fill Issues via `/vault-daily` |
| Duplicate decisions | Check `vault/_meta/manifest.json` — merge by `id` |
