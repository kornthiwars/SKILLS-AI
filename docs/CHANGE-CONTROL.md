# AI change-control system (3 layers)

agent-skills uses **change-control**, not “fast coding only.”

## Layers

| Layer | Location | Role |
|-------|----------|------|
| **1 — Rules** | `ai-rules/` | Gates, budgets, risk, stop conditions |
| **2 — Skills** | `ai-skills/` | Deep workflows on invoke (`/debug`, …) |
| **3 — Setup** | `scripts/setup-*` | Junction install once per clone; manual checklist in [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md) and [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) after major pack edits |

## Always-on manifest

[`ai-rules/change-control-manifest.mdc`](../ai-rules/change-control-manifest.mdc) — execution sequence, patch budget, confidence permissions, skill routing.

## Rule tree

```
ai-rules/
├── change-control-manifest.mdc
├── core/
├── debugging/
├── patching/
├── architecture/
├── testing/
├── risk/
└── workflow/
```

Most sub-rules use **globs** or intelligent activation — not `alwaysApply`, to save context.

## Patch budget (default)

- ≤ **5** files
- ≤ **120** lines (add + delete)
- Override: user approval + `[BUDGET-OVERRIDE]` in commit message

## Confidence

| Confidence | Typical action |
|------------|----------------|
| ≥ 0.9 + LOW risk | Localized patch OK |
| 0.7 – 0.89 | Propose; prefer review |
| < 0.7 | Diagnose only |

## External skill quality (VoltAgent bar)

When authoring or reviewing skills in this repo, align with [awesome-agent-skills § Skill Quality Standards](https://github.com/VoltAgent/awesome-agent-skills#skill-quality-standards):

| Area | Guideline |
|------|-----------|
| **Description** | Third person; state what + when; specific keywords |
| **Progressive disclosure** | `SKILL.md` stays short; depth in `reference.md` (< ~500 lines in SKILL) |
| **Paths** | No machine-specific absolute paths in skills |
| **Scoped tools** | `disable-model-invocation: true` on manual skills; rules use globs |

Full ecosystem crosswalk: [EXTERNAL-PARITY.md](./EXTERNAL-PARITY.md).

## Related

- [SKILL-PATTERN.md](./SKILL-PATTERN.md) — skill file structure
- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md) — manual smoke
- [EXTERNAL-PARITY.md](./EXTERNAL-PARITY.md) — catalog vs pack mapping
- [th/README.md](./th/README.md) — Thai guides for all skills and rules
- [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) — manual agent scenarios
