# vault-capture reference

## Note templates (SSoT)

| Tier | Template file | Path |
|------|---------------|------|
| Daily | `templates/vault/notes/template.vault-daily.md` | `daily/DATE.md` |
| Session | `templates/vault/notes/template.vault-session.md` | `sessions/SLUG.md` |
| Decision | `templates/vault/notes/template.vault-decision.md` | `decisions/SLUG.md` |
| Project | `templates/vault/notes/template.vault-project.md` | `projects/SLUG.md` |

Placeholders: [templates/vault/README.md](../../templates/vault/README.md).

## Session note

Path: `vault/sessions/<slug>.md` — use **`template.vault-session.md`** (`SLUG`, `TITLE`, `PROJECT`, `CREATED`, `UPDATED`).

Sections: **Context**, **WhatChanged**, **Decisions**, **FollowUps**. Link ADRs with `[[decisions/slug]]`.

## Gitignore note

`vault/**` is gitignored — **do not** directory `Grep` on `vault/` note folders. Use `Read`/`Write` on resolved paths; recall uses `grep-vault` or per-file `Grep` ([vault-recall/reference.md](../vault-recall/reference.md)).

## Dedupe (agent-only)

1. `Read` resolved `.../vault/_agent/manifest.json`
2. Match `id` or slug in `path` (`sessions/<slug>.md`)
3. `Grep` `title:` in `vault/sessions/` if ambiguous
4. Merge into existing file — do not create duplicate slug

## Manifest v2 (file: `vault/_agent/manifest.json`)

```json
{
  "schema_version": 2,
  "updated_at": "ISO8601",
  "docs": []
}
```

Each doc entry (upsert by `id`):

```json
{
  "id": "sess-<topic-slug>",
  "path": "sessions/<topic-slug>.md",
  "title": "<title>",
  "tier": "episodic",
  "project": "<project>",
  "status": "active",
  "updated": "YYYY-MM-DD",
  "tags": []
}
```

Set manifest `updated_at` to ISO8601. Tier: `semantic` for `decisions/`/`projects/`, `episodic` for `sessions/`.

**Required:** every upsert includes `"tags": []` or a string array — omitting `tags` breaks `/vault-recall` shortlist consistency.

---

## Daily file (not vault-capture)

**SSoT:** [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) (create + append bullets) · [`vault-daily/reference.md`](../vault-daily/reference.md) (triage, promote, สรุปส่งรายงาน).

**`/vault-capture`** does not auto-create daily — optional `## Promoted` wikilink only when `vault/daily/<today>.md` exists.

---

## Integration with pack skills

| Skill | Integration | Vault skill | Notes |
|-------|-------------|-------------|-------|
| `/debug` | **full** | capture, daily | After verified fix — condensed memory or end-of-day triage |
| `/fix-record` | **full** | recall, capture | RCA is canonical; vault stores short recall summary only |
| `/scrutinize` | **full** | recall, capture | Recall before architecture/policy verdict |
| `/builder-feature` | **full** | capture, daily | After `PLAN_READY` — ADR to `vault/decisions/` |
| `/builder-schema` | **light** | recall, capture | Before destructive migration; durable schema decision |
| `/builder-api` | **light** | recall, capture | Before contract break; ADR after slice verify |
| `/builder-infrastructure` | **light** | capture | Runbook / infra decision after verify |
| `/builder-ui` | **autolog** | daily only | After verify → [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc); `/vault-daily` for triage only |
| `/git-push` | **none** | — | `vault/**` gitignored; no memory handoff |
| `/upgrade-ai` | **none** | — | Meta skill — no app memory |
| `/vault-capture` | — | — | Destination; infer project + hub ensure + manifest upsert |
| `/vault-recall` | — | — | Read path; cite sources |
| `/vault-daily` | — | — | Ephemeral tier; triage before promote; session/decision promote runs infer project + hub ensure |

**Anti-duplication:** `/fix-record` owns full RCA. `/vault-capture` owns episodic or decision notes — link, do not copy.

### Frontmatter when sourced from `/fix-record`

Start from **`template.vault-session.md`** — add to frontmatter:

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

