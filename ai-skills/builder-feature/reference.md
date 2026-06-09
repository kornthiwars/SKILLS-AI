# builder-feature — reference

## Plan-only gate (hard stop)

This skill is **design and orchestration only**. Implementation belongs to specialist skills.

### Allowed tools / actions

| Action | Purpose |
|--------|---------|
| Read, grep, semantic search | Trace existing flows, find reuse |
| List dirs, read configs (read-only) | Boundary and ownership analysis |
| Chat artifacts | Workflow map, tables, slice backlog, mermaid |

### Forbidden while `/builder-feature` is active

| Forbidden | Why |
|-----------|-----|
| Write / StrReplace / patch app source | Violates orchestrator role |
| Create new components, routes, migrations | Specialist + approved slice |
| "Temporary scaffold" or "example code" in repo | Becomes dead code; bypasses plan |
| Continue coding after workflow map "looks fine" | Phase 1–7 must complete first |
| STATUS=PLAN_READY with any app diff in session | Plan-only close-out |

### When user demands code immediately

1. If scope is **one layer** → say: use `/builder-ui` (or matching specialist) — exit `/builder-feature`.
2. If **cross-layer** → run phases 0–7 at minimum viable depth → emit slice 1 brief → **stop** → user invokes owner skill.
3. Do **not** interpret urgency as permission to patch in this skill.

---

## Workflow map (phase 1 — mandatory)

Do **not** produce slice backlog until workflow map exists in DISCOVERIES/ARTIFACTS.

### Minimum format

Number every step the **user** takes (not file names first):

```markdown
## Workflow map

| Step | User action | System response | Failure branch |
|------|-------------|-----------------|----------------|
| 1 | … | … | … |
| 2 | … | … | … |

### Async / permissions
- …

### Out of scope (this feature)
- …
```

### Flow check (before phase 2)

| # | Question | Pass |
|---|----------|------|
| 1 | Happy path end-to-end in ≤7 steps? | Yes |
| 2 | Each failure branch has user-visible outcome? | Yes |
| 3 | Auth / permission gates named? | Yes or N/A |
| 4 | Rollback or undo path stated? | Yes or explicit gap |

If any fail → stay in phase 1; do not hand off or plan slices.

---

## UI-only express lane

Use when phase 0 path = **UI-only** (mock, screenshot, static HTML, single marketing page) — including user saying "ทำ html" on `/builder-feature`.

**Still plan-only — no repo edits.**

### Minimum deliverables (before PLAN_READY)

| # | Artifact | Minimum |
|---|----------|---------|
| 1 | Scope + non-goals | In SKILL REPORT |
| 2 | **Workflow map** | ≥3 user steps + failure branch on primary path |
| 3 | **Visual / component outline** | Hierarchy or component tree (table or mermaid — not code) |
| 4 | **Slice backlog** | 1–4 rows with owner `/builder-ui` + verify per row |

### Phases to defer (mark explicit N/A)

| Phase | Express lane |
|-------|----------------|
| 2 Existing systems | Brief reuse grep only — or "greenfield" |
| 3 Boundaries | UI folder / page scope only |
| 4–6 Integration, rollout, infra | **Deferred — N/A static mock** (state in ARTIFACTS) |
| 7 Plan verification | Short pass: workflow complete? slices ordered? |

### Express anti-patterns

- Skipping workflow map ("it's just HTML")
- Writing `index.html` in builder-feature
- Full phases 2–6 with fake TBD rollout for a static page

After PLAN_READY → slice 1 brief → **`/builder-ui slice 1 go`** → end turn.

---

## Workflow (detail)

Run phases **in order**. No application patches in any phase.

### 0) Discovery gate

Required before phase 1:

- Scope lock: surfaces in scope (not files to edit yet)
- Non-goals
- Path choice:
  - **UI-only** → hand off to `/builder-ui` (orchestrator exits; specialist may plan+implement)
  - **Cross-layer** → continue phases 1–7 here

