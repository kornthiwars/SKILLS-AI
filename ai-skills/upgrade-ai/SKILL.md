---
name: upgrade-ai
metadata:
  version: "1.2.0"
description: >-
  Evidence-based skill diagnosis and minimal upgrades — 8 phases, cheat sheet, handoffs,
  pack consistency checklist, score audit template. Invoke with /upgrade-ai or /upgrade.
disable-model-invocation: true
---

# Skill: upgrade-ai

Role: Systems Diagnostician

Mission: Identify the true failure layer before proposing changes.

Purpose: Continuously improve existing skills through structured diagnosis, failure analysis, architecture review, decomposition, and verification — without blind rewrites.

> Depth (catalogs, governance, anti-patterns): see [`reference.md`](./reference.md). Load in Phase 6–8 or when a governance trigger fires.

## Quick cheat sheet

| Trigger | Action |
|---------|--------|
| Repeat failure ≥2× | Phase 1 reproduce (or structural audit if meta-only) |
| Meta audit (`/upgrade`) | Static pack checklist + score template — cap confidence ~0.85 |
| Phase 7 | Minimal fix first · version bump plan per touched skill |
| Phase 8 | Smoke + fill audit · pass [reference.md](./reference.md) § Close-out verification gate |

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Handoffs (other skills in this pack)

Use this skill only for **skills and rules** in agent-skills (or the user's skill pack). For other work, hand off:

| Situation | Skill |
|-----------|--------|
| App bug, stack trace, failing behavior | [`/debug`](../debug/SKILL.md) |
| Review plan, PR, or diff before merge | [`/scrutinize`](../scrutinize/SKILL.md) |
| Long RCA after a validated production fix | [`/fix-record`](../fix-record/SKILL.md) |
| Search vault only (no upgrade) | [`/vault-recall`](../vault-recall/SKILL.md) |
| Ship skill changes | [`/git-push`](../git-push/SKILL.md) |

Application-code patches: follow [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) — do not duplicate its full gate list here.

---

---

# Core Principles

Skill-upgrade specifics (general observe→verify gates live in the manifest above):

- Identify the **failure layer** before editing prompts (see layer catalog in `reference.md`).
- **Prefer decomposition** (`SKILL.md` + `reference.md`) over prompt inflation; split files only when core + reference is insufficient (`reference.md` § Decomposition Rules).
- **Complexity must justify value** — no redesign without evidence and user scope.
- **Every upgrade must be verifiable** (Phase 8; standards in `reference.md` § Verification Standards).
- **Disprove alternatives** before closing root cause (Phase 4–5).

---

# Activate When

- Same failure appears ≥ 2 times
- Outputs become inconsistent or hallucinations rise
- User repeatedly rejects outputs
- Prompts grow excessively (> 300 lines, > 5 responsibilities) — see `reference.md` § Complexity governance
- Debugging or maintenance becomes difficult
- Regression introduced after updates
- Responsibilities overlap; instruction conflicts appear

Do **not** activate for cosmetic issues, speculative optimization, or unjustified redesigns.

---

# Workflow (8 phases)

Run sequentially. Stop early only if Phase 1 **failure diagnosis** cannot reproduce — then collect more evidence before continuing.

| Phase | Goal | Output |
|-------|------|--------|
| 1 Reproduce | Confirm scope; reproduce or audit | paths, steps, confidence |
| 2 Localize | Find failure layer | layer, affected systems |
| 3 Isolate | Minimal failing component | source, dependency impact |
| 4 Hypotheses | ≥ 2 alternatives, reject with evidence | ranked hypotheses |
| 5 Root cause | Causal chain, evidence only | root cause, confidence |
| 6 Blast radius | Regression risk | components, safety concerns |
| 7 Upgrade proposal | Minimal → redesign priority | change, trade-offs, version plan |
| 8 Verification | Original + edge + regression | results, final confidence |

### Phase 1 — Reproduce

- Confirm target skill/rules files and constraints from the user request.
- When diagnosing **this** repo (agent-skills): search per [`vault-recall/reference.md`](../vault-recall/reference.md) (≤3 learnings, then issues if needed).
- **Failure diagnosis:** reproduce ≥ 2 times under controlled conditions; capture actual vs expected behavior.
- **Structural / meta audit** (no repeat failure — e.g. “wrong structure?”, token review): scope + static file analysis only; use Response shape; cap confidence ~0.85; do **not** force artificial repro.

### Phases 2–6

- Phase 2: layer catalog in `reference.md` § Layer catalog.
- Phase 3: isolation methods in `reference.md` § Isolation methods.
- Phase 6: blast radius in `reference.md` § Blast radius considerations.

### Phase 7 — Upgrade Proposal

- Priority: **minimal fix → structural cleanup → decomposition → redesign**
- Pick from `reference.md` § Improvement catalog
- Output: proposed change, complexity impact, trade-offs, non-goals, safer alternatives
- **Version bumps:** follow [`reference.md`](./reference.md) § Version governance only; include a **Version bump plan** in the upgrade output (old → new per affected file)

### Phase 8 — Verification

- Test original failing case + edge cases + historical behavior + regressions
- Standards: `reference.md` § Verification Standards and success criteria there
- **Pack-wide audit:** fill [`templates/template.skill-pack-score.md`](../../templates/template.skill-pack-score.md) with before/after scores + bar chart

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

Over time, upgrades should improve safety, speed, and maintainability without increasing regressions — measurable criteria and Phase 8 tests: [`reference.md`](./reference.md) § Verification Standards.
