# builder-feature — workflow

## Workflow map (phase 1 — mandatory)

Do **not** produce slice backlog until workflow map exists in the **plan file** (Phase 1 section) and DISCOVERIES.

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

Use when phase 0 `Path: ui-only-express` (mock, screenshot, static HTML, single marketing page) — including user saying "ทำ html" on `/builder-feature`. **Still plan-only — no repo edits.** Stay in builder-feature; do not exit to `/builder-ui` until `slice N go`.

### Minimum deliverables (before PLAN_READY)

| # | Artifact | Minimum | Lens |
|---|----------|---------|------|
| 1 | Scope + **goal** + constraints | Plan file Phase 0 | Goal-driven, Constraints |
| 2 | **Workflow map** | Phase 1 — ≥3 user steps + failure branch | Goal-driven |
| 3 | **Approach hypotheses** | Phase 2 — 2 UI options, pick one | Hypothesis |
| 4 | **Component outline** | Phase 3 — hierarchy / mermaid | Hierarchy |
| 5 | **Slice backlog** | Plan `todos` — 1–4 rows, owner `/builder-ui` + verify | Consistency |
| 6 | **Recursive review** | Phase 7 short pass | Recursive verification |

### Phases to defer (mark explicit N/A)

| Phase | Express lane |
|-------|----------------|
| 4–6 Delegation, integration, rollout | **Deferred — N/A static mock** (state in ARTIFACTS) |

### Express anti-patterns

- Skipping workflow map ("it's just HTML")
- Writing `index.html` in builder-feature
- Full phases 2–6 with fake TBD rollout for a static page

After `plan_ready` → slice 1 brief → **`/builder-ui slice 1 go`** → end turn.

---

## Workflow (detail)

Run phases **in order**. No application patches in any phase.

### 0) Discovery gate

Required before phase 1:

- **Goal** — one user-visible outcome sentence (`**Goal:**` in plan)
- **Constraints** table (budget, timeline, stack, permissions — mark N/A where none)
- Scope lock: surfaces in scope (not files to edit yet)
- Non-goals
- Gap analysis: current state vs goal (brief)
- Path choice (set `Path:` in plan Phase 0):
  - **`ui-only-express`** → continue here — express lane (§ UI-only express lane)
  - **`cross-layer`** → continue phases 1–7 here
  - **UI-only, user wants code now** (no plan) → hand off to `/builder-ui` — exit `/builder-feature`

Missing → STATUS **BLOCKED**.

### 1) Workflow analysis

Output: **workflow map** (format above), failure scenarios, dependencies — steps that close the **goal gap**.

### 2) Existing system analysis

Output:

- **Approach hypotheses** table (≥2 options, evidence, one **chosen**)
- **Hierarchical** layer notes (infra → API → app → UI)
- Reuse opportunities, duplication risks, extension constraints

Do **not** produce slice backlog until hypothesis **chosen**.

### 3) Feature boundary design

Output: boundary map, ownership map — scoped to **chosen** approach and layers.

### 4) Specialist delegation

Output: task map, ownership matrix, sequencing — **who implements**, not code.

### 5) State + integration coordination

Output: integration map, state ownership plan.

### 6) Rollout + reliability

Output: rollout plan, flags, rollback, monitoring — **re-check constraints table**.

### 7) Plan verification (not code review)

Verify the **plan** — not implemented diffs. Use [reference-design-reasoning.md](./reference-design-reasoning.md) lens 6 (recursive verification) + plan Phase 7 table in [`template.feature-plan.md`](../../templates/template.feature-plan.md). Reject if contradictions unresolved, chosen hypothesis mixed in backlog, or hard constraints violated.

`/scrutinize` runs on **implemented** slice PRs — not on plan-only close-out.

### 8) Slice backlog + handoff (end of skill)

After phase 7 → sync **slice backlog** to plan `todos` → `status: plan_ready` (STATUS **PLAN_READY**) → present gate → **end turn**.

Do not implement slice 1 in this skill.

Back: [reference.md](./reference.md) · Design reasoning: [reference-design-reasoning.md](./reference-design-reasoning.md) · Slice handoff: [reference-slice-handoff.md](./reference-slice-handoff.md)
