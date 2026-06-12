# vault-recall reference

## Path resolution (read before any tool call)

`vault/**` is **gitignored** — directory `Grep` / `Glob` on `vault/notes/` often returns **empty** even when files exist.

Resolve disk path — use **first that exists**:

| Workspace | Manifest | Note file (`manifest.path`) |
|-----------|----------|----------------------------|
| Parent `web/` | `SKILLS-AI/vault/_meta/manifest.json` | `SKILLS-AI/vault/{path}` or `.cursor/vault/{path}` |
| Pack root `SKILLS-AI/` | `vault/_meta/manifest.json` | `vault/{path}` |

SSoT: [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) § Path resolution.

## Note templates

Creating or interpreting note shape: [scripts/vault/TEMPLATES.md](../../scripts/vault/TEMPLATES.md) (`daily`, `session`, `decision`, `project` templates). Recall reads existing files only — does not create notes.

## Search modes

| mode | Trigger | Tool |
|------|---------|------|
| daily | date in query, เมื่อวาน, สรุปวันนี้ | `Read` resolved `.../notes/daily/YYYY-MM-DD.md` |
| hybrid | decisions, architecture, how did we | manifest → **per-file** Grep or Read → cite |

**Never** rely on Cursor directory `Grep` on `vault/notes/` — gitignored, returns empty.

## Hybrid search (gitignore-safe)

1. `Read` manifest (resolved path above)
2. Shortlist ≤10 `docs` by `id`, `title`, `tags`, `project`, `tier`
3. **Broad keyword scan** (tier-wide or manifest empty):

   ```powershell
   powershell -NoProfile -File scripts/vault/grep-vault.ps1 -Pattern "<keywords>" -Tier all
   ```

   Returns JSON `[{path,line,excerpt},...]` via `rg --no-ignore`. Fallback: per-file `Grep` / `Read` on manifest paths only.

4. `Read` winners (≤5); expand `related:` per cap below
5. Cite `SKILLS-AI/vault/{path}` or `.cursor/vault/{path}` with line range

## Citation format

`SKILLS-AI/vault/notes/decisions/auth-refresh-policy.md` lines 12–28

## Manifest shortlist

Match query tokens against each doc entry:

- `id`, `title`, `tags[]`, `project`
- `tier: semantic` → `decisions/`, `projects/`
- `tier: episodic` → `sessions/`
- `tier: ephemeral` → daily only; use date `Read`, not hybrid Grep

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

If `path` in manifest but file missing on disk → drop entry when rewriting manifest; do not cite missing path.

Daily files: `Read` by date path; listed in manifest as `tier: ephemeral` for bookkeeping only.
