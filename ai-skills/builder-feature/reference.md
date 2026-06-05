# builder-feature — reference

## Workflow (detail)

Load this section when executing a phase. Run phases **in order**.

### 0) Discovery gate (required before phase 1)

Goal: prevent "jump to implementation" when scope is still ambiguous.

Required outputs before phase 1:

- Scope lock: exact files/surfaces to touch in this run
- Explicit non-goals: what this run will NOT change
- Path choice:
  - **UI-only** (single-screen/static/mock): hand off to `/builder-ui`
  - **Cross-layer** (UI+API/schema/infra): continue with full orchestration

If these are missing, set status to **BLOCKED** and ask targeted clarifying questions first.

### 1) Workflow analysis

Analyze user actions, success path, async flows/retries, permissions, rollback/failure scenarios, cross-system dependencies.

Output: workflow map, failure scenarios, dependency analysis.

### 2) Existing system analysis

Inspect current features, shared APIs/schemas, infra capabilities, reusable patterns. Reuse vs create? Ownership conflicts?

Output: reuse opportunities, duplication risks, extension constraints.

### 3) Feature boundary design

Define feature boundary, shared vs local modules, ownership zones, integration surfaces.

Output: boundary map, ownership map.

### 4) Specialist delegation

Delegate to `/builder-ui`, `/builder-api`, `/builder-schema`, `/builder-infrastructure` as needed.

Output: delegated task map, ownership matrix, sequencing plan.

### 5) State + integration coordination

Coordinate frontend vs server state, async updates, cache invalidation, optimistic updates and failure reconciliation.

Output: integration map, state ownership plan.

### 6) Rollout + reliability coordination

Plan feature flags, staged rollout, rollback, monitoring, migration/deployment safety, incident hooks.

Output: rollout plan, operational readiness assessment.

### 7) Cross-layer verification

Verify workflow continuity, reuse, ownership, integration, permissions, async reliability, observability, rollback. Use `/scrutinize` before merge.

Reject if: unclear ownership, duplicated systems, excessive coupling, rollback impossible, incomplete observability.

### 8) Execution handoff (plan -> execution)

After phase 7, do NOT continue as an implicit implementation step. Choose one explicit path:

1. **Specialist execution mode (default)**:
   - delegate slices to `/builder-ui`, `/builder-api`, `/builder-schema`, `/builder-infrastructure`
   - keep slice boundaries explicit (owner + sequence)
2. **UI-only fast path**:
   - if scope is static/mock/single-layer, hand off directly to `/builder-ui`
3. **Ship mode**:
   - after verification pass, hand off to `/git-push`

Output in SKILL REPORT `NEXT ACTIONS` must state exactly which path was chosen.

---

## Incremental vertical slices

From [addyosmani/incremental-implementation](https://github.com/addyosmani/agent-skills) — prefer thin end-to-end slices over horizontal layers-only:

| Slice | Deliver |
|-------|---------|
| 1 | Smallest user-visible path through UI → API → persistence (or infra stub) |
| 2 | Test + verify slice before expanding scope |
| 3 | Feature flag / safe default for partial rollout |
| 4 | Next slice — do not batch unrelated layers in one PR |

Delegate each slice to specialists; `/scrutinize` per slice before merge.

---

## Delegation quality checklist

- Are responsibilities mapped to the right specialist?
- Any specialist overlap or duplicated ownership?
- Is sequencing explicit and dependency-aware?

## Reuse checklist

- Existing module/service reused where possible?
- Extension path evaluated before new build?
- Shared contracts preserved?

## Integration risk checklist

- Async flows and retries explicit?
- Cache invalidation behavior defined?
- Rollback behavior safe across layers?
- Permission boundaries consistent end-to-end?

## Anti-patterns

- builder-feature doing specialist implementation itself
- giant cross-layer feature module
- hidden dependencies between layers
- fragmented state ownership
- rollout without monitoring/rollback

## Anti-rationalization table

| Rationalization | Why it fails | Required response |
|---|---|---|
| "งานเล็ก แค่ HTML ไม่ต้องวาง flow" | small UI still changes user workflow and navigation expectations | phase 0 scope lock + 3-5 step workflow map |
| "เดี๋ยวค่อยถามทีหลัง ระหว่างเขียน" | implementation-first hides wrong assumptions and causes rework | block and clarify first; then choose UI-only or cross-layer path |
| "builder-feature ทำเองทีเดียวเร็วกว่า" | violates ownership; increases coupling and regression risk | delegate to specialist skills per layer |
| "ข้าม verify ก่อน เดี๋ยวค่อย review" | missing proof encourages false-ready status | pass phase 7 gate (`/scrutinize`) before handoff/ship |

---

## Close-out verification gate (phases 0-8)

Before final artifact:

| # | Check |
|---|--------|
| 1 | All required phases (0-8) delivered or explicitly deferred |
| 2 | Each specialist slice has owner + sequencing |
| 3 | `/scrutinize` planned per slice before merge |
| 4 | Rollback + monitoring stated — not TBD |
| 5 | Reuse checklist passed — no duplicate systems |
| 6 | **Callee redirect cleanup** — each implementation slice greps orphans from redirected callers ([`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc)) |

IDENTIFY proof: integration test or walkthrough script · RUN in session · cite result.
