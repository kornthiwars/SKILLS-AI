# wiki-ingest — reference

Page template: [`templates/template.wiki-page.md`](../../templates/template.wiki-page.md)  
Source template: [`templates/template.wiki-source.md`](../../templates/template.wiki-source.md)

All wiki writes use this file — do not duplicate in `SKILL.md`.

---

## Persistence (mandatory)

Every close-out **must** write/update wiki files **and** show summary in chat.

### Resolve wiki directory

| Step | If true → wiki dir |
|------|---------------------|
| 1 | Read `<workspace>/.cursor/ai-skills-vault.json` → `wikiRelative` or `vaultRoot` + `/wiki/` |
| 2 | `<workspace>/.cursor/vault/wiki/` | via junction |
| 3 | `<workspace>/vault/wiki/` or agent-skills clone `vault/wiki/` | use |

Create `wiki/pages/`, `wiki/sources/` if missing. Ensure `index.md` and `log.md` exist — from [`templates/template.wiki-index.md`](../../templates/template.wiki-index.md) / [`template.wiki-log.md`](../../templates/template.wiki-log.md) or empty.

### Paths

| Path | Purpose |
|------|---------|
| `wiki/pages/{slug}.md` | Concept page — **one slug per topic** |
| `wiki/sources/{slug}.md` | External source metadata |
| `wiki/index.md` | Catalog — update on every ingest |
| `wiki/log.md` | Append-only changelog |

**Slug:** lowercase kebab-case from title (`LLM Wiki Pattern` → `llm-wiki-pattern`).

### Write protocol

1. **Search** — grep `wiki/pages/` for existing slug/title; **merge** if match (do not duplicate).
2. **Source** — if URL/paper/paste from external → create/update `sources/{slug}.md`.
3. **Page** — create or merge `pages/{slug}.md` from template.
4. **index.md** — add or update line under `## Concepts` or `## Sources`.
5. **log.md** — append: `- {date} — {created|updated} pages/{slug} — {reason}`.
6. Report paths in chat.

### Merge rules

- New facts → append under **Key points** or **Details**
- Contradiction → note in **Details** with date; prefer latest verified
- From `/fix-record` → map Summary/Root cause/Fix to page sections; link RCA commit in **Related**

### Load protocol (`/vault-recall`)

Search order SSoT: [`vault-recall/reference.md`](../vault-recall/reference.md) — wiki pages first.

---

## Version governance

| Change | Bump `metadata.version` |
|--------|-------------------------|
| Wording | patch |
| Path or merge rule | minor |
