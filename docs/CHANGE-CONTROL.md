# AI change-control system (3 layers)

agent-skills uses **change-control**, not “fast coding only.”

## Layers

| Layer | Location | Role |
|-------|----------|------|
| **1 — Rules** | `ai-rules/` | Gates, budgets, risk, stop conditions |
| **2 — Skills** | `ai-skills/` | Deep workflows on invoke (`/debug`, …) |
| **3 — Verification** | `scripts/`, CI | Automated checks before merge |

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

## Commands

```bash
./scripts/smoke-skills.sh          # static baseline
./scripts/change-control-check.sh  # patch budget on working tree (HEAD)
DIFF_BASE=origin/main...HEAD ./scripts/change-control-check.sh  # PR range (CI)
```

**CI** (`.github/workflows/skills-quality.yml`): smoke hard-fails; PR budget fails unless `[BUDGET-OVERRIDE]` appears in a commit on the branch.

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

## Related

- [SKILL-PATTERN.md](./SKILL-PATTERN.md) — skill file structure
- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md) — manual smoke
- [th/README.md](./th/README.md) — Thai guides for all skills and rules
- [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) — manual agent scenarios
