# SKILLS-AI — Cursor layout

Minimal `.cursor/` scaffold for this repo.

## Structure

| Path | Purpose |
|------|---------|
| `rules/` | Project rules (`.mdc`) — loaded by Cursor Agent |
| `skills/` | Project skills (`SKILL.md` per folder) |
| `agents/` | Custom agent definitions (optional) |
| `hooks.json` | Agent hooks (optional) |
| `hooks/` | Hook scripts referenced from `hooks.json` |

## Next steps

1. Add rules under `rules/` (see [Cursor Rules](https://cursor.com/docs/context/rules)).
2. Add skills under `skills/<skill-name>/SKILL.md`.
3. Commit and share with your team.
