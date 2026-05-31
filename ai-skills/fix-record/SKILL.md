---
name: fix-record
metadata:
  version: "1.2.0"
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
| **Verify** | [reference.md](./reference.md) § Verification protocol before publish |
| **After** | Offer vault learning if reusable |

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Bug not fixed yet | [`/debug`](../debug/SKILL.md) — refuse fix-record until validation |
| Prior art before debug | [`/vault-recall`](../vault-recall/SKILL.md) |
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

## Vault (different artifacts)

| Artifact | Use |
|----------|-----|
| `vault/learnings/*.md` | Short reusable lesson — `vault-issues.mdc` |
| `/fix-record` | Long engineering RCA **after** validated fix |
| `vault/issues/` | Daily Q&A — not substitute for RCA |

## Required inputs — refuse without all four

- [ ] **Reliable repro** (deterministic or high-rate flake)
- [ ] **Root cause known** (mechanism, not hypothesis)
- [ ] **Fix identified** (PR / commit / branch)
- [ ] **Fix validated** (original repro passes)

Detail: [reference.md](./reference.md) § Required inputs. Pull from debug ledger + hypothesis **CONFIRMED** when available.

## Response shape

Before inputs satisfied:

- **Summary** — missing item or draft plan
- **Details** — four-input checklist
- **Next step** — what user must provide

After inputs satisfied: follow **Structure** in reference; full draft — not three bullets only.

## Structure

Mandatory blocks: **Summary, Root cause, Fix, Validation.** Full section guide + worked example: [reference.md](./reference.md) § Structure · § Worked example.

## Tone

Engineer-to-engineer: code identifiers first-class; mechanism over narrative; active voice; no hedging; blameless gaps not people; no advocacy in the record body.

## Output flow

1. Confirm all four inputs — stop if any missing.
2. Confirm destination (JIRA, PR body, `docs/fix-records/`, wiki).
3. Produce draft in chat.
4. Sign-off before JIRA POST — wait for explicit *post it* / *go ahead*.
5. Optional leadership summary only if user asks.

Pass [reference.md](./reference.md) § Verification protocol before publish. Offer [learning export](./reference.md) § Learning export when reusable.

## Rules

- Never invent root cause, owners, validation, or action items.
- Never strip code identifiers in engineering sections.
- State validation coverage honestly.
- One iteration normal; three revisions — ask which section is wrong.
