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

| Response shape | SKILL REPORT — [`templates/template.skill-report.md`](../../templates/template.skill-report.md) |

---

## Repo layout (agent-skills)

When diagnosing or upgrading **this** repository:

| Canonical (edit in git) | Cursor sees (after setup) |
|-------------------------|---------------------------|
| `ai-skills/<name>/` | `.cursor/skills/<name>/` (symlink/junction) |
| `ai-rules/*.mdc` | `.cursor/rules/` |
| `vault/` | `.cursor/vault/` → `agent-skills/vault/` (junction; `SKILLS-AI/vault/` legacy alias; local notes gitignored) |

- **Do not** treat `.cursor/skills` as source of truth in the clone — it points at `ai-skills/`.
- **Do not** commit user content under `vault/` (gitignored except `.gitkeep`).
- Vault notes: agent `Read`/`Write` from [templates/vault/README.md](../../templates/vault/README.md); `bootstrap-vault` seeds layout + Obsidian + today's daily if missing.
- New clone: run `scripts/setup-macos-linux.sh` or Windows equivalent before testing skills in Cursor.
- Before ship: run `scripts/validate-skills.sh` (or `.ps1`) — see [SKILL-EVAL-PROMPTS.md](../../docs/SKILL-EVAL-PROMPTS.md).
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
- structural audit path: [SKILL-SMOKE-CHECKLIST.md](../../docs/SKILL-SMOKE-CHECKLIST.md) + authoring checks when no runtime repro exists

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
Use this table to bias diagnoses toward known traps.

### Prior art (diagnosis aid)

When upgrading skills in agent-skills:

1. Grep `ai-skills/` and `ai-rules/` for related keywords
2. Read peer `SKILL.md` / `reference.md` — link instead of copy-paste tables
3. After `/scrutinize` on skill PRs: verify checklist in [`scrutinize/SKILL.md`](../scrutinize/SKILL.md) § agent-skills skill / rule PRs

### Production change-control (rules)

When upgrading governance in agent-skills:

- Prefer [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) as the always-on parent — do not duplicate its gates across many `alwaysApply` files
- Add scoped rules under `ai-rules/{core,patching,architecture,testing,risk,workflow}/` with `globs` or intelligent activation
- Wire skills to the manifest (1–3 lines); keep deep workflow in `SKILL.md`
- Keep `scripts/setup-*` accurate when junction paths change

---

## Pack consistency checklist (agent-skills)

When upgrading **any** skill in this repo, verify peer skills stay aligned:

| Check | Pass criteria |
|-------|---------------|
| Handoffs | `## Handoffs` links related skills in pack |
| Cheat sheet | Workflow skills have quick table in `SKILL.md` |
| SKILL REPORT | All skills link `templates/template.skill-report.md`; field mapping in each `SKILL.md` |
| reference.md | Depth on demand; `SKILL.md` < ~300 lines |
| Verification | Close-out gate in reference or operating rules |
| Handoffs | No orphan workflows — link peer skills |
| Version | `metadata.version` bumped on every content edit |
| Dynamic smoke | [DYNAMIC-AGENT-SMOKE.md](../../docs/DYNAMIC-AGENT-SMOKE.md) scenarios still valid after changes |
| Thai docs | `docs/th/APPENDIX-TH.md` §1 **and** `README.md` § Skills — version rows synced by `validate-skills` |
| External parity | [EXTERNAL-PARITY.md](../../docs/EXTERNAL-PARITY.md) § Claude Code + install surfaces after install/frontmatter changes |
| Meta release smoke | `./scripts/smoke-preflight.sh` + regression bundle #1,#2,#9,#11,#12,#14,#16 logged in DYNAMIC pass log |

Patterns used in this pack (repo-native only): verification-before-completion, incremental vertical slices, runtime log probe budget.

---

## Pack-internal discovery

| Resource | Role |
|----------|------|
| [`docs/EXTERNAL-PARITY.md`](../../docs/EXTERNAL-PARITY.md) | Category crosswalk — pack skill vs non-goals (no external URLs) |
| [`docs/SKILL-EVAL-PROMPTS.md`](../../docs/SKILL-EVAL-PROMPTS.md) | Behavioral smoke after skill edits |

**Rule:** do **not** add third-party repo URLs to `reference.md` or skills — keep patterns and gates in-pack only.

---

## Context engineering (long-session meta)

When prompts grow unstable or context noise rises:

| Signal | Upgrade bias |
|--------|--------------|
| Lost-in-middle / instruction clash | Decompose to `reference.md`; reduce `alwaysApply` rules |
| Long sessions, repeated grep | Move tables to `reference.md`; reduce `alwaysApply` rules |
| Multi-agent overlap | Handoffs table; one skill per responsibility |
| Skill > 300 lines or > 5 duties | Phase 7 decomposition per § Complexity governance |

Do not import external context-engineering packs — use diagnosis vocabulary in this file during `/upgrade-ai` meta audits.

---

## Meta audit rubric (target 9/10)

After upgrading one or more skills, score in **SKILL REPORT** `ARTIFACTS` (inline — no repo audit file):

1. Score each skill before/after using dimensions below
2. List blockers still below 9 with next action
3. Re-run [DYNAMIC-AGENT-SMOKE.md](../../docs/DYNAMIC-AGENT-SMOKE.md) scenarios after major rule/skill edits

| Dimension (/10) | Question |
|-----------------|----------|
| Workflow clarity | Cheat sheet + ordered phases? |
| Verification gate | IDENTIFY→RUN→READ before success claims? |
| Handoffs | Related skills linked? |
| reference depth | Detail on demand; SKILL < ~300 lines? |
| Pack parity | stop-the-line, Prove-It, slices where relevant? |

**Target:** each skill ≥ **9.0** before closing pack upgrade session.

---

## Close-out verification gate (Phase 8)

Before claiming pack or skill upgrade **complete** (verification-before-completion — IDENTIFY → RUN → READ):

| Step | Action |
|------|--------|
| 1 IDENTIFY | Which skills changed · pack checklist rows |
| 2 RUN | [SKILL-SMOKE-CHECKLIST.md](../../docs/SKILL-SMOKE-CHECKLIST.md) + `./scripts/validate-skills.sh` + behavioral scenarios in [DYNAMIC-AGENT-SMOKE.md](../../docs/DYNAMIC-AGENT-SMOKE.md) / [SKILL-EVAL-PROMPTS.md](../../docs/SKILL-EVAL-PROMPTS.md) |
| 3 READ | Cite checklist results in session · list skills still below 9.0 with next action in SKILL REPORT |
| 4 AUTOLOG | After verified meta patch → [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc): `Read` `templates/vault/notes/template.vault-daily.md` if missing → `Write` `vault/daily/<today>.md` → `append-daily`; reply **`Vault daily: updated vault/daily/YYYY-MM-DD.md`** |

Do not claim "all skills at 9.0" without inline score table or explicit blocker list in the session. Do not claim READY until step 4 when files were patched.

---

## Blast radius considerations (Phase 6)

Always check before proposing change:
- shared prompts
- orchestration dependencies
- reusable templates
- memory dependencies
- verification assumptions
