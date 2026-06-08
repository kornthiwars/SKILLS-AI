# vault

Obsidian vault root = this **`vault/`** folder (open the repo or open `vault/` directly).

## Layout

```
templates/                    ← repo root
vault/
├── .obsidian/                ← graph colors (in git)
├── issues/YYYY-MM-DD.md      ← daily work log (local, gitignored)
├── workday/YYYY-MM-DD.md     ← daily plan WORKDAY (local, gitignored)
│   └── plans/{slug}.md       ← feature plans from /builder-feature (local, gitignored)
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
Feature plan       → workday/plans/{slug}.md  (/builder-feature PLAN_READY — opt-in)
Durable knowledge  → wiki/pages/              (auto-ingest gate or /wiki-ingest)
Casual chat        → do not write
RCA after fix      → /fix-record → wiki auto-ingest when reusable
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
| `vault-issues.mdc` + `/wiki-ingest` | Auto-ingest durable wiki; manual ingest |

## Git

**In git:** README files, `.obsidian`, `templates/`  
**Local only:** `issues/*.md`, `workday/*.md`, `wiki/**` except `wiki/README.md`
