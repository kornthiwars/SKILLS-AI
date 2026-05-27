# learnings — reusable lessons (separate from issues)

**One closed lesson = one file** — not stuffed into `issues/YYYY-MM-DD.md`

## When to create

**Not “≥2 chat rounds”** — use **worth finding again**.

### Both required (AND)

1. **Closed** (fixed / decided / wontfix / deferred)
2. **Worth keeping** — you would Grep for this next month

### At least one (OR)

- non-trivial mechanism  
- **≥2 distinct approaches** on the same problem  
- repeat in issues within ~7 days, or user says they have seen it  
- system friction (git / skill / vault / setup)  
- user asks to save a lesson  

| Use **issues** instead | Not a learning |
|------------------------|----------------|
| short work Q&A, rule explanation | chitchat |
| one-off fix, no lesson | still investigating |
| daily log | `/fix-record` (long RCA) |

## Filename

`YYYY-MM-DD-HHmm.md` — local time when the lesson closed

## Structure (lesson card)

See [templates/template.learning.md](../../templates/template.learning.md)

| Section | Content |
|---------|---------|
| **Context** | work / repo / skill |
| **Symptoms** | what you saw |
| **Root cause** | mechanism |
| **Fix** | commands / files that worked |
| **When to use** | reopen when… |
| **Avoid** | anti-pattern |
| **References** | `related_issue: YYYY-MM-DD` (optional) |

**Do not** use `### Question` · `ประเภท:` · old issues layout.

## Obsidian

- frontmatter `tags: [learning, <skill>]` + `skill:` for topics
- `title:` in English — graph label via Property Over File Name
- folder color: `path:learnings` in `vault/.obsidian/graph.json`

## Search (agent)

Follow [`ai-skills/vault-recall/reference.md`](../../ai-skills/vault-recall/reference.md) — Grep `symptoms:`, `skill:`, `files:`, symptom text · read ≤3 files.

Write rules: `ai-rules/vault-issues.mdc`
