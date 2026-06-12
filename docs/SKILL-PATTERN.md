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

**Optional `paths`:** scoped auto-invocation globs — use on **implement** skills (`builder-ui`, `builder-api`, …). **Omit** on plan-only orchestrators (`builder-feature`) and meta skills (`debug`, `scrutinize`, `git-push`, …).

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

Depth: [`builder-feature/reference.md`](../ai-skills/builder-feature/reference.md) · [`builder-ui/reference.md`](../ai-skills/builder-ui/reference.md) § Slice brief intake.

## Pre-merge

- Patch budget per [`change-control-manifest.mdc`](../ai-rules/change-control-manifest.mdc)
- Run behavioral scenarios in [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) after major rule/skill changes
