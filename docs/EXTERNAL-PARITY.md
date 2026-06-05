# External parity — catalog crosswalk

How **agent-skills** (this pack) relates to the wider ecosystem — especially [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) (curated index, ~1400+ entries, not a single pack).

**Principle:** link patterns from external repos; do **not** copy wholesale into `ai-skills/`. This pack is opinionated: change-control + vault/wiki/workday + SKILL REPORT.

---

## When to use this pack vs external skills

| Situation | Use |
|-----------|-----|
| Production app bug, stack trace | `/debug` + change-control rules |
| Review PR / plan before merge | `/scrutinize` |
| Ship skill or rule changes | `/git-push` (explicit consent) |
| Improve skills in **this** repo | `/upgrade-ai` |
| Daily Q&A | `vault/issues/` (rule) |
| Durable knowledge | `/wiki-ingest` → `vault/wiki/pages/` |
| Daily plan | `/workday-init` · `/workday-update` · `/workday-review` |
| Domain-specific official skill (Stripe, Terraform vendor, …) | Install from catalog — **review source first** |
| Browser E2E at scale (Playwright CI farm) | External skill + your CI — not duplicate Cursor browser MCP in pack |

---

## Catalog category → pack mapping

| Catalog area | Examples in awesome-agent-skills | Pack skill / rule | Gap / external when |
|--------------|----------------------------------|-------------------|---------------------|
| Systematic debugging | [obra/systematic-debugging](https://github.com/obra/superpowers), [garrytan/investigate](https://officialskills.sh/garrytan/skills/investigate), [millionco/debug-agent](https://github.com/millionco/debug-agent) | `/debug` + `ai-rules/debugging/` | Pack adds vault ledger, callee cleanup #7, change-control gates |
| Edit lock while debugging | [garrytan/freeze](https://officialskills.sh/garrytan/skills/freeze) | `/debug` reference § Edit lock | Optional discipline — link only |
| Code review | [coderabbitai/code-review](https://officialskills.sh/coderabbitai/skills/code-review), [NeoLabHQ/code-review](https://github.com/NeoLabHQ/context-engineering-kit/tree/master/plugins/code-review) | `/scrutinize` | Pack adds agent-skills PR checklist, browser MCP for UI |
| Verification before done | [obra/verification-before-completion](https://github.com/obra/superpowers) | Manifest + all close-out gates | Embedded across skills |
| Git / ship | [obra/finishing-a-development-branch](https://github.com/obra/superpowers), [fvadicamo/dev-agent-skills](https://github.com/fvadicamo/dev-agent-skills) | `/git-push` only | Sole git skill; explicit user consent |
| CI / infra failures | [openai/gh-fix-ci](https://officialskills.sh/openai/skills/gh-fix-ci) | `/builder-infrastructure` reference | Use `gh` log triage for PR checks; pack CI is `skills-quality.yml` |
| UI quality | [addyosmani/web-quality-audit](https://officialskills.sh/addyosmani/skills/web-quality-audit) (+ a11y, CWV children) | `/builder-ui` · `/scrutinize` § Browser | Cursor browser MCP for runtime; external for Lighthouse-style audits |
| Incremental delivery | [addyosmani/incremental-implementation](https://github.com/addyosmani/agent-skills) | `/builder-feature` reference | Thin vertical slices |
| Deprecation / migration | [addyosmani/deprecation-and-migration](https://github.com/addyosmani/agent-skills/tree/main/skills/deprecation-and-migration) | `callee-redirect-cleanup.mdc` | Redirect + grep dead callers |
| Planning | [obra/writing-plans](https://github.com/obra/superpowers), [garrytan/plan-eng-review](https://officialskills.sh/garrytan/skills/plan-eng-review) | `/workday-*` | Vault `workday/` persistence — not chat-only plans |
| Memory / wiki | [hanfang/claude-memory-skill](https://github.com/hanfang/claude-memory-skill), [RoundTable02/tutor-skills](https://github.com/RoundTable02/tutor-skills) | `/vault-recall` · `/wiki-ingest` | issues vs wiki split is pack-specific |
| Skill authoring | [anthropics/skill-creator](https://officialskills.sh/anthropics/skills/skill-creator), [hqhq1025/skill-optimizer](https://github.com/hqhq1025/skill-optimizer) | `/upgrade-ai` | 8-phase diagnosis + version governance |
| Context engineering | [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) | `/upgrade-ai` reference | Meta only — long sessions, decomposition |
| Playwright / Browserbase | [anthropics/webapp-testing](https://officialskills.sh/anthropics/skills/webapp-testing), [browserbase/ui-test](https://officialskills.sh/browserbase/skills/ui-test) | **Non-goal** in pack | Use Cursor browser MCP or install external skill |

---

## Pack strengths (not typical in catalog entries)

1. **3-layer change-control** — `change-control-manifest.mdc` + scoped `ai-rules/` + CI smoke
2. **Vault triangle** — `issues/` (daily) · `workday/` (plans) · `wiki/pages/` (durable)
3. **SKILL REPORT** contract — [`templates/template.skill-report.md`](../templates/template.skill-report.md)
4. **Thai docs** — [`docs/th/README.md`](./th/README.md)
5. **`disable-model-invocation: true`** on all 15 skills
6. **Callee redirect cleanup** — rule + dynamic smoke scenario #9

---

## VoltAgent quality standards (self-check)

From [awesome-agent-skills § Skill Quality Standards](https://github.com/VoltAgent/awesome-agent-skills#skill-quality-standards):

| Criterion | Pack status |
|-----------|-------------|
| Third-person `description` in frontmatter | Required — all skills |
| Progressive disclosure (`SKILL.md` < ~500 lines) | Required — max ~140 lines; depth in `reference.md` |
| No machine absolute paths in skills | Smoke + review |
| Scoped activation | `disable-model-invocation` + rule globs |

---

## Security — installing external skills

The catalog is **curated, not audited**. Before installing any external skill:

- Read the skill source (not just the README link)
- Prefer [Snyk Agent Scan](https://github.com/snyk/agent-scan) or [Agent Trust Hub](https://ai.gendigital.com/agent-trust-hub)
- Watch for prompt injection, tool poisoning, or unsafe shell patterns
- Do not mix unaudited `alwaysApply` rules with this pack without `/scrutinize`

---

## Non-goals for this pack

- Bulk-import catalog skills into `ai-skills/`
- Domain catalogs (marketing, NVIDIA, n8n, legal, …) — use external installs
- Duplicate Playwright/Browserbase skills when browser MCP suffices
- List this repo in awesome-agent-skills before community adoption (see their CONTRIBUTING bar)

---

## Related docs

- [AGENTS.md](../AGENTS.md) — entry point + external discovery
- [CHANGE-CONTROL.md](./CHANGE-CONTROL.md) — gates and CI
- [upgrade-ai/reference.md](../ai-skills/upgrade-ai/reference.md) — meta audit rubric
