# Pack parity — category crosswalk

How **agent-skills** (this pack) maps to common agent-skill categories — **without** third-party repo URLs in skill files.

**Principle:** patterns and gates live **in-pack** (`SKILL.md`, `reference.md`, `ai-rules/`). Do not paste external prompts wholesale.

---

## When to use this pack vs other skills

| Situation | Use |
|-----------|-----|
| Production app bug, stack trace | `/debug` + change-control rules |
| Review PR / plan before merge | `/scrutinize` |
| Ship skill or rule changes | `/git-push` (explicit consent) |
| Improve skills in **this** repo | `/upgrade-ai` |
| Cross-layer feature plan | `/builder-feature` (plan-only) |
| Domain-specific vendor skill (Stripe, Terraform, …) | User-installed skill — review source first |
| Browser E2E at scale | User CI + tooling — not duplicated in pack |
| Daily notes / memory | `/vault-*` or user-owned notes |

---

## Category → pack mapping

| Catalog area | Typical external name (not linked) | Pack skill / rule | Gap / when to add external |
|--------------|-----------------------------------|-------------------|----------------------------|
| Systematic debugging | systematic-debugging, investigate, debug-agent | `/debug` + `ai-rules/debugging/` | Pack adds callee cleanup, change-control gates |
| Edit lock while debugging | freeze | `/debug` reference § Edit lock | Optional discipline in-pack |
| Code review | code-review lenses | `/scrutinize` | Pack adds agent-skills PR checklist, browser MCP for UI |
| Verification before done | verification-before-completion | Manifest + all close-out gates | Embedded across skills |
| Git / ship | finishing-a-development-branch | `/git-push` only | Sole git skill; explicit user consent |
| CI / infra failures | gh-fix-ci | `/builder-infrastructure` reference | `gh run view` triage in reference |
| UI quality | web-quality-audit, CWV, a11y | `/builder-ui` · `/scrutinize` § Browser | Browser MCP in-pack; Lighthouse via user tooling |
| Incremental delivery | incremental-implementation | `/builder-feature` reference | Plan-only + vertical slices |
| Deprecation / migration | deprecation-and-migration | `callee-redirect-cleanup.mdc` | Redirect + grep dead callers |
| Planning | writing-plans, plan-eng-review | `/builder-feature` | Durable `*.plan.md` + slice backlog |
| Memory / recall | claude-memory-skill, tutor-skills | **Non-goal** in pack | Use `/vault-*` or user memory model |
| Skill authoring | skill-creator, skill-optimizer | `/upgrade-ai` | 8-phase diagnosis + version governance |
| Context engineering | Agent-Skills-for-Context-Engineering | `/upgrade-ai` reference | Meta only — decomposition |
| Playwright / Browserbase | webapp-testing, ui-test | **Non-goal** in pack | Cursor browser MCP or user tooling |

---

## Claude Code parity (2026)

How this pack relates to **Claude Code** product capabilities — map patterns, do not duplicate vendor prompts. Consumer entry: [`AGENTS.md`](../AGENTS.md) (same role as `CLAUDE.md` in Claude-native repos).

