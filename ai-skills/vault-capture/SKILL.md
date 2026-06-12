---
name: vault-capture
metadata:
  version: "1.0.0"
description: >-
  Capture current Cursor session into local vault as episodic note — dedupe
  before write, index after save. Invoke with /vault-capture.
disable-model-invocation: true
---

# Vault capture

Save meaningful session context to `vault/notes/sessions/<topic-slug>.md` and run incremental index.

## Scope Guardrails

- ALWAYS run dedupe before creating a new session file
- ALWAYS one topic per file (`<topic-slug>.md`, not date-prefixed)
- NEVER store secrets or credentials
- Link from today's daily file if it exists — do not duplicate full content in daily

## CLI (repo root)

```bash
python scripts/vault/search.py --dedupe "<session topic>" --json
python scripts/vault/index.py
```

## Workflow

1. Infer session topic slug from conversation
2. `python scripts/vault/search.py --dedupe "<topic>" --json`
   - If `match: true` → update existing file at `best.path`
   - Else → create `vault/notes/sessions/<topic-slug>.md`
3. Frontmatter: `id`, `title`, `tags`, `project`, `related`, `status: active`
4. Sections: Context, WhatChanged, Decisions, FollowUps
5. Optional: add wikilink in `vault/notes/daily/<today>.md` under Promoted or summary
6. `python scripts/vault/index.py`
7. Report saved path (via `.cursor/vault` junction)

## SKILL REPORT

| Section | `/vault-capture` |
|---------|------------------|
| STATUS | READY when file written + index ok |
| ARTIFACTS | session note path, index output |

Pack integration (which skills hand off here): [reference.md](./reference.md) § Integration with pack skills
