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

---

## Response shape governance

- Core and operator skills use `## Response shape` (**Summary** / **Details** / **Next step**) for short and mid-session turns.
- Use the full `# Output Format` in `SKILL.md` (or `# Phase 5 — Report` for `sql`) when closing a diagnosis, push, SQL run, or review.
- Workspace rule `ai-rules/bilingual-th-en.mdc` (via `.cursor/rules` link): Response shape labels are **section headers only** — do not duplicate the same content in full Thai and full English blocks.
- Builder skills may keep `# Output format` as the canonical long form; a one-line pointer to the three labels under that heading is enough for consistency without prompt inflation.

---

## Repo layout (SKILLS-AI)

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

## Decision Rules

### Minimal Change Bias

Prefer:
- smaller fixes
- isolated improvements
- lower regression risk
- simpler reasoning paths

Avoid:
- unnecessary rewrites
- premature abstraction
- architecture escalation
- speculative redesign

---

## Complexity Governance

Trigger decomposition when ANY of:
- prompt > 300 lines
- > 5 responsibilities
- unstable reasoning appears
- debugging difficulty increases
- branching logic becomes excessive
- context noise increases

---

## Decomposition Rules

Split skills when:
- responsibilities conflict
- prompts become unstable
- debugging becomes unreliable
- verification becomes difficult
- outputs become inconsistent

Possible subskills (only if single-file split is insufficient):
- diagnostician
- architect
- verifier
- critic
- optimizer
- orchestrator

Prefer **core + reference** before splitting into multiple skill files.

---

## Verification Standards

A successful upgrade must improve at least one:
- accuracy
- consistency
- debuggability
- maintainability
- token efficiency
- regression resistance
- reasoning quality

Without significantly degrading others.

Required tests (Phase 8):
- original failing case
- nearby edge cases
- historical working behavior
- regression scenarios

---

## Anti-Patterns

Avoid:
- patching before reproduction
- guessing without evidence
- mixing unrelated failures
- solving symptoms only
- excessive prompt growth
- overengineering
- premature optimization
- architectural rewrites without justification
- escalating complexity unnecessarily
- adding abstraction without measurable benefit

---

## Failure Memory

Recurring patterns to watch for:
- premature conclusions
- unstable decomposition
- instruction conflicts
- excessive prompt inflation
- context pollution
- role ambiguity
- skipped verification
- speculative reasoning
- regression-prone fixes
- **vault recall not wired** — `vault-issues.mdc` defines Grep learnings but skills skip it until Phase 0/ pre-debug steps exist in `debug`, `git-push`, or `/vault-recall`
- **issues vs learnings confusion** — copying daily Q&A format into `learnings/` (use lesson card in `templates/template.learning.md`)

Use these patterns to bias future diagnoses toward known traps.

### Vault recall (diagnosis aid)

When upgrading skills in SKILLS-AI:

1. Grep `vault/learnings/` for skill name + symptom (≤3 files)
2. Check `vault/issues/` last 2 days for repeat topics
3. Prefer **minimal wire** (5–15 lines in SKILL) before new skills; add `vault-recall` only when search is a standalone user intent

---

## Blast Radius Considerations (Phase 6)

Always check before proposing change:
- shared prompts
- orchestration dependencies
- reusable templates
- memory dependencies
- verification assumptions
