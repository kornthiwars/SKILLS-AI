# ai-skills

Canonical Cursor skills for agent-skills. After clone, run [scripts/setup-macos-linux.sh](../scripts/setup-macos-linux.sh) (or Windows equivalent).

**Architecture:** [ARCHITECTURE.md](../ARCHITECTURE.md) · Authoring: [SKILL-AUTHORING.md](SKILL-AUTHORING.md) · Agents: [AGENTS.md](../AGENTS.md) · **คู่มือไทย:** [docs/th/SKILLS-TH.md](../docs/th/SKILLS-TH.md)

## Domain catalog

| Domain | File |
|--------|------|
| Diagnose | [_catalog/diagnose.md](_catalog/diagnose.md) |
| Build | [_catalog/build.md](_catalog/build.md) |
| Memory | [_catalog/memory.md](_catalog/memory.md) |
| Meta | [_catalog/meta.md](_catalog/meta.md) |

Folders prefixed with `_` are indexes — not Cursor skills (`validate-skills` skips them).

## Quick invoke

| Skill | Invoke |
|-------|--------|
| debug | `/debug` |
| scrutinize | `/scrutinize` |
| builder-ui | `/builder-ui` |
| builder-ui-cost | `/builder-ui-cost` |
| builder-api | `/builder-api` |
| builder-schema | `/builder-schema` |
| builder-infrastructure | `/builder-infrastructure` |
| builder-feature | `/builder-feature` — plan-only; slice handoff to builder-* |
| fix-record | `/fix-record` |
| upgrade-ai | `/upgrade-ai` |
| git-push | `/git-push` |
| vault-daily | `/vault-daily` |
| vault-capture | `/vault-capture` |
| vault-recall | `/vault-recall` |
