# vault-capture reference

## Note templates (SSoT)

| Tier | Template file | Path |
|------|---------------|------|
| Daily | `scripts/vault/daily.template.md` | `notes/daily/DATE.md` |
| Session | `scripts/vault/session.template.md` | `notes/sessions/SLUG.md` |
| Decision | `scripts/vault/decision.template.md` | `notes/decisions/SLUG.md` |
| Project | `scripts/vault/project.template.md` | `notes/projects/SLUG.md` |

Placeholders: [scripts/vault/TEMPLATES.md](../../scripts/vault/TEMPLATES.md).

## Session note

Path: `vault/notes/sessions/<slug>.md` — use **`session.template.md`** (`SLUG`, `TITLE`, `PROJECT`, `CREATED`, `UPDATED`).

Sections: **Context**, **WhatChanged**, **Decisions**, **FollowUps**.

## Gitignore note

`vault/**` is gitignored — **do not** `Grep` directories under `vault/notes/`. Use `Read`/`Write` on resolved paths; recall uses per-file `Grep` only ([vault-recall/reference.md](../vault-recall/reference.md)).

## Dedupe (agent-only)

1. `Read` resolved `.../vault/_meta/manifest.json`
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

## Daily file (agent-created — not bootstrap)

`notes/daily/` may stay **empty** until you need a daily log. **No script** auto-creates today's file.

1. `today` = local calendar `YYYY-MM-DD`
2. Path: resolve per [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) § Path resolution
3. If file **exists** → read/merge (never overwrite wholesale)
4. If **missing** and you need daily (autolog, `/vault-daily`, recall “วันนี้”):
   - `Read` `scripts/vault/daily.template.md`
   - Replace `DATE` / `ISO`
   - `Write` `vault/notes/daily/<today>.md`
   - Optional: upsert manifest `daily-<today>` (`tier: ephemeral`)
5. Then run `append-daily` for bullets, or full `/vault-daily` for triage

### Autolog after verified work (no slash)

Always-on rule: [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc). After patch + verify: create today's daily **if missing** (step 4), then `append-daily` bullet.

| User action | Daily file | สรุปงานวันนี้ | Issues table |
|-------------|------------|---------------|--------------|
| แก้โค้ด / patch + verify | agent Write if missing | `append-daily` | only bugs/blockers |
| `/vault-recall` | read if exists | read | read |
| `/vault-daily` | create if missing, then merge | full triage | user confirms promote |

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
| `/builder-ui` | **autolog** | daily only | After verify → [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc); `/vault-daily` for triage only |
| `/git-push` | **none** | — | `vault/**` gitignored; no memory handoff |
| `/upgrade-ai` | **none** | — | Meta skill — no app memory |
| `/vault-capture` | — | — | Destination; dedupe + manifest upsert |
| `/vault-recall` | — | — | Read path; cite sources |
| `/vault-daily` | — | — | Ephemeral tier; triage before promote |

**Anti-duplication:** `/fix-record` owns full RCA. `/vault-capture` owns episodic or decision notes — link, do not copy.

### Frontmatter when sourced from `/fix-record`

Start from **`session.template.md`** — add to frontmatter:

- `tags: [bugfix, learning]`
- `related: ["fix-record:JIRA-12345", "pr:org/repo#5751"]` (or PR id)
- `intent: keep_learning`

Sections (keep concise — full RCA stays in fix-record):

| Section | Content |
|---------|---------|
| Context | 1–2 sentences — symptom scope |
| WhatChanged | fix pointer — PR/commit; not full diff |
| Decisions | root cause mechanism in one sentence |
| FollowUps | `- Full RCA: {JIRA or PR link}` |

### Frontmatter when sourced from `/builder-feature`

Use **`decision.template.md`** — add `intent: keep_decision` to frontmatter when promoting from `/vault-daily`.

Path: `vault/notes/decisions/<slug>.md` (one topic per file).

### Project note

Path: `vault/notes/projects/<slug>.md` — use **`project.template.md`**.

Sections: **Overview**, **Goals**, **Status** (table), **Links**. Manifest: `id: proj-<slug>`, `tier: semantic`.

Used by `/vault-daily` promote (`keep_project`) and `/vault-capture` when tier is `projects`.
