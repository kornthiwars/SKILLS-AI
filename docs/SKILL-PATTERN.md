# SKILL good pattern (clean code)

Use with [CHANGE-CONTROL.md](./CHANGE-CONTROL.md) for production gates.

## Required frontmatter

```yaml
---
name: <folder-name>
metadata:
  version: "x.y.z"
description: >-
  One short WHAT + invoke hint.
disable-model-invocation: true
---
```

**Optional `paths`:** scoped auto-invocation globs — use on **implement** skills (`builder-ui`, `builder-api`, …). **Omit** on plan-only orchestrators (`builder-feature`) and meta skills (`debug`, `vault-recall`, `workday-*`).

## Required core sections

1. Title, Role, Mission, Purpose
2. `## Scope Guardrails`
3. Activate / workflow
4. `## SKILL REPORT` (link [`templates/template.skill-report.md`](../templates/template.skill-report.md))
5. `# Success criteria`

## Template index

| Template | Use |
|----------|-----|
| [`template.skill-report.md`](../templates/template.skill-report.md) | Close-out contract for all skills |
| [`template.slice-brief.md`](../templates/template.slice-brief.md) | `/builder-feature` → builder-* slice handoff |
| [`template.feature-plan.md`](../templates/template.feature-plan.md) | PLAN_READY persist → `vault/workday/plans/{slug}.md` |
| [`template.workday.md`](../templates/template.workday.md) | WORKDAY block from `/workday-init` |
| [`template.issue.md`](../templates/template.issue.md) | Daily Q&A in `vault/issues/` (rule) |
| [`template.wiki-page.md`](../templates/template.wiki-page.md) | Durable pages — auto-ingest gate or `/wiki-ingest` |

Depth: [`builder-feature/reference.md`](../ai-skills/builder-feature/reference.md) · [`builder-ui/reference.md`](../ai-skills/builder-ui/reference.md) § Slice brief intake.

## Pre-merge

```bash
./scripts/smoke-skills.sh
./scripts/change-control-check.sh
```

**Windows:** smoke scripts require **bash** (Git Bash, WSL, or macOS/Linux). CI runs them in `.github/workflows/skills-quality.yml` — local Windows without bash: push and rely on CI, or run in WSL.
