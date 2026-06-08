# wiki — personal knowledge base (LLM Wiki Pattern)

Long-lived concepts, research, and reusable knowledge — **not** daily Q&A (`issues/`) or execution plans (`workday/`).

Inspired by [Karpathy LLM Wiki Pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — AI curates Markdown pages that **grow and link**, instead of losing answers in chat history.

## Layout

```
vault/wiki/
├── README.md           ← in git (this file)
├── index.md            ← catalog of pages + one-line summaries (local)
├── log.md              ← append-only update log (local)
├── pages/              ← concept / entity pages — merge, don’t duplicate (local)
│   └── {slug}.md
└── sources/            ← one file per paper, article, URL (local)
    └── {slug}.md
```

## Flow

| Need | Where | Skill |
|------|-------|--------|
| Daily Q&A | `issues/YYYY-MM-DD.md` | rule `vault-issues.mdc` |
| Daily plan | `workday/YYYY-MM-DD.md` | `/workday-init` · update · review |
| **Knowledge that should survive** | `wiki/pages/` | **auto-ingest** (rule gate) or **`/wiki-ingest`** |
| Long RCA after fix | `/fix-record` | then auto-ingest or `/wiki-ingest` export |

## Rules

- **One topic → one page** — update existing `pages/{slug}.md`; do not create `{slug}-2.md`
- **`index.md`** — always update when adding/changing pages
- **`log.md`** — append one line per ingest: date, slug, reason
- **Wikilinks** — use `[[page-slug]]` between related pages
- **Search first** — `/vault-recall` greps `wiki/pages/` before issues

## Obsidian

- Tag: `wiki` · graph color: purple (`path:wiki` in `.obsidian/graph.json`)
- `title:` in frontmatter for Property Over File Name plugin

## Agent

Ingest protocol: [`ai-skills/wiki-ingest/reference.md`](../../ai-skills/wiki-ingest/reference.md)  
Page template: [`templates/template.wiki-page.md`](../../templates/template.wiki-page.md)  
Source template: [`templates/template.wiki-source.md`](../../templates/template.wiki-source.md)

## Git

**In git:** this README  
**Local only:** `index.md`, `log.md`, `pages/**`, `sources/**`
