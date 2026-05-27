# vault

Obsidian vault root = this **`vault/`** folder (open the repo or open `vault/` directly).

## Layout

```
templates/                    ← repo root
vault/
├── .obsidian/                ← graph colors for 2 folders (in git)
├── issues/YYYY-MM-DD.md      ← daily work log (local, gitignored)
└── learnings/YYYY-MM-DD-HHmm.md  ← reusable lessons (local)
```

## Flow

```
Short work Q&A     → issues/YYYY-MM-DD.md     (## N. + Question / Answer)
Casual chat        → do not write
Reusable lesson    → learnings/YYYY-MM-DD-HHmm  (closed + OR signals — see rule)
RCA after fix      → /fix-record
```

**issues ≠ learnings** — do not reuse legacy `ประเภท` / old section layouts.

## Tags (Obsidian)

### Type (required)

| Tag | Folder |
|-----|--------|
| `issues` | `issues/` |
| `learning` | `learnings/` |

### Topic (pick 1–3 per entry)

`vault` · `git` · `skills` · `sql` · `debug` · `research` · `ui` · `api` · `infrastructure`

Put in daily frontmatter + `#vault #git` line under `## N. title`.

## Graph

- Config: `vault/.obsidian/graph.json`
- **Groups:** `path:issues` (blue) · `path:learnings` (gold)
- **Filter:** `-path:templates -file:README`
- Enable **Tags** in Graph · no hub file · wikilinks optional

## Plugin (recommended)

**Property Over File Name** — show `title:` instead of `2026-05-27-1545.md`  
Enable community plugins in Obsidian; repo ships `.obsidian/community-plugins.json`.

## Agent rules & search

| Piece | Role |
|-------|------|
| `ai-rules/vault-issues.mdc` | When to write issues/learnings + formats |
| `ai-skills/vault-recall/reference.md` | How to grep before debug/git (SSoT) |
| `/vault-recall` | Read-only search on demand |

Linked to `.cursor/rules/` after setup.

## Git

**In git:** README, `.obsidian`, `templates/`  
**Local only:** `issues/*.md`, `learnings/*.md` (except `*/README.md`)
