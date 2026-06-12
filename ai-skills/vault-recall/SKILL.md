---
name: vault-recall
metadata:
  version: "1.0.0"
description: >-
  Search local vault memory — hybrid FTS+vector, daily-by-date, cite paths and
  lines. Invoke with /vault-recall and your question.
disable-model-invocation: true
---

# Vault recall

Retrieve context from local vault before answering questions about past work, decisions, or daily summaries.

## Scope Guardrails

- ALWAYS run index if stale before hybrid search (not for pure daily-date queries)
- ALWAYS cite `vault/notes/...md` with line range when using chunk results
- Prefer reading full source file when excerpt is insufficient

## CLI (repo root)

```bash
python scripts/vault/index.py --status
python scripts/vault/index.py
python scripts/vault/search.py "<query>" --json --top 5 --project <name>
python scripts/vault/daily.py --date YYYY-MM-DD
```

## Workflow

1. Classify query:
   - **Daily / date** ("เมื่อวาน", `YYYY-MM-DD`, "สรุปวันนี้") → `search.py` (date mode) or `daily.py --date`
   - **Decision / technical** → hybrid search
2. If hybrid: check staleness → `index.py` if needed
3. `python scripts/vault/search.py "<query>" --json --top 5` (+ `--project` if known)
4. Follow `related:` in frontmatter for linked decisions when helpful
5. Open cited files under `.cursor/vault` or `vault/notes/`
6. Answer in Thai ~60% / English ~40% with citations

## SKILL REPORT

| Section | `/vault-recall` |
|---------|-----------------|
| STATUS | READY when results cited or daily loaded |
| ARTIFACTS | search JSON, cited paths |

Pack integration (when other skills call recall first): [vault-capture/reference.md](../vault-capture/reference.md) § Integration with pack skills

Detail: [reference.md](./reference.md)
