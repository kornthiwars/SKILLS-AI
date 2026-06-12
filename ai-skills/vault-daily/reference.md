# vault-daily reference

## Daily file template

Path: `vault/notes/daily/YYYY-MM-DD.md`

```markdown
---
id: "daily-YYYY-MM-DD"
type: daily
date: "YYYY-MM-DD"
project: "<project-or-empty>"
updated_at: "<ISO8601>"
runs: 1
carry_over: []
promoted: []
---

## สรุปงานวันนี้

## Issues วันนี้
| id | Issue | สถานะ | triage | เหตุผล |
|----|-------|-------|--------|--------|

## Promoted (ลิงก์ถาวร)

## สรุปวันอย่างเดียว
```

## Triage values

| triage | Action |
|--------|--------|
| keep_decision | Update `vault/notes/decisions/<topic-slug>.md` + manifest |
| keep_learning | Update `vault/notes/sessions/<topic-slug>.md` + manifest |
| keep_project | Update `vault/notes/projects/<name>.md` + manifest |
| daily_only | Stay in daily only |
| carry_over | Add to frontmatter `carry_over` |

Dedupe before promote: `Read` manifest + `Glob` by slug.

## Decision file (promoted)

```yaml
---
id: "dec-<topic-slug>"
title: "<title>"
tags: []
project: "<project>"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
status: draft
supersedes: null
related: []
---
```

## Merge same day

- Append new tasks/issues; dedupe rows by `id`
- `runs: <previous + 1>`
- `updated_at: now`

## สรุปส่งรายงาน (output block)

Plain Thai bullets — completed, in-progress, carry-over, promoted links.
