# wiki-ingest — reference

Page template: [`templates/template.wiki-page.md`](../../templates/template.wiki-page.md)  
Source template: [`templates/template.wiki-source.md`](../../templates/template.wiki-source.md)

All wiki writes use this file — do not duplicate in `SKILL.md`.

---

## Auto-ingest gate (no ask-first)

Triggered by [`vault-issues.mdc`](../../ai-rules/vault-issues.mdc) at end of **work turns**. **Do not** prompt the user "save to wiki?" when this gate passes.

### Evaluate (all must hold)

| # | Check |
|---|--------|
| 1 | Turn is **work** (code, skills, git, debug closed, infra, vault, workflow) — not chitchat |
| 2 | Insight is **durable** — would help `/vault-recall` in a future session on the same topic |
| 3 | Content is **mechanism / pattern / decision** — not only "what we did today" (that stays in `issues/`) |
| 4 | Topic is **closed or verified** — not open bug ledger |
| 5 | User did **not** say no wiki / อย่าเก็บ wiki this turn |
| 6 | Not a feature **plan** artifact → use `workday/plans/` via `/builder-feature` instead |
| 7 | Wiki adds **≥1 durable insight** not already in this turn's `issues/` entry — abstract mechanism, not paraphrase of Question/Answer |

### On PASS

1. Grep `wiki/pages/` for existing slug/title → **merge** (required)
2. Run **Write protocol** below
3. Report one line: `Wiki → vault/wiki/pages/{slug}.md` (or workspace-relative path)

### On FAIL

Skip wiki silently — issues log may still apply.

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

## Close-out verification gate

Before STATUS=READY ([verification-before-completion](https://github.com/obra/superpowers) pattern):

| Step | Proof |
|------|-------|
| 1 IDENTIFY | Paths written: `pages/{slug}.md`, `index.md`, `log.md` (+ optional `sources/`) |
| 2 RUN | Read files after write — slug exists, no duplicate topic page |
| 3 READ | `index.md` lists page; `log.md` has append line with date + action |
| 4 VERIFY | Merge rules followed — no parallel page for same topic |
| 5 CLAIM | Report paths in chat; offer `/vault-recall` for next search |

Forbidden without step 2–3: "saved to wiki" without paths.

---

## Version governance

| Change | Bump `metadata.version` |
|--------|-------------------------|
| Wording | patch |
| Path or merge rule | minor |
