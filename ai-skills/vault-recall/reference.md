# vault-recall reference

## Path resolution (read before any tool call)

`vault/**` is **gitignored** — directory `Grep` / `Glob` on vault note folders often returns **empty** even when files exist.

Resolve disk path — use **first that exists**:

| Workspace | Manifest | Note file (`manifest.path`) |
|-----------|----------|----------------------------|
| Parent `web/` | `SKILLS-AI/vault/_agent/manifest.json` | `SKILLS-AI/vault/{path}` or `.cursor/vault/{path}` |
| Pack root `SKILLS-AI/` | `vault/_agent/manifest.json` | `vault/{path}` |

SSoT: [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) § Path resolution.

## Note templates

Creating or interpreting note shape: [templates/vault/README.md](../../templates/vault/README.md). Recall reads existing files only — does not create notes.

## Search modes

| mode | Trigger | Tool |
|------|---------|------|
| daily | date in query, เมื่อวาน, สรุปวันนี้ | `Read` resolved `.../daily/YYYY-MM-DD.md` |
| hybrid | decisions, architecture, how did we | manifest → **per-file** Grep or Read → cite |

**Never** rely on Cursor directory `Grep` on gitignored vault folders — returns empty.

## Hybrid search (gitignore-safe)

1. `Read` manifest (resolved path above)
2. Shortlist ≤10 `docs` by `id`, `title`, `tags`, `project`, `tier`
3. **Broad keyword scan** (tier-wide or manifest empty):

   macOS/Linux:

   ```bash
   ./scripts/vault/grep-vault.sh --pattern "<keywords>" --tier all
   ```

   Windows:

   ```powershell
   powershell -NoProfile -File scripts/vault/grep-vault.ps1 -Pattern "<keywords>" -Tier all
   ```

   Returns JSON `[{path,line,excerpt},...]` via `rg --no-ignore`. Roots from `_agent/tiers.json`. Fallback: per-file `Grep` / `Read` on manifest paths only.

4. `Read` winners (≤5); expand `related:` per cap below
5. Cite `SKILLS-AI/vault/{path}` or `.cursor/vault/{path}` with line range

## Citation format

`SKILLS-AI/vault/decisions/auth-refresh-policy.md` lines 12–28

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

## Obsidian

Open `SKILLS-AI/vault` as vault root. Wikilinks in notes use `[[tier/slug]]` without `notes/` prefix.

**Graph vs agent metadata:** `related:` in frontmatter does **not** create Obsidian graph edges (core). For graph/backlink answers, cite wikilinks in the note body. Use `related:` only for agent recall expansion (manifest `id` refs).

---

## Close-out verification gate

Before STATUS=READY:

| Step | Action |
|------|--------|
| 1 IDENTIFY | Query type (daily vs hybrid); resolved vault root |
| 2 RUN | Manifest read (unless pure daily date); grep-vault or per-file search; ≤5 full reads |
| 3 READ | Answer cites resolved path + line range; no "empty vault" when notes exist on disk |
| 4 AUTOLOG | **Skip** — read-only skill |
