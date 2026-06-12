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

## Dedupe (agent-only)

1. `Read` `vault/_meta/manifest.json`
2. Match `id` or slug in `path` (`notes/sessions/<slug>.md`)
3. `Grep` `title:` in `vault/notes/sessions/` if ambiguous
4. Merge into existing file — do not create duplicate slug

## Manifest v1 (file: `vault/_meta/manifest.json`)

```json
{
  "schema_version": 1,
  "updated_at": "ISO8601",
  "docs": []
}
```

Each doc entry (upsert by `id`):

```json
{
  "id": "sess-<topic-slug>",
  "path": "notes/sessions/<topic-slug>.md",
  "title": "<title>",
  "tier": "episodic",
  "project": "<project>",
  "status": "active",
  "updated": "YYYY-MM-DD"
}
```

Set manifest `updated_at` to ISO8601. Tier: `semantic` for `decisions/`/`projects/`, `episodic` for `sessions/`.

---

## Ensure today daily shell (all vault skills)

**Idempotent** — run at the start of `/vault-recall`, `/vault-capture`, and `/vault-daily`. User does **not** create a new file each morning.

1. `today` = local calendar `YYYY-MM-DD`
2. Path: `vault/notes/daily/<today>.md`
3. If file **exists** → continue (never overwrite)
4. If **missing** → either:
   - **Preferred:** from pack repo root, run `scripts/vault/bootstrap-vault.ps1 -Verify` (Windows) or `./scripts/vault/bootstrap-vault.sh --verify` (macOS/Linux), **or**
   - **Agent-only:** `Read` `scripts/vault/daily.template.md`, replace `DATE` / `ISO`, `Write` daily file; upsert manifest entry `daily-<today>` (same shape as bootstrap)
5. Empty Issues table is OK — `/vault-daily` fills rows later

**Day rollover:** first vault skill invoke on a new calendar day creates that day’s file automatically. Re-running `setup` is optional, not required daily.

---

## Integration with pack skills

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
| `/git-push` | **none** | — | `vault/**` gitignored; no memory handoff |
| `/upgrade-ai` | **none** | — | Meta skill — no app memory |
| `/vault-capture` | — | — | Destination; dedupe + manifest upsert |
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

### Inbox workflow

- Quick scratch → `vault/notes/inbox/<slug>.md` (not in manifest)
- `/vault-daily` triage moves to daily or promotes to durable tier + manifest
