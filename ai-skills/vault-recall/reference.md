# vault-recall reference

## Search modes

| mode | Trigger | Tool |
|------|---------|------|
| daily | date in query, เมื่อวาน, สรุปวัน | `daily.py` or `search.py` daily detection |
| hybrid | decisions, architecture, how did we | `search.py --json` |

## Citation format

`vault/notes/decisions/auth-refresh-policy.md` lines 12–28

## Stale index

Run `index.py` when:

- `--status` shows no indexed files
- notes changed after `indexed_at`

Daily files are never embedded; date queries read markdown directly.
