# workday/plans

Feature execution plans from **`/builder-feature`** (`PLAN_READY`).

| Item | Detail |
|------|--------|
| **Template** | [`templates/template.feature-plan.md`](../../templates/template.feature-plan.md) |
| **Slice handoff** | [`templates/template.slice-brief.md`](../../templates/template.slice-brief.md) |
| **Naming** | `{feature-slug}.md` (kebab-case) |
| **Git** | Local only — plans are gitignored |

Implement slices via `/builder-ui`, `/builder-api`, etc. — not from this folder by orchestrator.