Missing → STATUS **BLOCKED**.

### 1) Workflow analysis

Output: **workflow map** (format above), failure scenarios, dependencies.

### 2) Existing system analysis

Output: reuse opportunities, duplication risks, extension constraints.

### 3) Feature boundary design

Output: boundary map, ownership map.

### 4) Specialist delegation

Output: task map, ownership matrix, sequencing — **who implements**, not code.

### 5) State + integration coordination

Output: integration map, state ownership plan.

### 6) Rollout + reliability

Output: rollout plan, flags, rollback, monitoring.

### 7) Plan verification (not code review)

Verify the **plan** — not implemented diffs:

| Check | Reject plan if |
|-------|----------------|
| Workflow continuity | Gaps between steps |
| Ownership | Two owners for same concern |
| Integration | Async/cache undefined |
| Rollback | Impossible or TBD |
| Observability | No signals for new paths |

`/scrutinize` runs on **implemented** slice PRs — not on this plan-only close-out.

### 8) Slice backlog + handoff (end of skill)

After phase 7 → build **slice backlog** → STATUS **PLAN_READY** → recommend slice 1 owner → **end turn**.

Do not implement slice 1 in this skill.

---

## Slice backlog (required artifact)

From [addyosmani/incremental-implementation](https://github.com/addyosmani/agent-skills) — thin vertical slices, one at a time:

| Slice | User-visible outcome | Owner skill | Depends | Verify (command / walkthrough) |
|-------|----------------------|-------------|---------|------------------------------|
| 1 | Smallest path UI→API→data (or stub) | `/builder-ui` + … | — | … |
| 2 | … | … | 1 | … |

Rules:

- One slice per specialist invocation unless user explicitly batches with approval
- Each slice: verify before next slice
- `/scrutinize` before merge per slice
- No unrelated layers in one slice

### Slice brief (handoff payload)

When user approves slice N, emit the block from [`templates/template.slice-brief.md`](../../templates/template.slice-brief.md) — required fields: **Outcome**, **Non-goals**, **Verify**, **Owner**.

Do not invent a alternate brief shape; owner skills parse this contract ([`builder-ui/reference.md`](../builder-ui/reference.md) § Slice brief intake).

---

## Plan persistence (optional on PLAN_READY)

Plans survive chat loss when written under **`vault/workday/plans/`** (local, gitignored like other workday content).

### When to persist

| Trigger | Action |
|---------|--------|
| PLAN_READY close-out | **Offer** in NEXT ACTIONS: "Save plan to vault?" |
| User says save / remember / เก็บแผน | Write plan file |
| Active `vault/workday/YYYY-MM-DD.md` exists | Offer persist + suggest `+` line in **DISCOVERED TODAY** on next `/workday-update` |

Do **not** auto-write vault on every plan unless user opts in or same-session workday is active.

### Resolve directory

Same workday root as [`workday-init/reference.md`](../workday-init/reference.md) § Persistence → `{workday}/plans/`.

Create `plans/` if missing.

### Write protocol

1. Derive **`feature_slug`** — kebab-case from feature name (`Maxwell Plans` → `maxwell-plans`).
2. Load [`templates/template.feature-plan.md`](../../templates/template.feature-plan.md):
   - Replace `{{YYYY-MM-DD}}`, `{{FEATURE_NAME}}`, `{{FEATURE_SLUG}}`, `{{OWNER_SKILL}}` (slice 1 owner).
   - Paste workflow map, component outline, slice backlog table into template sections.
3. Write UTF-8 to `vault/workday/plans/{feature_slug}.md` (overwrite same slug same day if re-plan).
4. Report **absolute or workspace-relative path** in chat.
5. Slice briefs should cite **Plan ref:** path in `template.slice-brief.md` block.
6. Recall saved plans via [`/vault-recall`](../vault-recall/SKILL.md) — grep `workday/plans/` per [`vault-recall/reference.md`](../vault-recall/reference.md).

### Workday cross-link (optional)

If user uses WORKDAY same day, suggest appending to **DISCOVERED TODAY**:

`+ {DOMAIN}-{NNN} feature plan — source: /builder-feature — vault/workday/plans/{feature_slug}.md`

Do **not** put **plan artifacts** in `vault/issues/` or `vault/wiki/` — use **`vault/workday/plans/{feature_slug}.md`** (opt-in persist) per § Plan persistence above.

Session Q&A during planning may still log to `issues/` per [`vault-issues.mdc`](../../ai-rules/vault-issues.mdc) when the turn is work-related. Wiki auto-ingest skips feature plans — gate #6 in [`wiki-ingest/reference.md`](../wiki-ingest/reference.md).

---

## Incremental vertical slices

| Slice | Deliver |
|-------|---------|
| 1 | Smallest user-visible path through UI → API → persistence (or infra stub) |
| 2 | Test + verify slice before expanding scope |
| 3 | Feature flag / safe default for partial rollout |
| 4 | Next slice — do not batch unrelated layers in one PR |

Implementation: **owner skill only** — not builder-feature.

---

## Delegation quality checklist

- Responsibilities mapped to the right specialist?
- No overlap or duplicated ownership?
- Sequencing explicit and dependency-aware?

## Reuse checklist

- Existing module reused where possible?
- Extension before new build?
- Shared contracts preserved?

## Integration risk checklist

- Async flows and retries explicit?
- Cache invalidation defined?
- Rollback safe across layers?
- Permissions consistent end-to-end?

## Anti-patterns

- builder-feature patching source (any layer)
- slice backlog before workflow map
- coding in same turn as plan close-out
- giant cross-layer module in one slice
- rollout without monitoring/rollback

## Anti-rationalization table

| Rationalization | Why it fails | Required response |
|---|---|---|
| "งานเล็ก แค่ HTML ไม่ต้องวาง flow" | UX and navigation still change | workflow map + phase 0 |
| "เดี๋ยวค่อยถามทีหลัง ระหว่างเขียน" | wrong assumptions | BLOCK; plan first |
| "builder-feature ทำเองทีเดียวเร็วกว่า" | ownership violation | slice brief → specialist |
| "ข้าม verify ก่อน เดี๋ยวค่อย review" | false-ready | phase 7 plan gate |
| "user said ทำเลย — ข้าม plan" | rework cost | minimum phases 0–1 + slice 1 brief OR hand off UI-only specialist |
| " scaffold ไว้ก่อน จะได้เห็นภาพ" | plan-only skill | mermaid/table only — no repo edits |
| "flow ชัดแล้ว เขียนเลย" | phase 2–7 skipped | complete plan or explicit defer with gaps listed |

---

## Plan close-out gate (phases 0–7 + backlog)

Before STATUS **PLAN_READY**:

| # | Check |
|---|--------|
| 1 | **Workflow map** in ARTIFACTS — not skipped |
| 2 | Phases 0–7 delivered or explicitly deferred with gaps |
| 3 | **Slice backlog** table with owner + verify per row |
| 4 | Rollback + monitoring stated — not TBD |
| 5 | Reuse checklist passed |
| 6 | **Zero application file edits** in this session under this skill |
| 7 | NEXT ACTIONS = user picks slice → invoke owner skill · **offer** plan persist per [reference.md](./reference.md) § Plan persistence |

Do **not** require integration test RUN at plan close-out — that happens after specialist implements slice N.

Implementation slices: callee grep per [`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc) in **owner skill** close-out, not here.

---

## Execute close-out (owner skills — reminder)

After `/builder-ui`, `/builder-api`, etc. implement a slice:

- IDENTIFY verify command · RUN in session · READ output
- `/scrutinize` before merge
- Next slice only after verify pass

builder-feature does not re-run for execute unless user re-invokes for **plan revision**.
