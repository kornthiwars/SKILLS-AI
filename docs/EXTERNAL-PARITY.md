# External parity — catalog crosswalk

How **agent-skills** (this pack) relates to the wider ecosystem — especially [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) (curated index, ~1400+ entries, not a single pack).

**Principle:** link patterns from external repos; do **not** copy wholesale into `ai-skills/`. This pack is opinionated: change-control + SKILL REPORT.

---

## When to use this pack vs external skills

| Situation | Use |
|-----------|-----|
| Production app bug, stack trace | `/debug` + change-control rules |
| Review PR / plan before merge | `/scrutinize` |
| Ship skill or rule changes | `/git-push` (explicit consent) |
| Improve skills in **this** repo | `/upgrade-ai` |
| Cross-layer feature plan | `/builder-feature` (plan-only) |
| Domain-specific official skill (Stripe, Terraform vendor, …) | Install from catalog — **review source first** |
| Browser E2E at scale (Playwright CI farm) | External skill + your CI — not duplicate Cursor browser MCP in pack |
| Daily notes / memory | External memory skills or your own `vault/` folder (local, not pack behavior) |

---

## Catalog category → pack mapping

| Catalog area | Examples in awesome-agent-skills | Pack skill / rule | Gap / external when |
|--------------|----------------------------------|-------------------|---------------------|
| Systematic debugging | [obra/systematic-debugging](https://github.com/obra/superpowers), [garrytan/investigate](https://officialskills.sh/garrytan/skills/investigate), [millionco/debug-agent](https://github.com/millionco/debug-agent) | `/debug` + `ai-rules/debugging/` | Pack adds callee cleanup #7, change-control gates |
| Edit lock while debugging | [garrytan/freeze](https://officialskills.sh/garrytan/skills/freeze) | `/debug` reference § Edit lock | Optional discipline — link only |
| Code review | [coderabbitai/code-review](https://officialskills.sh/coderabbitai/skills/code-review), [NeoLabHQ/code-review](https://github.com/NeoLabHQ/context-engineering-kit/tree/master/plugins/code-review) | `/scrutinize` | Pack adds agent-skills PR checklist, browser MCP for UI |
| Verification before done | [obra/verification-before-completion](https://github.com/obra/superpowers) | Manifest + all close-out gates | Embedded across skills |
| Git / ship | [obra/finishing-a-development-branch](https://github.com/obra/superpowers), [fvadicamo/dev-agent-skills](https://github.com/fvadicamo/dev-agent-skills) | `/git-push` only | Sole git skill; explicit user consent |
| CI / infra failures | [openai/gh-fix-ci](https://officialskills.sh/openai/skills/gh-fix-ci) | `/builder-infrastructure` reference | Use `gh` log triage for PR checks on consumer projects |
| UI quality | [addyosmani/web-quality-audit](https://officialskills.sh/addyosmani/skills/web-quality-audit) (+ a11y, CWV children) | `/builder-ui` · `/scrutinize` § Browser | Cursor browser MCP for runtime; external for Lighthouse-style audits |
| Incremental delivery | [addyosmani/incremental-implementation](https://github.com/addyosmani/agent-skills) | `/builder-feature` reference | Plan-only orchestrator + thin vertical slices; implement per owner skill |
| Deprecation / migration | [addyosmani/deprecation-and-migration](https://github.com/addyosmani/agent-skills/tree/main/skills/deprecation-and-migration) | `callee-redirect-cleanup.mdc` | Redirect + grep dead callers |
| Planning | [obra/writing-plans](https://github.com/obra/superpowers), [garrytan/plan-eng-review](https://officialskills.sh/garrytan/skills/plan-eng-review) | `/builder-feature` | Chat plan + slice backlog — not a separate daily planner skill |
| Memory / recall | [hanfang/claude-memory-skill](https://github.com/hanfang/claude-memory-skill), [RoundTable02/tutor-skills](https://github.com/RoundTable02/tutor-skills) | **Non-goal** in pack | Use external skill or local `vault/` notes |
| Skill authoring | [anthropics/skill-creator](https://officialskills.sh/anthropics/skills/skill-creator), [hqhq1025/skill-optimizer](https://github.com/hqhq1025/skill-optimizer) | `/upgrade-ai` | 8-phase diagnosis + version governance |
| Context engineering | [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) | `/upgrade-ai` reference | Meta only — long sessions, decomposition |
| Playwright / Browserbase | [anthropics/webapp-testing](https://officialskills.sh/anthropics/skills/webapp-testing), [browserbase/ui-test](https://officialskills.sh/browserbase/skills/ui-test) | **Non-goal** in pack | Use Cursor browser MCP or install external skill |

---

## Pack strengths (not typical in catalog entries)

1. **3-layer change-control** — `change-control-manifest.mdc` + scoped `ai-rules/` + manual verification checklists
2. **SKILL REPORT** contract — [`templates/template.skill-report.md`](../templates/template.skill-report.md)
3. **Thai docs** — [`docs/th/README.md`](./th/README.md)
4. **`disable-model-invocation: true`** on all 13 skills
5. **Callee redirect cleanup** — rule + dynamic smoke scenario #8
6. **Plan-only orchestrator** — [`/builder-feature`](../ai-skills/builder-feature/SKILL.md) iron law (no app patches); vertical slices; implement via builder-* per slice
7. **Static skill validator** — `scripts/validate-skills.sh` + GitHub Actions; eval prompts in [`docs/SKILL-EVAL-PROMPTS.md`](./SKILL-EVAL-PROMPTS.md)

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

## Using this pack with external skills (install guide)

Use **agent-skills as the base orchestration layer**; add catalog skills for domains this pack deliberately does not cover ([non-goals](#non-goals-for-this-pack)).

### Install order

| Step | Action |
|------|--------|
| 1 | Clone this repo; run `scripts/setup-macos-linux.sh` or `setup-windows.ps1` → junctions `.cursor/skills`, `.cursor/rules`, `.cursor/vault` |
| 2 | **Reload Cursor** |
| 3 | Install **external** skills separately (read source first — [Security](#security--installing-external-skills)) |
| 4 | Run `./scripts/validate-skills.sh` after any skill/rule edit |

### Where files live (Cursor)

| Layer | Canonical (git) | Cursor sees |
|-------|-----------------|-------------|
| **This pack** | `ai-skills/`, `ai-rules/` | `.cursor/skills`, `.cursor/rules` (junction) |
| **External skill** | Its own repo | User path — e.g. clone into `~/.cursor/skills/<name>/` **or** project `.cursor/skills/<name>/` **without** replacing the junction target |
| **Vault notes** | `vault/` (gitignored) | `.cursor/vault` |

**Do not** overwrite the pack junction with a single external skill folder. Add siblings or use Cursor’s user-level skills directory per [Cursor docs](https://cursor.com/docs).

### Pairing examples (link-only — do not bulk-import)

| Your task | This pack | Add external (catalog) |
|-----------|-----------|-------------------------|
| Stripe payments API | `/builder-api` slice + `/scrutinize` | [stripe/stripe](https://officialskills.sh/stripe/skills/stripe) — review before install |
| Playwright CI / E2E farm | `/builder-infrastructure` for CI wiring | [anthropics/webapp-testing](https://officialskills.sh/anthropics/skills/webapp-testing) — not duplicated in pack |
| Lighthouse / CWV audit | `/builder-ui` + browser MCP verify | [addyosmani/web-quality-audit](https://officialskills.sh/addyosmani/skills/web-quality-audit) |
| PR CI failed on GitHub | `/debug` or `/builder-infrastructure` | [openai/gh-fix-ci](https://officialskills.sh/openai/skills/gh-fix-ci) on consumer repo |
| Long-term memory (non-Obsidian) | `/vault-*` optional | [hanfang/claude-memory-skill](https://github.com/hanfang/claude-memory-skill) — pick **one** memory model |

### Conflict avoidance

| Risk | Mitigation |
|------|------------|
| Two debug skills active | Prefer pack `/debug` + rules; disable or skip external systematic-debugging when `/debug` attached |
| Duplicate git push behavior | **Only** pack `/git-push` — uninstall external git-ship skills |
| `alwaysApply` rule clash | `/scrutinize` before merging external `.mdc` into workspace |
| Prompt inflation | External skill = reference link in `reference.md`; do not paste into `SKILL.md` |

### Listing this pack in catalogs

When ready for community visibility, follow [CATALOG-SUBMISSION.md](./CATALOG-SUBMISSION.md) (awesome-agent-skills bar).

---

## Non-goals for this pack

- Bulk-import catalog skills into `ai-skills/`
- Domain catalogs (marketing, NVIDIA, n8n, legal, …) — use external installs per table above
- Duplicate Playwright/Browserbase skills when browser MCP suffices
- Built-in vault corpus / memory-index / workday planner
- Submit to awesome-agent-skills **before** usage evidence — see [CATALOG-SUBMISSION.md](./CATALOG-SUBMISSION.md)

---

## Related docs

- [AGENTS.md](../AGENTS.md) — entry point + external discovery
- [CATALOG-SUBMISSION.md](./CATALOG-SUBMISSION.md) — awesome-agent-skills PR kit
- [CHANGE-CONTROL.md](./CHANGE-CONTROL.md) — gates and CI
- [upgrade-ai/reference.md](../ai-skills/upgrade-ai/reference.md) — meta audit rubric
