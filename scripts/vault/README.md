# Vault indexer (local)

Zero-touch local memory: Markdown notes + hybrid search (FTS + fastembed).

## User setup

Run once after clone (from repo root):

- Windows: `scripts\setup-windows.bat`
- macOS/Linux: `./scripts/setup-macos-linux.sh`

Requires **Python 3.10+** on PATH.

## Skills

| Skill | Purpose |
|-------|---------|
| `/vault-daily` | Daily task summary + triage (1 file per day) |
| `/vault-capture` | Save session note |
| `/vault-recall` | Search vault + cite |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Python not found` | Install Python 3.10+, re-run setup |
| Search empty | Run `/vault-capture` or promote via `/vault-daily`, then recall |
| Model download slow | First bootstrap downloads `BAAI/bge-m3` (~2GB) |

## Manual CLI (agents use these; users should not need to)

```bash
python scripts/vault/bootstrap.py
python scripts/vault/index.py
python scripts/vault/index.py --status
python scripts/vault/search.py "auth JWT" --json --top 5
python scripts/vault/daily.py --date 2026-06-12
```
