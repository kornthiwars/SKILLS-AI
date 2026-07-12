# ai-rules

Activation map: [_index.mdc](_index.mdc) · Architecture: [ARCHITECTURE.md](../ARCHITECTURE.md)

| Rule | Load | Role |
|------|------|------|
| `change-control-manifest.mdc` | always-on | Observe→verify, attempt ledger, patch budget, skill routing |
| `bilingual-th-en.mdc` | always-on | Thai ~60% / English ~40% replies |
| `workflow/vault-autolog.mdc` | always-on | Daily bullet after verified patch |
| `clean-code.mdc` | globs (app source) | Generated application code style |
| `core/`, `debugging/`, `patching/`, `architecture/`, `testing/`, `risk/`, `workflow/` | globs / intelligent | Scoped production rules |

**Tier 0 = 3** always-on. Removed as redundant (2026-07-12): `execution-model`, `decision-tree`, `response-format`. Detail: [_index.mdc](_index.mdc) · Thai: [docs/th/RULES-TH.md](../docs/th/RULES-TH.md)

Edit here — not in `.cursor/rules/` junction.
