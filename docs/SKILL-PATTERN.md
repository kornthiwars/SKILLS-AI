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

## Required core sections

1. Title, Role, Mission, Purpose
2. `## Scope Guardrails`
3. Activate / workflow
4. `## Response shape`
5. `# Output format`
6. `# Success criteria`

## Pre-merge

```bash
./scripts/smoke-skills.sh
./scripts/change-control-check.sh
```
