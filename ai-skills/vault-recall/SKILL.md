---
name: vault-recall
metadata:
  version: "2.4.3"
description: >-
  Use when the user asks what was decided, fixed, or captured in vault memory — search
  via manifest + grep-vault or per-file Read, cite paths and line ranges. Use before
  RCA, review, or repeating past work. No Python. Invoke /vault-recall with your question.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Vault recall

Retrieve context from local vault using agent tools — **`grep-vault` shell script** for gitignored tier search; otherwise `Read` / per-file tools (no Python).

## Scope Guardrails

- ALWAYS resolve paths per [reference.md](./reference.md) § Path resolution (`SKILLS-AI/vault/` or `.cursor/vault/` in parent workspace `web/`)
- ALWAYS `Read` manifest before hybrid search (skip for pure daily-date reads)
- ALWAYS cite resolved vault path with line range
- For **tier-wide keyword search** → run `scripts/vault/grep-vault.ps1 -Pattern "..."` (or `.sh`) — searches gitignored notes via `rg --no-ignore`
- Else `Grep` each manifest file path individually, or `Read` then match in context
- NEVER rely on directory `Grep` alone on `vault/` note folders — Cursor `Grep` skips gitignored paths
- NEVER cite `status: superseded` as the primary answer — follow `supersedes` to active doc
- For **Obsidian graph / backlinks** questions — cite `[[tier/slug]]` wikilinks in note **body**; `related:` in YAML is agent metadata only (no graph edge without Dataview)

## Recall iron laws

1. **Manifest first** — `Read` `vault/_agent/manifest.json`; shortlist ≤10 docs by `id`/`title`/`tags`/`project` match
2. **Prune stale** — if manifest `path` missing on disk, remove entry and rewrite `manifest.json` (file wins over manifest)
3. **Grep scoped** — search manifest shortlist paths, or full tier if manifest empty: `decisions/`, `sessions/`, `projects/` only
4. **Supersedes** — skip `status: superseded`; if hit has `supersedes`, open the replacement `id`
5. **Related cap** — expand `related:` (agent ids) max **2 hops**, max **3 extra files**; for human graph, prefer following wikilinks in body
6. **Read budget** — full body `Read` for ≤5 files per query
7. **Thai/EN** — if query is Thai, also Grep English keywords from `tags`/`title`; vice versa

## Workflow

0. Classify query:
   - **Daily / date** ("เมื่อวาน", `YYYY-MM-DD`, "สรุปวันนี้") → `Read` resolved `.../daily/<date>.md`; if missing, say no daily for that date
   - **Decision / technical** → steps 1–7
1. `Read` resolved `.../_agent/manifest.json`
2. Build keyword list from user query (+ EN/TH variants for technical terms)
3. Shortlist manifest `docs` where `id`, `title`, `tags`, or `project` match (≤10)
4. **Search** — manifest shortlist: per-file `Grep` or `Read`; **broad tier scan**: `grep-vault.ps1 -Pattern "<keywords>"` (gitignore-safe)
5. `Read` frontmatter of top candidates — drop `status: superseded`
6. `Read` body of winners (≤5 files); expand `related:` within cap
7. Answer Thai ~60% / English ~40% with citations

## SKILL REPORT

| Section | `/vault-recall` |
|---------|-----------------|
| STATUS | READY when results cited or daily loaded |
| ARTIFACTS | manifest shortlist, cited paths + line ranges |

Detail: [reference.md](./reference.md) · Pack integration: [vault-capture/reference.md](../vault-capture/reference.md) § Integration with pack skills
