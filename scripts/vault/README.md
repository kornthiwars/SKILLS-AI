# Vault (agent-only local memory)

Markdown notes under `vault/notes/` — **no Python**, no embeddings, no indexer.

## User setup

Run once after clone (from repo root):

- Windows: `scripts\setup-windows.bat`
- macOS/Linux: `./scripts/setup-macos-linux.sh`

Creates `vault/notes/{daily,decisions,sessions,projects,inbox}/` and `vault/_meta/{manifest.json,tiers.json}`.

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
| Recall empty | Run `/vault-capture` or promote via `/vault-daily` |
| Duplicate decisions | Check `vault/_meta/manifest.json` — merge by `id` |
