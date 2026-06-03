# ai-rules

Canonical Cursor rules (`.mdc`). Linked into `.cursor/rules` by setup scripts.

## Always apply (keep small)

| Rule | Purpose |
|------|---------|
| `change-control-manifest.mdc` | AI change-control — sequence, patch budget, confidence, skill routing |
| `bilingual-th-en.mdc` | Thai ~60% / English ~40% replies |
| `vault-issues.mdc` | Vault issues + wiki via `/wiki-ingest` |
| `clean-code.mdc` | Code style baseline for generated code |

## Production rule tree (scoped)

| Folder | Purpose |
|--------|---------|
| `core/` | Execution model, diagnosis, uncertainty, minimal change, verification |
| `debugging/` | Repro, evidence, disprove alternatives (use `/debug` for depth) |
| `patching/` | Scope, size limits, side effects, dependencies |
| `architecture/` | Boundaries, shared modules, API, schema |
| `testing/` | Validation, regression, manual flows |
| `risk/` | Classification, approval gates, rollback, prod safety |
| `workflow/` | Response format, decision tree, stop conditions |

Most sub-rules use `globs` or intelligent activation — **not** `alwaysApply`.

## Docs

- [docs/CHANGE-CONTROL.md](../docs/CHANGE-CONTROL.md)
- [docs/SKILL-PATTERN.md](../docs/SKILL-PATTERN.md)
- **Thai:** [docs/th/RULES-TH.md](../docs/th/RULES-TH.md) · [docs/th/README.md](../docs/th/README.md)

## Verify

```bash
./scripts/smoke-skills.sh
./scripts/change-control-check.sh
```
