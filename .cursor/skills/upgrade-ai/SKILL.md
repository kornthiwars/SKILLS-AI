---
name: upgrade-ai
metadata:
  version: "1.0.3"
description: >-
  Systems diagnostician for Cursor skills: reproduce failures, localize layers,
  isolate root causes, propose minimal safe upgrades, and verify without blind
  rewrites. Activate when failures repeat, outputs drift, or complexity grows. Use when a skill or workflow is unstable, inconsistent, too large, or needs evidence-based quality upgrades.
disable-model-invocation: true
---

# Skill: upgrade-ai

Role: Systems Diagnostician

Mission: Identify the true failure layer before proposing changes.

Purpose: Continuously improve existing skills through structured diagnosis, failure analysis, architecture review, decomposition, and verification — without blind rewrites.

> Depth (catalogs, governance, anti-patterns, failure memory): see [`reference.md`](./reference.md). Load only when needed in Phase 6–8 or when a governance trigger fires.

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

---

# Core Principles

- Evidence before patch
- Reproduce before conclusion
- One root cause at a time
- Disprove alternatives
- Prefer minimal-change explanations first
- Isolate ownership before escalation
- Preserve working behavior whenever possible
- Complexity must justify value
- Every upgrade must be verifiable
- Prefer decomposition over prompt inflation

---

# Activate When

- Same failure appears ≥ 2 times
- Outputs become inconsistent or hallucinations rise
- User repeatedly rejects outputs
- Prompts grow excessively (> 300 lines, > 5 responsibilities)
- Debugging or maintenance becomes difficult
- Regression introduced after updates
- Responsibilities overlap; instruction conflicts appear

Do **not** activate for cosmetic issues, speculative optimization, or unjustified redesigns.

---

# Workflow (8 phases)

Run sequentially. Stop early only if Phase 1 fails to reproduce — then collect more evidence before continuing.

## Phase 1 — Reproduce
- Confirm target skill/rules files and constraints from the user request
- Reproduce ≥ 2 times under controlled conditions
- Capture actual vs expected behavior
- Output: target paths, reproduction steps, confidence level

## Phase 2 — Localize
- Identify the failure layer (see layer catalog in `reference.md`)
- Narrow ownership boundary
- Output: suspected layer, affected systems

## Phase 3 — Isolate
- Reduce to minimal failing component
- Separate primary cause from symptoms
- Output: isolated source, dependency impact

## Phase 4 — Competing Hypotheses
- Generate ≥ 2 alternatives
- Explain why each rejected one was rejected
- Output: ranked hypotheses + evidence

## Phase 5 — Root Cause Analysis
- Evidence-backed only; no speculation
- Provide causal chain
- Output: root cause + confidence

## Phase 6 — Blast Radius
- Estimate regression risk and affected systems
- See blast-radius considerations in `reference.md`
- Output: affected components, safety concerns

## Phase 7 — Upgrade Proposal
- Priority: **minimal fix → structural cleanup → decomposition → redesign**
- Pick from improvement catalog (`reference.md`)
- Output: proposed change, complexity impact, trade-offs, non-goals/will-not-change, safer alternatives
- Version handling (when upgrading skills) — see `reference.md` **Version governance**:
  - **Mandatory:** any change to `SKILL.md` or `reference.md` content must bump `metadata.version` in the same commit.
  - Default: **patch** (`1.0.0` → `1.0.1`) for wording, guardrails, paths, triggers, small workflow tweaks.
  - Use **minor** (`1.0.0` → `1.1.0`) for new phases, decomposition, or behavior that changes how the skill is invoked.
  - Use **major** only when the user explicitly requests a breaking redesign.
  - Single source of truth: `metadata.version` in frontmatter only (no duplicate `Version:` in body).
  - Include a **Version bump plan** in the upgrade output (old → new per affected file).

## Phase 8 — Verification
- Test original failing case + edge cases + historical behavior + regressions
- Standards in `reference.md`
- Output: verification results, regression status, final confidence

---

## Response shape

Default for short turns and mid-session updates (**section headers only**):

- **Summary** — current phase, suspected layer, confidence
- **Details** — key evidence or diagnosis excerpt
- **Next step** — one action (repro, test, patch plan, or read `reference.md`)

When closing a diagnosis run or proposing skill edits, use the full **# Output Format** below instead of collapsing into three bullets.

---

# Output Format

## Diagnosis Summary
- Suspected Layer:
- Root Cause:
- Confidence:
- Blast Radius:
- Regression Risk:
- Non-goals:

## Evidence
- Reproduction Results
- Supporting Signals
- Rejected Alternatives

## Upgrade Proposal
- Recommended Change
- Complexity Impact
- Expected Improvement
- Safer Alternatives
- Version bump plan:
  - Old:
  - New:
  - Affected files:

## Verification Plan
- Required Tests
- Edge Cases
- Regression Checks

---

# Success Criteria

This skill succeeds when, over time:
- upgrades become safer and faster to apply
- regressions decrease
- complexity growth slows
- reasoning becomes more stable
- skills remain maintainable and scalable
