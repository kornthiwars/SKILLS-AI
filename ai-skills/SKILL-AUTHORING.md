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
3. `## Scope Guardrails` section — pack SSoT below; skill-specific bullets only when needed
4. Link [`change-control-manifest.mdc`](../ai-rules/change-control-manifest.mdc) when skill touches app code
5. Bump `metadata.version` per [`upgrade-ai/reference.md`](upgrade-ai/reference.md) § Version governance
6. Add row to [`ai-skills/README.md`](README.md) and [`AGENTS.md`](../AGENTS.md)
7. Run `scripts/validate-skills.sh` (or `.ps1`) before `/git-push`

## Scope Guardrails (pack SSoT)

Default for every skill unless **skill-specific** bullets below override:

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

Application-code skills also follow [`change-control-manifest.mdc`](../ai-rules/change-control-manifest.mdc) (patch budget, observe→verify, Active skill precedence).

## Token efficiency (pack SSoT)

| Layer | Keep in always-on `.mdc` | Move to scoped rule or skill `reference.md` |
|-------|--------------------------|---------------------------------------------|
| Always-on (5 files) | Iron law, sequence, routing links | Long examples, script blocks, duplicate tables |
| Scoped `ai-rules/` | One-screen rule per file | Cross-link manifest — no duplicate sequence |
| Skills | Cheat sheet + REPORT | Phase prose (see § Token efficiency) |

**Do not cut:** execution sequence steps 1–10, vault-autolog iron law, debug mantra, production prohibitions substance.

**Always-on budget:** target ≤25 lines per file except manifest (≤65). Remove PowerShell code fences from always-on — cite script path only.

## Builder close-out deliverables (SSoT)

`builder-ui`, `builder-api`, `builder-schema`, `builder-infrastructure`:

- **`SKILL.md` `ARTIFACTS` row:** `Close-out deliverables: [reference.md](./reference.md) § Close-out deliverables` — do not duplicate the list in SKILL.
- **`reference.md`:** § Close-out deliverables (canonical table) + § Close-out verification gate (proof checklist).

## Voice

Follow [`bilingual-th-en.mdc`](../ai-rules/bilingual-th-en.mdc) in chat; SKILL bodies usually English for grep stability.
