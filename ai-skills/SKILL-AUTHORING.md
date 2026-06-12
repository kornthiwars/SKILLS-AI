# SKILL authoring

## Repo layout

```
agent-skills/
├── ai-skills/<name>/   # SKILL.md + optional reference.md
├── ai-rules/           # .mdc rules
├── vault/              # local notes (gitignored); templates in scripts/vault/
├── templates/
└── scripts/
```

## New skill checklist

1. `ai-skills/<name>/SKILL.md` with frontmatter `disable-model-invocation: true`
2. `compatibility:` — Cursor junction setup; explicit `/slash` invoke (see existing skills)
3. `## Scope Guardrails` section
4. Link [`change-control-manifest.mdc`](../ai-rules/change-control-manifest.mdc) when skill touches app code
5. Bump `metadata.version` per [`upgrade-ai/reference.md`](upgrade-ai/reference.md) § Version governance
6. Add row to [`ai-skills/README.md`](README.md) and [`AGENTS.md`](../AGENTS.md)
7. Run `scripts/validate-skills.sh` (or `.ps1`) before `/git-push`

## Voice

Follow [`bilingual-th-en.mdc`](../ai-rules/bilingual-th-en.mdc) in chat; SKILL bodies usually English for grep stability.
