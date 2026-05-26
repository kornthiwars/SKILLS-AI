# SKILLS-AI — Cursor layout

Minimal `.cursor/` scaffold for this repo.

## Structure

| Path | Purpose |
|------|---------|
| `rules/` | Project rules (`.mdc`) — e.g. `bilingual-th-en.mdc` (ไทย ~60% / EN ~40%) |
| `skills/` | Project skills (`SKILL.md` per folder) |
| `agents/` | Custom agent definitions (optional, unused) |
| `hooks.json` | Agent hooks (optional) |
| `hooks/` | Hook scripts referenced from `hooks.json` |

## Skills

| Skill | Path | Invoke |
|-------|------|--------|
| debug | `skills/debug/` | `/debug` — four-mantra debugging (from 9arm `debug-mantra`) |
| scrutinize | `skills/scrutinize/` | `/scrutinize` — end-to-end review before merge |
| sql | `skills/sql/` | `/sql` — READ / MIGRATE / WRITE with safety gates |
| builder-ui | `skills/builder-ui/` | `/builder-ui` — scalable accessible frontend architecture from UI refs |
| builder-api | `skills/builder-api/` | `/builder-api` — contract-first API architecture and reliability |
| builder-schema | `skills/builder-schema/` | `/builder-schema` — data modeling, integrity, indexing, safe migrations |
| builder-infrastructure | `skills/builder-infrastructure/` | `/builder-infrastructure` — IaC, CI/CD, observability, DR |
| builder-feature | `skills/builder-feature/` | `/builder-feature` — orchestrate UI/API/schema/infra for a feature |
| fix-record | `skills/fix-record/` | `/fix-record` — RCA after validated fix |
| upgrade-ai | `skills/upgrade-ai/` | `/upgrade-ai` or ask to use **upgrade-ai** |
| git-push | `skills/git-push/` | `/git-push` or ask to **push to GitHub** |

## Next steps

1. Add rules under `rules/` (see [Cursor Rules](https://cursor.com/docs/context/rules)).
2. Add more skills under `skills/<skill-name>/SKILL.md`.
3. Commit and share with your team.
