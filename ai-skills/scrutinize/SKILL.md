---
name: scrutinize
metadata:
  version: "1.2.2"
description: >-
  Outsider review — intent, simpler alternatives, end-to-end trace, five-axis and
  browser UI checks, verification gate before ship. Invoke with /scrutinize.
disable-model-invocation: true
---

# Scrutinize

Stand outside the change and ask whether it should exist at all, then verify it actually does what it claims end-to-end.

## Quick cheat sheet

| Step | Goal | Minimum evidence | Red flag |
|------|------|------------------|----------|
| **1 Intent** | One-sentence goal + simpler alternative | Stated goal; one alternative considered | Diff-only review |
| **2 Trace** | Walk real code path | Entry → state → exit with seams | Unchanged code ignored |
| **3 Verify** | Claims vs behavior | Per-claim trace verdict | "PR says X" without trace |
| **4 Report** | Actionable findings | `file:line` + severity + verdict | LGTM without trace |

PR checklist + five-axis + verification: [reference.md](./reference.md).

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Runtime bug while reviewing | [`/debug`](../debug/SKILL.md) |
| RCA after validated fix | [`/fix-record`](../fix-record/SKILL.md) |
| Skill/rule upgrade in diff | [`/upgrade-ai`](../upgrade-ai/SKILL.md) |
| SQL or schema in diff | [`/builder-schema`](../builder-schema/SKILL.md) |
| Ship approved changes | [`/git-push`](../git-push/SKILL.md) |

## Change-control

Apply [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) and [`workflow/response-format.mdc`](../../ai-rules/workflow/response-format.mdc) when recommending code changes. Classify risk per [`risk/risk-classification.mdc`](../../ai-rules/risk/risk-classification.mdc).

## Operating stance

- **Outsider.** Forget who wrote it and why they think it's right. Read the artifact cold.
- **End-to-end, not diff-local.** The diff is the entry point, not the scope. Follow the call graph through real code paths.
- **Actionable, concise, with rationale.** Every finding states *what to change*, *why*, and *what evidence* led you there. No filler, no restating the diff back.

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/scrutinize` |
|---------|---------------|
| STATUS | IN_PROGRESS during trace; READY = verdict issued; BLOCKED = artifact underspecified |
| OBJECTIVE | Cold read — verify intent, trace paths, report actionable findings |
| DISCOVERIES | Trace surprises, per-finding bullets with `file:line`, simpler alternative |
| ANALYSIS | Verdict (ship / fix-then-ship / rework / reject) + single biggest reason |
| RISKS | Untested paths, contract breaks, missing tests, scope creep |
| ARTIFACTS | Ordered findings (severity), evidence, suggested minimal change |
| NEXT ACTIONS | Single biggest fix or next trace target |
| HANDOFF | `/debug` if bug found · `/fix-record` for RCA · `/git-push` to ship · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Verification protocol before READY |

When review complete (step 4), close-out SKILL REPORT — not three bullets only. **agent-skills PRs:** run reference § agent-skills skill / rule PR checklist.

## Workflow

Run these in order. Do not skip ahead.

### 1. Intent — what is this actually trying to do?

- State the goal in one sentence, in your own words. If you cannot, the artifact is underspecified — say so and stop.
- Ask: **is there a simpler, smaller, or more elegant way to achieve the same goal?** Consider:
  - Doing nothing (is the problem real / load-bearing?).
  - Using something that already exists in the codebase instead of adding new surface.
  - A smaller change that solves 90% of the goal with 10% of the risk.
  - Solving it at a different layer (config vs code, framework vs app, build vs runtime).
- If a better alternative exists, name it explicitly with rationale. This is the most valuable thing you can output — surface it before the line-by-line review.

### 2. Trace — walk the actual code path

- For each behavior the change claims, trace the path end-to-end through the real code, not just the lines in the diff:
  - Entry point → call sites → branches taken → state mutated → exit / return / side effect.
  - Include the unchanged code on either side of the diff. Bugs hide at the seams.
- For a plan or design doc: trace the proposed flow against the existing system. Where does it touch reality? What does it assume that isn't true?
- Note every place the trace surprises you (unexpected branch, dead code reached, state you didn't know existed). Surprises are signal.

### 3. Verify — does it actually do what it claims?

For each claim the change/plan makes, answer:

- **Does the code path you just traced actually produce that behavior?** Walk it explicitly. "It claims X. Path: A → B → C. At C, [observation]. Therefore [holds / doesn't hold]."
- **What inputs / states would break it?** Edge cases, concurrent callers, error paths, partial failures, retries, empty/null/unicode/huge inputs, ordering assumptions.
- **What does it silently change?** Performance, error semantics, observability, contract for other callers, on-disk / on-wire format.
- **How is it tested?** Do the tests actually exercise the traced path, or do they pass while skipping it (mocks that hide the bug, asserts on intermediate state, happy path only)?

### 4. Report

Output one tight section per finding. Order by severity (blocker → major → nit). For each:

- **Finding** — one sentence, specific. Cite `file:line` when applicable.
- **Why it matters** — the consequence, not the principle.
- **Evidence** — the trace step or input that exposes it.
- **Suggested change** — concrete, minimal.

Close with a one-line verdict: ship / fix-then-ship / rework / reject — with the single biggest reason.

**agent-skills skill / rule PRs:** run [reference.md](./reference.md) § agent-skills skill / rule PR checklist (`metadata.version`, handoffs, vault links).

## Operating rules

- **No rubber-stamps.** "LGTM" is not an output. If you genuinely find nothing, say what you traced and what you checked, so the user can judge whether your review covered the surface they cared about.
- **Cite or it didn't happen.** Every claim about the code references a specific path, file, or line. No vague "this might break under load."
- **Distinguish claim from verification.** "The PR says X" and "I traced X and confirmed / refuted it" are different — keep them separate in the output.
- **One simpler-alternative pass is mandatory.** Even on small changes, spend one breath asking if the whole thing is necessary. Skip only if the user explicitly says "don't question scope."
- **Don't pad with style nits when there's a structural problem.** If step 1 or step 2 surfaces a real issue, lead with it; defer nits or drop them.
- **No flattery, no hedging.** "This is a great PR but..." adds nothing. State the finding.
