# upgrade-ai — reference depth

Version: see `metadata.version` in [`SKILL.md`](./SKILL.md).

This file keeps detailed checklists, governance, and patterns so `SKILL.md` stays focused and token-efficient. Load on demand during Phase 6–8 or when a workflow signal triggers governance.

---

## Layer catalog (Phase 2 — Localize)

Possible failure layers:
- prompt structure
- instruction hierarchy
- reasoning chain
- retrieval / context
- orchestration
- memory
- decomposition
- tool usage
- verification logic
- workflow design

---

## Isolation methods (Phase 3)

- simplify prompts
- disable dependencies
- compare working vs failing flows
- isolate conflicting instructions

---

## Improvement catalog (Phase 7)

Priority order: minimal fix → structural cleanup → decomposition → architectural redesign.

Possible improvements:
- prompt refinement
- instruction cleanup
- decomposition
- workflow redesign
- role separation
- verification improvements
- memory optimization
- retrieval cleanup
- orchestration improvements

---

## Version governance

**Rule:** Every commit that changes skill content (`SKILL.md` or `reference.md`) must increment `metadata.version` in that skill's frontmatter.

| Change type | Bump | Example |
|-------------|------|---------|
| Typos, guardrails, description, paths, output fields | **patch** | `1.0.0` → `1.0.1` |
| New workflow phase, decomposition split, activation scope | **minor** | `1.0.2` → `1.1.0` |
| Breaking redesign (user-approved) | **major** | `1.1.0` → `2.0.0` |

- **Do not** ship content edits at the same version number.
- **Do not** duplicate version in the markdown body; use `metadata.version` only.
- When upgrading multiple skills in one session, bump **each** touched skill independently.
- Phase 7 output must include a **Version bump plan** (old → new per touched file).

---

## Response shape governance

- Core and operator skills use `## Response shape` (**Summary** / **Details** / **Next step**) for short and mid-session turns.
- Use the full `# Output Format` in `SKILL.md` (or `# Phase 5 — Report` for `sql`) when closing a diagnosis, push, SQL run, or review.
- Workspace rule `ai-rules/bilingual-th-en.mdc` (via `.cursor/rules` link): Response shape labels are **section headers only** — do not duplicate the same content in full Thai and full English blocks.
- Builder skills may keep `# Output format` as the canonical long form; a one-line pointer to the three labels under that heading is enough for consistency without prompt inflation.

---

## Repo layout (agent-skills)

When diagnosing or upgrading **this** repository:

| Canonical (edit in git) | Cursor sees (after setup) |
|-------------------------|---------------------------|
| `ai-skills/<name>/` | `.cursor/skills/<name>/` (symlink/junction) |
| `ai-rules/*.mdc` | `.cursor/rules/` |
| `vault/` | `.cursor/vault/` |
| `templates/template.issue.md` | used by scripts + `vault-issues.mdc` |

- **Do not** treat `.cursor/skills` as source of truth in the clone — it points at `ai-skills/`.
- **Do not** commit `vault/issues/YYYY-MM-DD.md` (gitignored).
- New clone: run `scripts/setup-macos-linux.sh` or Windows equivalent before testing skills in Cursor.
- Authoring guide: [`../SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) · agent entry: [`../../AGENTS.md`](../../AGENTS.md).

---

## Decision rules

Production gates (observe → verify, patch budget, confidence): [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) — link, do not copy the full sequence into skills.

**Minimal change bias** for skill edits:

| Prefer | Avoid |
|--------|--------|
| smaller fixes, isolated improvements | unnecessary rewrites |
| lower regression risk | premature abstraction |
| simpler reasoning paths | architecture escalation without evidence |

---

## Complexity governance

Trigger decomposition when **any** of (also listed under **Activate When** in `SKILL.md`):

- prompt > 300 lines
- > 5 responsibilities
- unstable reasoning appears
- debugging difficulty increases
- branching logic becomes excessive
- context noise increases

---

## Decomposition rules

Split skills when:
- responsibilities conflict
- prompts become unstable
- debugging becomes unreliable
- verification becomes difficult
- outputs become inconsistent

**Order:** prefer **core + `reference.md`** before creating multiple skill files. Only split into separate skills when a single skill folder cannot hold stable responsibilities.

---

## Verification standards

A successful upgrade must improve at least one:
- accuracy
- consistency
- debuggability
- maintainability
- token efficiency
- regression resistance
- reasoning quality

Without significantly degrading others.

**Success criteria (long-term):** upgrades become safer and faster; regressions and complexity growth decrease; reasoning stays stable; skills stay maintainable.

**Required tests (Phase 8):**
- original failing case
- nearby edge cases
- historical working behavior
- regression scenarios
- structural audit path: smoke/authoring checks when no runtime repro exists

---

## Anti-patterns and failure memory

Avoid and watch for these recurring traps:

| Anti-pattern | Related failure memory |
|--------------|-------------------------|
| patching before reproduction | premature conclusions |
| guessing without evidence | speculative reasoning |
| mixing unrelated failures | instruction conflicts |
| solving symptoms only | regression-prone fixes |
| excessive prompt growth | prompt inflation, context pollution |
| overengineering / unjustified redesign | unstable decomposition |
| skipped verification | role ambiguity |
| adding abstraction without measurable benefit | — |
| **vault search drift** — grep tables copied outside [`vault-recall/reference.md`](../vault-recall/reference.md) | link instead of copy-paste |
| **issues vs learnings confusion** — daily Q&A format in `learnings/` | use [`templates/template.learning.md`](../../templates/template.learning.md) lesson card |

Use this table to bias diagnoses toward known traps.

### Vault recall (diagnosis aid)

When upgrading skills in agent-skills:

1. Run search per [`vault-recall/reference.md`](../vault-recall/reference.md) (≤3 learning files)
2. Check `vault/issues/` last 2 days for repeat topics
3. In other skills: **link** `reference.md` — do not duplicate the grep table; keep `/vault-recall` for explicit user search
4. After `/scrutinize` on skill PRs: verify checklist in [`scrutinize/SKILL.md`](../scrutinize/SKILL.md) § agent-skills skill / rule PRs

### Production change-control (rules)

When upgrading governance in agent-skills:

- Prefer [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) as the always-on parent — do not duplicate its gates across many `alwaysApply` files
- Add scoped rules under `ai-rules/{core,patching,architecture,testing,risk,workflow}/` with `globs` or intelligent activation
- Wire skills to the manifest (1–3 lines); keep deep workflow in `SKILL.md`
- Extend `scripts/smoke-skills.sh` and `scripts/change-control-check.sh`; add CI in `.github/workflows/`

---

## Blast radius considerations (Phase 6)

Always check before proposing change:
- shared prompts
- orchestration dependencies
- reusable templates
- memory dependencies
- verification assumptions