Use **`template.vault-decision.md`** — add `intent: keep_decision` to frontmatter when promoting from `/vault-daily`.

Path: `vault/decisions/<slug>.md` (one topic per file).

### Project note

Path: `vault/projects/<slug>.md` — use **`template.vault-project.md`**.

Sections: **Overview**, **Goals**, **Status** (table), **Links**. Manifest: `id: proj-<slug>`, `tier: semantic`.

Used by `/vault-daily` promote (`keep_project`), explicit `/vault-capture` tier `projects`, and **auto-ensure** after session/decision capture (below).

---

## Infer project (agent — mandatory for sessions/decisions)

Before writing a session or decision note, agent **infers** the `project` slug — user does not need to name `api` / `web` / `app` each time.

### Signals (combine; no fixed single order)

| Signal | Example |
|--------|---------|
| Patched paths in turn | `api/src/auth.ts` → `api`; `web/desktop/` → `web` |
| Git root / cwd | Repo folder name of work being captured |
| Conversation topic | "debug mobile login" → `app` |
| Manifest hubs | Existing `proj-api` + work clearly in api |
| Dedupe merge | Keep existing frontmatter `project` |
| Workspace folder | Root folder name as hint only |

### Slug rules

- kebab-case, short (`api`, `web`, `app`)
- No spaces
- Monorepo: sub-area when clear (e.g. `web-desktop` from `web/desktop/`)

### When to ask user

Ask **once** only when two candidates tie **or** no signals exist (explain-only capture with no patch paths).

### Transparency

SKILL REPORT must include: `Inferred project: <slug> (<one-line reason>)`.

---

## Project hub auto-ensure (mandatory after sessions/decisions)

After primary note write + manifest upsert, **always** run hub ensure when tier is `sessions/` or `decisions/`. Skip when tier is `projects/` (note is the hub).

### Algorithm

```
hubPath = vault/projects/<project>.md
primaryWikilink = [[sessions/<slug>]] or [[decisions/<slug>]]

IF hub file missing:
  Read templates/vault/notes/template.vault-project.md
  Replace SLUG, TITLE, PROJECT, CREATED, UPDATED (today YYYY-MM-DD)
  Overview = one sentence from capture context
  Links = - primaryWikilink
  Write hubPath
  hubAction = created
ELSE:
  Read hubPath
  IF ## Links lacks primaryWikilink line:
    Append "- primaryWikilink" under ## Links
  hubAction = updated

Read primary note
IF Context lacks [[projects/<project>]]:
  Append "Hub: [[projects/<project>]]" at end of ## Context section

IF vault/daily/<today>.md exists:
  Read daily
  IF ## Promoted lacks [[projects/<project>]] or primary wikilink:
    Append missing wikilinks under ## Promoted

Upsert manifest proj-<project>:
  path: projects/<project>.md
  tier: semantic
  project: <project>
  tags: [] or [project]
  updated: today

Report hubAction + inferred project
```

### Merge rules (never overwrite wholesale)

| File | Rule |
|------|------|
| Hub new | From template; Goals/Status may stay empty |
| Hub existing | Append `## Links` lines only |
| Primary | Append hub backlink in Context only |
| Daily | Append `## Promoted` wikilinks only if file exists |
| Manifest | Upsert by `id`; `tags` required on every entry |

### Multi-repo

One shared vault; separate hubs per inferred project (`projects/api.md`, `projects/web.md`, `projects/app.md`). First capture for a project creates its hub automatically.

**Do not** run `append-daily` in capture — daily bullets stay with autolog / `/vault-daily`.

---

## Close-out verification gate

Before STATUS=READY (verification-before-completion — IDENTIFY → RUN → READ):

| Step | Action |
|------|--------|
| 1 IDENTIFY | Primary path, hub path (`created`/`updated`), manifest ids touched |
| 2 RUN | Dedupe passed; frontmatter includes `tags`; hub ensure completed; manifest upsert |
| 3 READ | SKILL REPORT lists `Inferred project: <slug> (<reason>)` + all paths touched |
| 4 AUTOLOG | **Skip** — capture does not own daily bullets; autolog / `/vault-daily` only |
