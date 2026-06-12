---
name: fix-record
metadata:
  version: "1.2.4"
description: >-
  Canonical RCA after a validated fix — mechanism, fix, validation, slip-through.
  Required-input gate + verification protocol. Invoke with /fix-record when closing
  a fixed bug (not before fix lands).
disable-model-invocation: true
---

# Fix record

The canonical engineering record of a bug fix. Written **after** debugging lands a real fix, **for** other engineers (and future-you). Code identifiers are welcome — this artifact lets the next person grep back to the change.

Executive summaries reframe the same facts in plain language — this skill owns **engineering truth**.

## Quick cheat sheet

| Gate | Requirement |
|------|-------------|
| **Inputs** | Repro + root cause + fix pointer + validation — all four |
| **Draft** | Sections per [reference.md](./reference.md) § Structure |
| **Verify** | [reference.md](./reference.md) § Verification protocol + § Close-out verification gate |
| **Publish** | Sign-off before JIRA POST when applicable |

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Bug not fixed yet | [`/debug`](../debug/SKILL.md) — refuse fix-record until validation |
| Review RCA or related PR | [`/scrutinize`](../scrutinize/SKILL.md) |
| Skill pack RCA | Same structure; ship via [`/git-push`](../git-push/SKILL.md) |

## When to invoke

- `/fix-record` or "write the fix record / RCA"
- After [`/debug`](../debug/SKILL.md) verification passes — offer proactively for non-trivial fixes

## When NOT to use

- **Bug not fixed or not validated** — refuse; list missing inputs
- **Customer outage / incident report** — separate artifact; confirm scope
- **Trivial one-liner** — PR description is enough
- **Multiple unrelated root causes in one commit** — one RCA per cause (see Multi-fix commits)

## Multi-fix commits

1. Ask which root cause this record covers — or one record per cause.
2. Default: PR lists changes; `/fix-record` only for the bug the user names.
3. Refuse a monolithic RCA inventing one root cause for unrelated fixes.

## Required inputs — refuse without all four

- [ ] **Reliable repro** (deterministic or high-rate flake)
- [ ] **Root cause known** (mechanism, not hypothesis)
- [ ] **Fix identified** (PR / commit / branch)
- [ ] **Fix validated** (original repro passes)

Detail: [reference.md](./reference.md) § Required inputs. Pull from debug ledger + hypothesis **CONFIRMED** when available.

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/fix-record` |
|---------|---------------|
| STATUS | BLOCKED = missing any of 4 inputs; IN_PROGRESS = drafting; READY = verified draft |
| OBJECTIVE | Produce validated RCA record for destination (JIRA, PR, docs) |
| DISCOVERIES | Symptom, mechanism, validation evidence from debug ledger |
| ANALYSIS | Root cause chain — mechanism over narrative |
| RISKS | Invented owners, unvalidated fix, missing repro, hedging |
| ARTIFACTS | Draft sections: Summary, Root cause, Fix, Validation (+ optional sections per reference) |
| NEXT ACTIONS | Missing input to collect · sign-off before POST |
| HANDOFF | `/debug` if inputs incomplete · `none` when published |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Verification protocol before READY |

Before inputs satisfied: STATUS=BLOCKED, list missing items in DISCOVERIES. After satisfied: close-out with full ARTIFACTS draft.

## Structure

Mandatory blocks: **Summary, Root cause, Fix, Validation.** Full section guide + worked example: [reference.md](./reference.md) § Structure · § Worked example.

## Tone

Engineer-to-engineer: code identifiers first-class; mechanism over narrative; active voice; no hedging; blameless gaps not people; no advocacy in the record body.

## Output flow

1. Confirm all four inputs — stop if any missing.
2. Confirm destination (JIRA, PR body, `docs/fix-records/`).
3. Produce draft in chat.
4. Sign-off before JIRA POST — wait for explicit *post it* / *go ahead*.
5. Optional leadership summary only if user asks.

Pass [reference.md](./reference.md) § Verification protocol before publish.

## Rules

- Never invent root cause, owners, validation, or action items.
- Never strip code identifiers in engineering sections.
- State validation coverage honestly.
- One iteration normal; three revisions — ask which section is wrong.
