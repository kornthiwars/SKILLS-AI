# upgrade-ai — reference depth (v1.0.1)

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

Use these patterns to bias future diagnoses toward known traps.

---

## Blast Radius Considerations (Phase 6)

Always check before proposing change:
- shared prompts
- orchestration dependencies
- reusable templates
- memory dependencies
- verification assumptions
