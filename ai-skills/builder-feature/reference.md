# builder-feature — reference

Depth is split for token efficiency — load sub-files on demand.

| Topic | File |
|-------|------|
| Design reasoning (goal, hypotheses, hierarchy, constraints) | [reference-design-reasoning.md](./reference-design-reasoning.md) |
| Workflow map · UI-only express · phases 0–8 | [reference-workflow.md](./reference-workflow.md) |
| Slice backlog · slice brief · close-out · anti-rationalization | [reference-slice-handoff.md](./reference-slice-handoff.md) |

---

## Plan-only gate (hard stop)

This skill is **design and orchestration only**. Implementation belongs to specialist skills.

### Allowed tools / actions

| Action | Purpose |
|--------|---------|
| Read, grep, semantic search | Trace existing flows, find reuse |
| List dirs, read configs (read-only) | Boundary and ownership analysis |
| **Plan file** write/update | `CreatePlan` or **Write** `.cursor/plans/<slug>.plan.md` per [`template.feature-plan.md`](../../templates/template.feature-plan.md) |
| Chat summary | SKILL REPORT pointers to plan path — not full plan duplicate |

### Forbidden while `/builder-feature` is active

| Forbidden | Why |
|-----------|-----|
| Write / StrReplace / patch **application** source | Violates orchestrator role |
| Create new components, routes, migrations in app repos | Specialist + approved slice |
| "Temporary scaffold" or "example code" in repo | Becomes dead code; bypasses plan |
| Continue coding after workflow map "looks fine" | Phase 1–7 must complete first |
| STATUS=PLAN_READY with any app diff in session | Plan-only close-out |
| Plan file **only** under `docs/plans/` (no `.cursor/plans/` copy) | Plan UI won't bind — see § Plan path resolution |

### When user demands code immediately

1. If scope is **one layer** → say: use `/builder-ui` (or matching specialist) — exit `/builder-feature`.
2. If **cross-layer** → run phases 0–7 at minimum viable depth → emit slice 1 brief → **stop** → user invokes owner skill.
3. Do **not** interpret urgency as permission to patch in this skill.

---

## Plan mode alignment

Aligns `/builder-feature` with Cursor **Plan mode**: durable `*.plan.md` artifact, explicit lifecycle, iteration vs execution.

**SSoT:** [`templates/template.feature-plan.md`](../../templates/template.feature-plan.md)

### Plan path resolution (P0 — read before Write)

Cursor **Plan UI** binds to `.cursor/plans/*.plan.md`, not `docs/plans/`. Agent mode often lacks `CreatePlan` — **always Write the canonical path**.

| Priority | When | Path / action |
|----------|------|----------------|
| **1** | `CreatePlan` tool available | Use it → `.cursor/plans/<feature-slug>.plan.md` |
| **2** | Cursor Agent mode (default) | **Write** `.cursor/plans/<feature-slug>.plan.md` at **workspace root** (create `.cursor/plans/` if missing) |
| **3** | User asks durable/git copy (`commit plan`, `docs/plans`) | Mirror same content to `docs/plans/<slug>.plan.md` **after** step 1 or 2 |
| **4** | Non-Cursor host | Chat summary + optional `docs/plans/` only if user approves |

**Iron law:** `docs/plans/` alone is **not** a valid close-out for Cursor — SKILL REPORT `ARTIFACTS` must cite `.cursor/plans/<slug>.plan.md`.

Slug: kebab-case from feature name; match frontmatter `name:`.

Do **not** commit `.cursor/plans/` to app repos unless the team explicitly wants plan docs in git.

### Artifact paths (summary)

| Host | Primary path |
|------|----------------|
| Cursor (all modes) | `.cursor/plans/<feature-slug>.plan.md` |
| Optional mirror | `docs/plans/<slug>.plan.md` — user-requested only |

### Phase → plan section map

| Phase | Plan body section |
|-------|-------------------|
| 0 | `## Phase 0 — Scope and goal` |
| 1 | `## Phase 1 — Workflow map` |
| 2 | `## Phase 2 — Existing systems` |
| 3 | `## Phase 3 — Boundaries` |
| 4 | `## Phase 4 — Delegation` |
| 5 | `## Phase 5 — State and integration` |
| 6 | `## Phase 6 — Rollout and reliability` |
| 7 | `## Phase 7 — Plan verification` |
| Backlog | frontmatter `todos` + `## Slice backlog` (same ids) |

Each todo: `id`, `content`, `owner` (`builder-ui` | `builder-api` | …), `status`.

### Plan `status` ↔ SKILL REPORT

| Plan `status` | SKILL REPORT STATUS |
|---------------|---------------------|
| `draft` | IN_PROGRESS |
| `plan_ready` | PLAN_READY |
| `cancelled` | CANCELLED |
| `executing` | Hand off — owner skill owns session |

### Plan iteration vs execution

| User says | Agent does | App code? |
|-----------|------------|-----------|
| Refine scope, alternative design, "ใช้ X แทน Y" | Update plan file only | **No** |
| `ยกเลิกแผน` / cancel | `status: cancelled`; todos → `cancelled` | **No** |
| Approve plan (`ยืนยัน`, `ok`, `looks good`) | Keep `plan_ready`; NEXT ACTIONS = pick slice | **No** |
| `slice N go` / `execute plan` / `implement slice N` (explicit) | Slice brief → invoke owner skill | **Owner skill** |
| `ทำเลย` / urgent without confirm | Cross-layer: minimum phases 0–1 + slice 1 brief → **stop** (owner skill implements). UI-only + no plan: exit → `/builder-ui`. UI-only + `ui-only-express`: finish express plan first — **not** implement in builder-feature | **Not builder-feature** (owner skill or express plan only) |

**Ambiguity rule:** If unclear whether user iterates or executes → treat as **iteration** (update plan only).

### Present plan gate

Before `plan_ready`:

1. Plan file complete (phases 0–7 or express deferrals documented)
2. Present summary in chat — link plan path; do not paste full plan body
3. **Await user confirm** or revision (same as Plan mode)
4. On confirm → `status: plan_ready` → recommend slice 1

### Express lane + plan file

Express lane still emits a **short plan file** (scope, workflow map ≥3 steps, Phase 2 UI hypotheses, component outline, 1–4 todos). Defer phases **4–6** as N/A in body. Detail: [reference-workflow.md](./reference-workflow.md) § UI-only express lane.
