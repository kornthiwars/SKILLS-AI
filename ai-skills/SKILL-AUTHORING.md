# Skill authoring (SKILLS-AI)

Read before creating or editing a skill. Gold examples: [`upgrade-ai/`](upgrade-ai/SKILL.md), [`debug/`](debug/SKILL.md), [`git-push/`](git-push/SKILL.md).

## Repo layout

```
SKILLS-AI/
├── ai-skills/          # canonical skills (edit here)
├── ai-rules/           # canonical rules (.mdc)
├── vault/              # daily issues + learnings
├── templates/          # template.issue.md for new days
└── scripts/            # setup → .cursor/ links in workspace
```

After clone: `./scripts/setup-macos-linux.sh <install-root>` — see [scripts/README.md](../scripts/README.md).

## Per-skill folder

```
<skill-name>/
├── SKILL.md       # workflow, guardrails, output shape (< 300 lines target)
└── reference.md   # optional — deep checklists, phase detail
```

`name:` in frontmatter must match folder name.

## Conventions in this repo

| Topic | Rule |
|-------|------|
| **Version** | `metadata.version` only — bump on every `SKILL.md` / `reference.md` change ([upgrade-ai/reference.md](upgrade-ai/reference.md) § Version governance) |
| **Invocation** | `disable-model-invocation: true` on manual skills (`/debug`, builders, `git-push`, …) |
| **Description** | WHAT + when to use — avoid duplicating `Trigger on` + `Use when` |
| **paths** | Omit when `disable-model-invocation: true` (no auto-discovery benefit) |
| **Response shape** | `Summary` / `Details` / `Next step` for short turns; full Output format when closing |
| **Scope guardrails** | ALWAYS scope + non-goals; NEVER speculative rewrites |
| **Large skills** | Keep `SKILL.md` under ~300 lines — move phase prose to `reference.md` § Workflow |

## Version bumps

| Change | Bump |
|--------|------|
| Wording, guardrails, paths, output fields | patch |
| New phase, workflow split to reference, invocation change | minor |
| Breaking redesign (user-approved) | major |

## Git

Only [`git-push`](git-push/SKILL.md) runs git CLI in app repos. For **this** repo: edit `ai-skills/` then `@git-push` with explicit commit consent (**ยืนยัน**).

## Language

- **SKILL.md body:** English (technical clarity).
- **User replies:** follow `ai-rules/bilingual-th-en.mdc` (~60% Thai / ~40% English).
- **Vault entries:** Thai-primary OK.
