# vault

Obsidian vault root = this **`vault/`** folder (open the repo or open `vault/` directly).

## Layout

```
templates/                    ← repo root
vault/
├── .obsidian/                ← graph colors (in git)
├── issues/YYYY-MM-DD.md      ← daily work log (local, gitignored)
├── workday/YYYY-MM-DD.md     ← daily plan WORKDAY (local, gitignored)
└── wiki/                     ← long-lived knowledge (local pages)
    ├── index.md              ← catalog
    ├── log.md                ← update log
    ├── pages/{slug}.md       ← concepts (merge over time)
    └── sources/{slug}.md     ← papers, URLs
```

## Flow

```
Short work Q&A     → issues/YYYY-MM-DD.md
Daily plan         → workday/YYYY-MM-DD.md    (/workday-init · update · review)
Durable knowledge  → wiki/pages/              (/wiki-ingest)
Casual chat        → do not write
RCA after fix      → /fix-record → optional /wiki-ingest
```

## Tags (Obsidian)

| Tag | Folder |
|-----|--------|
| `issues` | `issues/` |
| `workday` | `workday/` |
| `wiki` | `wiki/` |

Topic hashtags: `vault` · `git` · `skills` · `sql` · `debug` · `research` · `ui` · `api` · `infrastructure`

## Graph

- **Groups:** `path:issues` (blue) · `path:workday` (green) · `path:wiki` (purple)
- **Filter:** `-path:templates -file:README`

## Agent

| Piece | Role |
|-------|------|
| `ai-rules/vault-issues.mdc` | When to write issues; wiki via skill |
| `ai-skills/vault-recall/reference.md` | Search: wiki → issues |
| `/vault-recall` | Read-only search |
| `/wiki-ingest` | Curate wiki pages |

## Git

**In git:** README files, `.obsidian`, `templates/`  
**Local only:** `issues/*.md`, `workday/*.md`, `wiki/**` except `wiki/README.md`
