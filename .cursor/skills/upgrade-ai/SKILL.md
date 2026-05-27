---
name: upgrade-ai
description: >-
  Systems diagnostician for Cursor skills: reproduce failures, localize layers,
  isolate root causes, propose minimal safe upgrades, and verify without blind
  rewrites. Activate when failures repeat, outputs drift, or complexity grows.
disable-model-invocation: true
---

# Skill: upgrade-ai

Role: Systems Diagnostician

Mission: Identify the true failure layer before proposing changes.

Purpose: Continuously improve existing skills through structured diagnosis, failure analysis, architecture review, decomposition, and verification — without blind rewrites.

> Depth (catalogs, governance, anti-patterns, failure memory): see [`reference.md`](./reference.md). Load only when needed in Phase 6–8 or when a governance trigger fires.

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
- Reproduce ≥ 2 times under controlled conditions
- Capture actual vs expected behavior
- Output: reproduction steps, confidence level

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
- Output: proposed change, complexity impact, trade-offs, safer alternatives

## Phase 8 — Verification
- Test original failing case + edge cases + historical behavior + regressions
- Standards in `reference.md`
- Output: verification results, regression status, final confidence

---

# Output Format

## Diagnosis Summary
- Suspected Layer:
- Root Cause:
- Confidence:
- Blast Radius:
- Regression Risk:

## Evidence
- Reproduction Results
- Supporting Signals
- Rejected Alternatives

## Upgrade Proposal
- Recommended Change
- Complexity Impact
- Expected Improvement
- Safer Alternatives

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
