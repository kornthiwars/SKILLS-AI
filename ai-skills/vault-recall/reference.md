# vault-recall reference

## Search modes

| mode | Trigger | Tool |
|------|---------|------|
| daily | date in query, เมื่อวาน, สรุปวัน | `Read` `vault/notes/daily/YYYY-MM-DD.md` |
| hybrid | decisions, architecture, how did we | manifest → Grep → Read |

## Citation format

`vault/notes/decisions/auth-refresh-policy.md` lines 12–28

## Manifest shortlist (before Grep)

Match query tokens against each doc entry:

- `id`, `title`, `tags[]`, `project`
- Prefer `tier: semantic` for policy questions; `episodic` for session learnings

## Supersedes chain

```yaml
status: superseded
supersedes: dec-auth-refresh-v2
```

Do not cite superseded file as final answer — open doc with matching `id`.

## Related expansion

- Hop 1: `related` ids from winning frontmatter → resolve via manifest `id` → `path`
- Hop 2: optional one more level from those files
- Stop at 3 extra files total

## Stale manifest

If `path` in manifest but file missing → prune entry mentally; Grep may still find moved notes by title.

Daily files are never in manifest search tiers; use date path directly.
