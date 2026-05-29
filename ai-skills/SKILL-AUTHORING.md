# Skill authoring (agent-skills)

Read before creating or editing a skill. Gold examples: [`upgrade-ai/`](upgrade-ai/SKILL.md), [`debug/`](debug/SKILL.md), [`git-push/`](git-push/SKILL.md). Structure: [`../docs/SKILL-PATTERN.md`](../docs/SKILL-PATTERN.md). Production gates: [`../docs/CHANGE-CONTROL.md`](../docs/CHANGE-CONTROL.md).

## Repo layout

```
agent-skills/
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
| **Invocation** | `disable-model-invocation: true` on **all** manual skills — prevents auto-loading full `SKILL.md` every chat |
| **Description** | WHAT + invoke hint (one short block) — no duplicate `Trigger on` + `Use when` |
| **paths** | Omit when `disable-model-invocation: true` (no auto-discovery benefit) |
| **Response shape** | `Summary` / `Details` / `Next step` for short turns; full Output format when closing |
| **Scope guardrails** | ALWAYS scope + non-goals; NEVER speculative rewrites |
| **Large skills** | Keep `SKILL.md` under ~300 lines — move phase prose to `reference.md` § Workflow |

## Token efficiency

Skills load in three layers ([agentskills.io](https://agentskills.io/specification)):

| Layer | When | Keep small |
|-------|------|------------|
| `description` | Discovery | 2–4 lines max; no workflow prose |
| `SKILL.md` | User invokes `@skill` or `/command` | Quick-ref tables; gates; output shape |
| `reference.md` | Agent reads on demand | Phase detail, checklists, anti-patterns |

### Agent rules

- **One skill per turn** — hand off (`@builder-api`) instead of stacking skills.
- **Lazy reference** — add “Load [reference.md](./reference.md) § Workflow (detail)” at the phase you need, not in turn 1.
- **No duplicate sections** — if `description` states when to use, do not repeat a full `# Activation` block in `SKILL.md`.

### Author targets

- `SKILL.md` **&lt; 300 lines** (hard watch at 250+).
- Workflow phases as a **table** in `SKILL.md` + prose in `reference.md`.
- Every new skill: `disable-model-invocation: true` unless you explicitly need auto-invoke (rare).

## Version bumps

| Change | Bump |
|--------|------|
| Wording, guardrails, paths, output fields | patch |
| New phase, workflow split to reference, invocation change | minor |
| Breaking redesign (user-approved) | major |

## Git

Only [`git-push`](git-push/SKILL.md) runs git CLI in app repos. For **this** repo: edit `ai-skills/` then `@git-push` with explicit commit consent (**ยืนยัน**).

## Pre-merge check

Run:

```bash
./scripts/smoke-skills.sh
./scripts/change-control-check.sh
```

Smoke = skills/rules structure. Change-control = patch budget on current diff.

## Language

- **SKILL.md body:** English (technical clarity).
- **User replies:** follow `ai-rules/bilingual-th-en.mdc` (~60% Thai / ~40% English).
- **Vault files:** body may be Thai or English; frontmatter `tags`, `skill:`, `title:`, `symptoms:`, `files:` stay **English** (see `vault-issues.mdc`). New files: match [templates/template.issue.md](../templates/template.issue.md) and [template.learning.md](../templates/template.learning.md).
