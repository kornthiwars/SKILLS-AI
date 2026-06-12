---
name: vault-recall
metadata:
  version: "2.0.0"
description: >-
  Search local vault memory via manifest + Grep/Read — daily-by-date, cite paths
  and lines. No Python. Invoke with /vault-recall and your question.
disable-model-invocation: true
---

# Vault recall

Retrieve context from `vault/notes/` using agent tools only — **no CLI scripts**.

## Scope Guardrails

- ALWAYS search under workspace path `vault/notes/` (junction `.cursor/vault` points here)
- ALWAYS read `vault/_meta/manifest.json` before hybrid search (skip for pure daily-date reads)
- ALWAYS cite `vault/notes/...md` with line range
- NEVER cite `status: superseded` as the primary answer — follow `supersedes` to active doc

## Recall iron laws

1. **Manifest first** — `Read` `vault/_meta/manifest.json`; shortlist ≤10 docs by `id`/`title`/`tags`/`project` match
2. **Prune stale** — if manifest `path` missing on disk, remove entry and rewrite `manifest.json` (file wins over manifest)
3. **Grep scoped** — search manifest shortlist paths, or full tier if manifest empty: `decisions/`, `sessions/`, `projects/` only
4. **Supersedes** — skip `status: superseded`; if hit has `supersedes`, open the replacement `id`
5. **Related cap** — expand `related:` max **2 hops**, max **3 extra files**
6. **Read budget** — full body `Read` for ≤5 files per query
7. **Thai/EN** — if query is Thai, also Grep English keywords from `tags`/`title`; vice versa

## Workflow

1. Classify query:
   - **Daily / date** ("เมื่อวาน", `YYYY-MM-DD`, "สรุปวันนี้") → `Read` `vault/notes/daily/<date>.md` (no manifest required)
   - **Decision / technical** → steps 2–8
2. `Read` `vault/_meta/manifest.json`
3. Build keyword list from user query (+ EN/TH variants for technical terms)
4. Shortlist manifest `docs` where `id`, `title`, `tags`, or `project` match (≤10)
5. `Grep` keywords in shortlist paths (or tier folders if manifest empty)
6. `Read` frontmatter of top candidates — drop `status: superseded`
7. `Read` body of winners (≤5 files); expand `related:` within cap
8. Answer Thai ~60% / English ~40% with citations

## SKILL REPORT

| Section | `/vault-recall` |
|---------|-----------------|
| STATUS | READY when results cited or daily loaded |
| ARTIFACTS | manifest shortlist, cited paths + line ranges |

Detail: [reference.md](./reference.md) · Pack integration: [vault-capture/reference.md](../vault-capture/reference.md) § Integration with pack skills
