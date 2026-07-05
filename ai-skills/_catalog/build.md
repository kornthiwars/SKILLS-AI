# Skill catalog — Build

Domain index (not a Cursor skill).

| Skill | Invoke | Mode |
|-------|--------|------|
| [builder-feature](../builder-feature/SKILL.md) | `/builder-feature` | **plan-only** — no app patches |
| [builder-ui](../builder-ui/SKILL.md) | `/builder-ui` | Full UI architecture + a11y |
| [builder-ui-cost](../builder-ui-cost/SKILL.md) | `/builder-ui-cost` | Pixel match · lowest tokens |
| [builder-api](../builder-api/SKILL.md) | `/builder-api` | Contract-first API |
| [builder-schema](../builder-schema/SKILL.md) | `/builder-schema` | Schema + migrations |
| [builder-infrastructure](../builder-infrastructure/SKILL.md) | `/builder-infrastructure` | CI/CD · IaC |

**Flow:** `/builder-feature` produces plan + slice briefs → hand off to one `builder-*` implement skill per slice.

Close-out SSoT: each builder `reference.md` § Close-out deliverables.
