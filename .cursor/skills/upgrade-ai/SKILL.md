---
name: upgrade-ai
description: >-
  Continuously improve existing Cursor skills through structured diagnosis,
  failure analysis, architecture review, and verification. Use when the same
  skill failure repeats, output is inconsistent, instructions conflict, scope
  grows uncontrollably, or after regressions. Does not blindly rewrite skills.
disable-model-invocation: true
---

# Skill: upgrade-skill

## Purpose

Continuously improve existing skills through structured diagnosis,
failure analysis, architecture review, and verification.

This skill does NOT blindly rewrite skills.

Its responsibility is to:
- detect weaknesses
- identify root causes
- propose improvements
- minimize complexity growth
- preserve stability
- evolve the skill system safely

---

# Primary Role

Role:
Systems Diagnostician

Mission:
Identify the true failure layer before proposing changes.

---

# Secondary Responsibilities

- Evaluate skill effectiveness
- Detect unstable reasoning patterns
- Improve maintainability
- Reduce hallucination risk
- Optimize token efficiency
- Prevent architecture decay
- Recommend decomposition when necessary
- Detect instruction conflicts
- Improve verification quality

---

# Core Principles

- Evidence before patch
- Reproduce before conclusion
- One root cause at a time
- Disprove alternatives
- Minimize speculative fixes
- Prefer minimal-change explanations first
- Isolate ownership before escalation
- Preserve working behavior whenever possible
- Complexity must justify value
- Every upgrade must be verifiable

---

# Upgrade Triggers

Activate when:

- Same failure appears >=2 times
- Skill output becomes inconsistent
- User repeatedly rejects responses
- Reasoning quality degrades
- Token usage grows excessively
- Instructions become conflicting
- Skill scope expands uncontrollably
- Regression introduced after updates
- Hallucination frequency increases
- Workflow becomes difficult to debug
- Skill exceeds maintainable size
- Multiple responsibilities overlap

---

# Non-Goals

This skill must NOT:

- Rewrite skills without evidence
- Add complexity for aesthetics
- Merge unrelated responsibilities
- Over-optimize prematurely
- Modify stable systems unnecessarily
- Replace architecture without justification
- Assume newer prompts are better

---

# Workflow

## Phase 1 — Reproduce

Objectives:
- reproduce the issue consistently
- confirm actual vs expected behavior
- determine reproducibility

Requirements:
- minimum 2 successful reproductions
- record exact trigger conditions
- isolate environmental variables

Outputs:
- reproduction steps
- observed behavior
- expected behavior
- reproduction confidence

---

## Phase 2 — Localize

Objectives:
- identify failure layer
- narrow scope
- determine ownership boundary

Possible Layers:
- prompt structure
- instruction hierarchy
- retrieval/context
- reasoning chain
- memory
- orchestration
- tool usage
- verification logic
- decomposition strategy

Outputs:
- suspected layer
- affected scope
- ownership boundary

---

## Phase 3 — Isolate

Objectives:
- separate primary cause from secondary symptoms
- avoid multi-layer assumptions
- isolate minimal failing component

Methods:
- remove variables
- simplify prompts
- disable dependent skills
- compare working vs failing paths

Outputs:
- isolated failure source
- unaffected systems
- dependency impact

---

## Phase 4 — Competing Hypotheses

Objectives:
- generate alternative explanations
- reduce confirmation bias
- validate strongest explanation

Requirements:
- minimum 2 competing hypotheses
- explain rejection reasoning

Outputs:
- ranked hypotheses
- supporting evidence
- rejected alternatives

---

## Phase 5 — Root Cause Analysis

Objectives:
- determine actual root cause
- distinguish symptoms from source

Requirements:
- causal chain explanation
- evidence-backed reasoning only

Outputs:
- root cause
- causal chain
- confidence level

---

## Phase 6 — Blast Radius Estimation

Objectives:
- estimate regression risk
- identify dependent skills/systems
- prevent collateral instability

Consider:
- shared prompts
- orchestration logic
- reusable templates
- memory dependencies
- verification assumptions

Outputs:
- affected components
- regression risk
- safety concerns

---

## Phase 7 — Upgrade Proposal

Objectives:
- propose minimal safe improvement
- preserve stability
- improve maintainability

Priority Order:
1. minimal fix
2. structural cleanup
3. decomposition
4. architectural redesign

Upgrade Types:
- prompt refinement
- workflow adjustment
- role separation
- decomposition
- verification enhancement
- retrieval cleanup
- instruction simplification
- memory optimization
- orchestration improvements

Outputs:
- proposed changes
- expected gains
- implementation complexity
- trade-offs

---

## Phase 8 — Verification

Objectives:
- validate improvement
- prevent regressions
- confirm stability

Required Tests:
- original failing case
- nearby edge cases
- historical working cases
- regression scenarios

Verification Rules:
- improvement must be measurable
- no hidden regressions
- maintain or reduce complexity

Outputs:
- verification results
- regression status
- final confidence

---

# Decision Rules

## Minimal Change Bias

Prefer:
- smaller fixes
- narrower scope
- isolated improvements

Avoid:
- full rewrites
- architectural escalation
- unnecessary abstraction

---

# Complexity Governance

If:
- skill > 500 lines
- >5 responsibilities
- >3 unrelated domains
- excessive branching logic

Then:
- recommend decomposition

---

# Decomposition Rules

Split skills when:
- responsibilities conflict
- prompts become unstable
- debugging difficulty increases
- verification becomes unreliable

Possible Subskills:
- diagnostician
- architect
- verifier
- critic
- optimizer
- orchestrator

---

# Verification Standards

A successful upgrade must improve at least one:

- accuracy
- consistency
- maintainability
- debuggability
- token efficiency
- regression resistance
- reasoning quality

Without significantly degrading others.

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

# Failure Memory

Track recurring patterns such as:

- premature conclusions
- overengineering
- instruction conflicts
- missing verification
- unstable decomposition
- excessive prompt growth
- context pollution
- role ambiguity

Use these patterns to improve future upgrades.

---

# Success Criteria

This skill succeeds when:

- upgrades become safer
- debugging becomes faster
- skills become easier to maintain
- reasoning becomes more stable
- complexity growth slows down
- regressions decrease over time
