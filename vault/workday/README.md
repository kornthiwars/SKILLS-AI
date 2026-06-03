# workday

Daily execution plans — separate from `issues/` (Q&A) and `wiki/` (long-lived knowledge).

## Layout

```
vault/workday/
├── README.md                 ← in git
└── YYYY-MM-DD.md             ← today's plan (local, gitignored; updated in place)
```

## Flow

| Skill | File action |
|-------|-------------|
| `/workday-init` | Create or replace `YYYY-MM-DD.md` |
| `/workday-update` | Overwrite same file; bump `plan_version` in frontmatter |
| `/workday-review` | Overwrite same file; `status: closed` |

## Obsidian

- Tag: `workday` (frontmatter + graph)
- Graph color: green (`path:workday` in `.obsidian/graph.json`)
- Open `vault/` in Obsidian alongside issues and wiki

## Agent

Path resolution + write rules: [`ai-skills/workday-init/reference.md`](../../ai-skills/workday-init/reference.md) § Persistence.

File wrapper: [`templates/template.workday-file.md`](../../templates/template.workday-file.md).

Block shape: [`templates/template.workday.md`](../../templates/template.workday.md).

## Git

**In git:** this README, `.obsidian` graph config  
**Local only:** `*.md` except README
