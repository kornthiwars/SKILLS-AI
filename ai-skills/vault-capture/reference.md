# vault-capture reference

## Session note template

Path: `vault/notes/sessions/<topic-slug>.md`

```markdown
---
id: "sess-<topic-slug>"
title: "<title>"
tags: []
project: "<project>"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
status: active
related: []
---

## Context

## WhatChanged

## Decisions

## FollowUps
```

## Dedupe

`search.py --dedupe` returns `match: true` when score ≥ 0.85 (config). Merge into existing note instead of creating duplicate.

---

## Integration with pack skills

Master matrix — which skills hand off to vault and which do not.

| Skill | Integration | Vault skill | Notes |
|-------|-------------|-------------|-------|
| `/debug` | **full** | capture, daily | After verified fix — condensed memory or end-of-day triage |
| `/fix-record` | **full** | recall, capture | RCA is canonical; vault stores short recall summary only |
| `/scrutinize` | **full** | recall, capture | Recall before architecture/policy verdict |
| `/builder-feature` | **full** | capture, daily | After `PLAN_READY` — ADR to `vault/notes/decisions/` |
| `/builder-schema` | **light** | recall, capture | Before destructive migration; durable schema decision |
| `/builder-api` | **light** | recall, capture | Before contract break; ADR after slice verify |
| `/builder-infrastructure` | **light** | capture | Runbook / infra decision after verify |
| `/builder-ui` | **none** | daily only | Copy/layout tweaks → `/vault-daily` `daily_only`, not capture |
| `/git-push` | **none** | — | `vault/_index/` gitignored; no memory handoff |
| `/upgrade-ai` | **none** | — | Meta skill — no app memory |
| `/vault-capture` | — | — | Destination; dedupe before write |
| `/vault-recall` | — | — | Read path; cite sources |
| `/vault-daily` | — | — | Ephemeral tier; triage before promote |

**Anti-duplication:** `/fix-record` owns full RCA. `/vault-capture` owns episodic or decision notes — link, do not copy.

### Frontmatter when sourced from `/fix-record`

```markdown
---
id: "sess-<topic-slug>"
title: "<short title>"
tags: [bugfix, learning]
project: "<project>"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
status: active
related: ["fix-record:JIRA-12345", "pr:org/repo#5751"]
intent: keep_learning
---

## Context
{1–2 sentences — symptom scope}

## WhatChanged
{fix pointer — PR/commit; not full diff}

## Decisions
{root cause mechanism in one sentence}

## FollowUps
- Full RCA: {JIRA or PR link}
```

### Frontmatter when sourced from `/builder-feature`

```markdown
---
id: "dec-<slug>"
title: "<ADR title>"
tags: [adr, architecture]
project: "<project>"
created: "YYYY-MM-DD"
status: active
related: []
intent: keep_decision
---

## Context
{why this decision was needed}

## Decision
{what was chosen}

## Alternatives considered
{one line each}

## Consequences
{trade-offs, follow-up slices}
```

Path for ADR: `vault/notes/decisions/<slug>.md` (one topic per file).
