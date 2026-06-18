# builder-feature — design reasoning

Built-in planning habits for feature design — **not** an external framework name. Apply the mental model; do not label plans or chat output with a product/framework trademark.

Goal-oriented feature planning: hypotheses before commitment, top-down layers, constraint satisfaction, context consistency across phases, recursive self-review before `plan_ready`.

**Mental model:**

```text
Goal → Hypotheses → Hierarchy → Constraints → Consistency → Self-review → plan_ready
```

## Map to phases

| # | Lens | Phase | Required in plan file |
|---|------|-------|------------------------|
| 1 | **Goal-driven** | 0, 1 | `**Goal:**` one sentence; requirements list; gap vs current state |
| 2 | **Hypothesis-based** | 2 | Approach table ≥2 rows before chosen design |
| 3 | **Hierarchical** | 2–3 | Layer stack top-down before file list |
| 4 | **Constraint satisfaction** | 0, 6 | Constraints table; Phase 6 re-check |
| 5 | **Long-chain consistency** | all | `overview` = goal; Phase 7 restates goal; SKILL REPORT ledger |
| 6 | **Recursive verification** | 7 | Contradictions + refinements before `plan_ready` |

## 1 — Goal-driven (phases 0–1)

```text
Goal → Requirements → Gap analysis → Solution direction (not implementation)
```

| Artifact | Minimum |
|----------|---------|
| `**Goal:**` | One user-visible outcome sentence |
| Requirements | Bullet list — what must be true when done |
| Gap analysis | What exists today vs goal (from grep/read) |
| Phase 1 workflow | Steps that close the gap |

**Anti-pattern:** Jump to slice backlog without stating goal and gap.

## 2 — Hypothesis-based (phase 2)

Before locking architecture or slice order, list **≥2** approaches.

| ID | Approach | Pros | Cons | Evidence | Status |
|----|----------|------|------|----------|--------|
| A | … | … | … | grep / prior art | candidate / eliminated / **chosen** |
| B | … | … | … | … | eliminated |

Rules:

- Collect evidence (read-only) before eliminating
- Mark **chosen** exactly one row before phase 3
- Re-open table if user changes scope mid-plan

SKILL REPORT mid-session: include **hypothesis table** in DISCOVERIES (same shape).

## 3 — Hierarchical (phases 2–3)

Analyze top-down — do not start at a single file or endpoint.

```text
System
├── Infrastructure / ops (if any)
├── API / contracts
├── Application / domain
└── UI / UX
```

| Layer | Question for this feature |
|-------|---------------------------|
| Infrastructure | Deploy, cron, env, observability? |
| API | New/changed endpoints, auth, pagination? |
| Application | Stores, services, shared modules? |
| UI | Screens, components, loading states? |

Phase 3 boundaries map concerns to layers **after** hypothesis chosen.

## 4 — Constraint satisfaction (phases 0, 6)

| Constraint | Example dimensions |
|------------|-------------------|
| Patch budget | files, lines ([`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc)) |
| Timeline | must ship in N slices |
| Stack | must reuse existing service/store patterns |
| Permissions / compliance | prod gates, no schema without approval |
| Performance | p95, payload size |

**Rule:** Slice backlog must not violate any **hard** constraint. Soft trade-offs → note in Phase 6.

Phase 6: re-read constraints table — if rollout plan breaks one, refine before `plan_ready`.

## 5 — Long-chain consistency

Across phases 0→7, preserve:

- Goal sentence (unchanged unless user revises scope)
- Eliminated hypotheses (do not resurrect without new evidence)
- Constraints (budget, non-goals)
- Chosen approach ID from phase 2

| Checkpoint | Action |
|------------|--------|
| Start phase N | Skim goal + constraints + chosen approach |
| Slice backlog | Each slice ties to goal + chosen approach |
| Phase 7 | Restate goal; confirm slices still satisfy it |
| SKILL REPORT | Ledger: phase outputs ruled in/out |

`overview` in frontmatter must match `**Goal:**` (one line).

## 6 — Recursive verification (phase 7)

```text
Draft plan → Review → Find contradictions → Refine → plan_ready
```

| Review question | Fail if |
|-----------------|--------|
| Slices implement **chosen** approach only? | Mixed A+B without note |
| Any slice violates constraints? | Yes |
| Workflow covers goal end-to-end? | Gap |
| Hypothesis eliminated but still in backlog? | Yes |
| Rollback/monitoring TBD? | Phase 6 incomplete |

Document in plan:

```markdown
### Recursive review
- Contradictions found: … or None
- Refinements made: … or —
- Goal still satisfied: Yes
```

Back: [reference.md](./reference.md)
