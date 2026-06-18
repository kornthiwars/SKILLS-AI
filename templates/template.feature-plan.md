# Feature plan — pack output contract

Durable plan artifact from **`/builder-feature`**. Binds Cursor **Plan UI** when written to `.cursor/plans/<feature-slug>.plan.md`.

**SSoT for close-out gate.** Workflow depth: [`reference-design-reasoning.md`](../ai-skills/builder-feature/reference-design-reasoning.md) · [`reference.md`](../ai-skills/builder-feature/reference.md) § Plan path resolution · [`reference-workflow.md`](../ai-skills/builder-feature/reference-workflow.md) · [`template.slice-brief.md`](./template.slice-brief.md)

**P0 path:** `CreatePlan` → else **Write** `.cursor/plans/<slug>.plan.md` — never `docs/plans/` alone. `overview` = Phase 0 **Goal**. Slug = kebab-case = frontmatter `name:`.

---

## Emit this file (canonical skeleton)

Agent: fill placeholders; delete hint lines; set `status: plan_ready` only after [Close-out gate](#close-out-gate).

```markdown
---
name: FEATURE_SLUG
status: draft
overview: ONE_LINE_USER_VISIBLE_SUMMARY
todos:
  - id: s1-short-slug
    content: "Slice 1 — user-visible outcome (owner: builder-ui)"
    owner: builder-ui
    status: pending
  - id: s2-short-slug
    content: "Slice 2 — …"
    owner: builder-api
    status: pending
isProject: false
---

# FEATURE_TITLE

## Phase 0 — Scope and goal

**Goal:** ONE user-visible outcome sentence (must match frontmatter `overview`)

**Requirements:**
- …

**Gap analysis (today vs goal):**
- …

**Constraints:**

| Constraint | Value | Hard / soft |
|------------|-------|-------------|
| Patch budget | files / lines or N/A | hard |
| Timeline | … or N/A | … |
| Stack | must reuse … | hard |
| Permissions / compliance | … or N/A | hard |
| Performance | … or N/A | soft |

**In scope:**
- …

**Non-goals:**
- …

**Path:** cross-layer | ui-only-express

**Root cause / trigger (if bugfix or perf):** … or —

---

## Phase 1 — Workflow map

| Step | User action | System response | Failure branch |
|------|-------------|-----------------|----------------|
| 1 | … | … | … |
| 2 | … | … | … |

### Async / permissions
- …

### Out of scope (this feature)
- …

### Flow check (must pass before Phase 2)

| # | Question | Pass |
|---|----------|------|
| 1 | Happy path ≤7 user steps? | Yes / No |
| 2 | Each failure branch has user-visible outcome? | Yes / No |
| 3 | Auth / permission gates named? | Yes / N/A |
| 4 | Rollback or undo stated? | Yes / gap noted |

---

## Phase 2 — Existing systems

### Approach hypotheses (≥2 before chosen design)

| ID | Approach | Pros | Cons | Evidence | Status |
|----|----------|------|------|----------|--------|
| A | … | … | … | grep / read | candidate / eliminated / **chosen** |
| B | … | … | … | … | eliminated |

**Chosen:** ID … — rationale one line

### Hierarchical layers (top-down)

| Layer | Notes for this feature |
|-------|------------------------|
| Infrastructure / ops | … or N/A |
| API / contracts | … |
| Application / domain | … |
| UI / UX | … |

### Reuse

| Asset | Reuse | Gap |
|-------|-------|-----|
| … | … | … |

---

## Phase 3 — Boundaries

| Concern | Module / owner |
|---------|----------------|
| … | … |

---

## Phase 4 — Delegation

| Concern | Owner skill |
|---------|-------------|
| … | `/builder-ui` \| `/builder-api` \| … |

---

## Phase 5 — State and integration

| State | Location | Notes |
|-------|----------|-------|
| … | … | … |

**API / events:** …

---

## Phase 6 — Rollout and reliability

| Item | Plan |
|------|------|
| Rollout | … |
| Rollback | … |
| Monitoring | … |

### Constraint re-check

| Constraint | Still satisfied? |
|------------|----------------|
| … | Yes / No — refine if No |

---

## Phase 7 — Plan verification

| Check | Pass |
|-------|------|
| Goal ↔ slices aligned | Yes / No |
| Chosen hypothesis only (no mixed approaches) | Yes / No |
| Hard constraints satisfied | Yes / No |
| Workflow continuity | Yes / No |
| Ownership clear (one owner per concern) | Yes / No |
| Delegation quality (reference § Plan quality checklists) | Yes / No / N/A express |
| Integration surfaces named | Yes / No |
| Rollback possible (not TBD) | Yes / No |
| Reuse checklist (reference § Plan quality checklists) | Yes / No |
| Integration risks addressed (async, cache, permissions) | Yes / No / N/A express |

### Recursive review

- **Contradictions found:** … or None
- **Refinements made:** … or —
- **Goal restated:** … (same as Phase 0 unless user revised scope)
- **Goal still satisfied:** Yes / No

---

## Slice backlog

| Slice | User-visible outcome | Owner | Depends | Verify |
|-------|---------------------|-------|---------|--------|
| 1 | … | `/builder-ui` | — | … |
| 2 | … | `/builder-api` | 1 | … |

**Recommended order:** …

**Ties to chosen approach:** ID …

---

## Slice N brief (preview — fill when user says `slice N go`)

**Outcome:** …

**Non-goals:** …

**Verify:** …

**Owner:** `/builder-*`

**Plan ref:** `.cursor/plans/FEATURE_SLUG.plan.md`
```

---

## Frontmatter rules

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | Same as filename slug |
| `status` | Yes | `draft` \| `plan_ready` \| `cancelled` \| `executing` |
| `overview` | Yes | One line — must match Phase 0 **Goal** |
| `todos` | Yes | Sync ids with Slice backlog; each: `id`, `content`, `owner`, `status` |
| `todos[].owner` | Yes | `builder-ui` \| `builder-api` \| `builder-schema` \| `builder-infrastructure` |
| `isProject` | Yes | Default `false` |

**Iron law:** no slice backlog until Phase 2 has exactly one **chosen** approach. Express lane + iteration rules: [reference-workflow.md](../ai-skills/builder-feature/reference-workflow.md) § UI-only express lane · [reference.md](../ai-skills/builder-feature/reference.md) § Plan iteration vs execution.

---

## Close-out gate

Before `status: plan_ready` and SKILL REPORT **PLAN_READY**:

| # | Check |
|---|--------|
| 1 | File at `.cursor/plans/<slug>.plan.md` |
| 2 | **Goal** + **constraints** in Phase 0; `overview` matches goal |
| 3 | Phase 1 workflow + flow check present |
| 4 | Phase 2 **approach hypotheses** — one **chosen** |
| 5 | Phases 0–7 or express deferrals documented (`Path: ui-only-express` → Phase 4–6 may be N/A) |
| 6 | Slice todos: `id`, `owner`, verify in `content` or backlog **Verify** column |
| 7 | Phase 7 **recursive review** subsection |
| 8 | Rollback + monitoring in Phase 6 — **or** Phase 6 N/A with reason when `Path: ui-only-express` |
| 9 | Zero application source edits in this `/builder-feature` run |
| 10 | User confirm gate presented in chat |
| 11 | NEXT ACTIONS = user picks slice → invoke owner skill (slice brief) |

Chat: link plan path — do not paste full body. Slice brief: [`template.slice-brief.md`](./template.slice-brief.md) — **Plan ref** must be `.cursor/plans/<slug>.plan.md`.