| Claude Code area | Pack equivalent | Gap / external |
|----------------|-----------------|----------------|
| **Skills** (`SKILL.md`, progressive load) | 13 pack skills + [Agent Skills open spec](https://agentskills.io) via Cursor | Pack uses `reference.md` per skill; all slash-invoked (`disable-model-invocation: true`) |
| **Permission before edits/commands** | `/git-push` consent · `/scrutinize` review-only · change-control manifest | Stronger than default — by design |
| **Codebase onboarding** ("explain this repo") | `/debug` reference § Unfamiliar repo · optional `/vault-recall` | No standalone onboarding skill |
| **Issue → PR workflow** | `/debug` → patch · `/git-push` · `/fix-record` | No GitHub issue orchestration skill — use `gh` in consumer repo |
| **Routines** (scheduled / API / event runs) | **Non-goal** | Use Cursor Automations or Claude Routines separately — see [APPENDIX-TH §11](./th/APPENDIX-TH.md) |
| **Dynamic workflows / parallel subagents** | `/builder-feature` sequential slices · Cursor native subagents for parallel work | See [builder-feature/reference-slice-handoff.md](../ai-skills/builder-feature/reference-slice-handoff.md) § Parallel slices |
| **Multi-surface** (terminal, IDE, Slack) | Cursor junction setup (`.cursor/skills`, `.agents/skills`) | Slack / web agent surfaces not in pack |

---

## Pack strengths

1. **3-layer change-control** — `change-control-manifest.mdc` + scoped `ai-rules/` + verification checklists
2. **SKILL REPORT** contract — [`templates/template.skill-report.md`](../templates/template.skill-report.md)
3. **Thai docs** — [`docs/th/README.md`](./th/README.md)
4. **`disable-model-invocation: true`** on all 13 skills
5. **Callee redirect cleanup** — rule + dynamic smoke scenario #8
6. **Plan-only orchestrator** — [`/builder-feature`](../ai-skills/builder-feature/SKILL.md)
7. **Static skill validator** — `scripts/validate-skills.sh` + [`SKILL-EVAL-PROMPTS.md`](./SKILL-EVAL-PROMPTS.md)

---

## Skill quality standards (self-check)

Align with common catalog bars (third-person description, progressive disclosure, no machine paths):

| Criterion | Pack status |
|-----------|-------------|
| Third-person `description` in frontmatter | Required — all skills |
| Progressive disclosure (`SKILL.md` < ~500 lines) | Required — depth in `reference.md` |
| No machine absolute paths in skills | Smoke + review |
| Scoped activation | `disable-model-invocation` + rule globs |
| No third-party repo URLs in `reference.md` | Required — pack-native patterns only |

---

## Security — installing other skills

Any skill installed outside this pack is **user-reviewed**, not pack-audited:

- Read the skill source (not just marketing copy)
- Use static analysis or trust tooling if your org requires it
- Watch for prompt injection, tool poisoning, or unsafe shell patterns
- Do not mix unaudited `alwaysApply` rules with this pack without `/scrutinize`

---

## Using this pack with other skills

Use **agent-skills as the base orchestration layer**; add domain skills only where this pack is a non-goal.

### Install order

| Step | Action |
|------|--------|
| 1 | Clone this repo; run `scripts/setup-macos-linux.sh` or `setup-windows.ps1` |
| 2 | **Reload Cursor** |
| 3 | Install other skills separately (read source first) |
| 4 | Run `./scripts/validate-skills.sh` after any skill/rule edit |

### Where files live (Cursor)

| Layer | Canonical (git) | Cursor sees |
|-------|-----------------|-------------|
| **This pack** | `ai-skills/`, `ai-rules/` | `.cursor/skills`, `.cursor/rules` (junction) · also `.agents/skills` when present ([Cursor Agent Skills](https://cursor.com/docs/skills)) |
| **Other skill** | User path | Sibling install — do not replace pack junction |
| **Vault notes** | `vault/` (gitignored) | `.cursor/vault` |

### Pairing examples (names only — user installs separately)

| Your task | This pack | Add external |
|-----------|-----------|--------------|
| Stripe payments API | `/builder-api` + `/scrutinize` | Vendor Stripe skill — review before install |
| Playwright CI / E2E | `/builder-infrastructure` | User CI tooling — not in pack |
| Lighthouse / CWV | `/builder-ui` + browser MCP | User audit tooling |
| PR CI failed | `/debug` or `/builder-infrastructure` | Consumer repo CI — triage with `gh` |
| Long-term memory | `/vault-*` optional | Pick **one** memory model |

### Conflict avoidance

| Risk | Mitigation |
|------|------------|
| Two debug skills active | Prefer pack `/debug`; skip duplicate when `/debug` attached |
| Duplicate git push | **Only** pack `/git-push` |
| `alwaysApply` rule clash | `/scrutinize` before merging external `.mdc` |
| Prompt inflation | Do not paste external prompts into pack `SKILL.md` |

### Catalog listing

When ready for community visibility, see [CATALOG-SUBMISSION.md](./CATALOG-SUBMISSION.md).

---

## Non-goals for this pack

- Bulk-import catalog skills into `ai-skills/`
- Domain catalogs (marketing, legal, …) — user installs separately
- Duplicate Playwright/Browserbase when browser MCP suffices
- Built-in vault corpus / memory-index / workday planner
- Third-party repo URLs inside skill `reference.md` files

---

## Related docs

- [AGENTS.md](../AGENTS.md) — entry point
- [CATALOG-SUBMISSION.md](./CATALOG-SUBMISSION.md) — optional catalog PR kit
- [CHANGE-CONTROL.md](./CHANGE-CONTROL.md) — gates and CI
- [upgrade-ai/reference.md](../ai-skills/upgrade-ai/reference.md) — meta audit rubric
