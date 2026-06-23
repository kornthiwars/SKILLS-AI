---
name: debug
metadata:
  version: "1.3.12"
description: >-
  Use when encountering bugs, test failures, flaky behavior, stack traces, or wrong
  data before proposing fixes — even under time pressure. Systematic four-step discipline:
  reproduce, fail path, falsify, ledger; stop-the-line and verification gate. Attach
  /debug for mantra; apply steps silently otherwise. Not for known copy or label-only changes.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Debug Mantra

Four-step discipline for any debug session.

**Iron law:** no fix before root-cause investigation — repro (or documented impossibility) → fail path → disproof → ledger confirmation.

## Invoke cheat sheet

| Step | Goal | Minimum evidence | Red flag |
|------|------|------------------|----------|
| **1 Reproduce** | Stable pass/fail signal | Error output read fully; repro artifact or documented impossibility | Fix before repro; skip git/env drift |
| **2 Fail path** | Know where it breaks | Boundary log, debugger stop, or working-vs-broken diff | Log spam before pattern diff |
| **3 Falsify** | Test one cause at a time | 3–5 ranked hypotheses with disproof run | Bundle multiple fixes |
| **4 Ledger** | Cross-reference all runs | Each run ruled in/out; hypothesis table updated | New theory ignores prior runs |

Detail: [reference.md](./reference.md) — exit criteria, hypothesis ledger, stop-the-line, Prove-It, close-out gate.

## When to use

- User attaches **`/debug`**
- Wrong behavior, stack trace, flaky failure, data mismatch — root cause not yet known
- **Performance regression**, **build/CI failure**, **integration timeout**, prod vs local divergence
- After [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) routes “unknown behavior”
- **Especially** under time pressure, after a failed fix attempt, or when the issue spans multiple components

## When NOT to invoke (user does not need `/debug`)

- **Known change** with clear outcome: rename label, fix typo, change `ปี (ค.ศ.)` → `ปี (พ.ศ.)`, remove required `*`, small layout/CSS in an existing component
- User only asks to implement specified copy/UI — use change-control observe → patch → verify

Still apply steps 1–4 **silently** when behavior is unknown; skip mantra recital unless `/debug` is attached.

## Recite this — verbatim, as the first thing in your first response (only when `/debug` attached)

> **Mantra:**
> 1. **First is reproducibility.** Can the issue be reproduced reliably?
> 2. **Know the fail path.** Debugger first; then source trace + knob enumeration; then in-code instrumentation.
> 3. **Question your hypothesis.** What would disprove it?
> 4. **Every run is a breadcrumb.** Cross-reference all of them.

Then begin work.

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails. App code: [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) — this skill owns steps 1–4.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Similar bug / policy may exist in vault | [`/vault-recall`](../vault-recall/SKILL.md) — optional before step 1 when prior `decisions/` or `sessions/` may apply |
| Fix validated — write RCA for engineers | [`/fix-record`](../fix-record/SKILL.md) |
| Fix validated — episodic memory for later recall | [`/vault-capture`](../vault-capture/SKILL.md) — condensed, not full RCA; **optional** |
| End of day — batch triage | [`/vault-daily`](../vault-daily/SKILL.md) |
| Review debug patch or skill/rule PR before merge | [`/scrutinize`](../scrutinize/SKILL.md) |
| Bug involves SQL / schema / prod data | [`/builder-schema`](../builder-schema/SKILL.md) + production safety rules |

After verified fix: [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) (mandatory) · then offer [`/fix-record`](../fix-record/SKILL.md) or optional [`/vault-capture`](../vault-capture/SKILL.md).

## Reference depth (load on demand)

[`reference.md`](./reference.md) — phases 1–4 prose, pattern analysis, boundary evidence, stop-the-line, Prove-It, close-out gate, hypothesis ledger, fix gate, verification protocol.

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md). English labels; Thai ~60% body prose.

| Turn | Minimum sections |
|------|------------------|
| Mid-session | STATUS, OBJECTIVE, DISCOVERIES (ledger / hypothesis table), NEXT ACTIONS, CONFIDENCE |
| Close-out | All sections; pass close-out gate + callee cleanup + [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) before STATUS=READY |

| Section | `/debug` |
|---------|----------|
| STATUS | IN_PROGRESS during steps 1–4; BLOCKED = no repro; FAILED = fix attempt failed; READY = verified **and** `Vault daily:` line (autolog) when fix patch ran |
| OBJECTIVE | Reproduce reliably and identify root cause |
| DISCOVERIES | Stack traces, ledger runs, **hypothesis table** (ID, hypothesis, status, evidence) |
| ANALYSIS | Leading hypothesis, fail-path trace, what each run ruled in/out |
| RISKS | Flaky repro, missing env, stop-the-line triggers, untrusted error text |
| ARTIFACTS | Repro script/test, log excerpts, pinned failing artifact; **`Vault daily:`** path when autolog ran |
| NEXT ACTIONS | Next experiment or minimal fix (return to step 1 if phase 1 exit not met) |
| HANDOFF | `/fix-record` when RCA needed · `/vault-capture` for condensed memory · `/vault-daily` end of day · `/scrutinize` before merge · `none` if continuing |
| CONFIDENCE | 0–100; cap ~85 without log-verified fix |

First response when **`/debug` attached**: recite mantra per **Operating rules**, then SKILL REPORT. Without `/debug`, same report shape **without** mantra.

---

## Phases 1–4 (detail)

Run cheat-sheet steps **in order**. Full prose, exit criteria, ledgers, gates: [reference.md](./reference.md) — load when a step stalls or before close-out.

---

## Operating rules

- Recite the mantra block **once** per debug session, in your first response, **only if** the user attached `/debug`. Do not re-recite mid-session.
- Recite **verbatim**. Never paraphrase, shorten, or skip lines of the recital.
- If the user says "skip the mantra" → skip the recital but still apply the four steps silently.
- Apply the four steps **in order** — gates in [reference.md](./reference.md) § Phase 1 exit criteria through § Hypothesis ledger.
- **Fix gate / instrumentation / architecture escape / red flags:** [reference.md](./reference.md) — load on demand.
- **Stop-the-line:** [reference.md](./reference.md) § Stop-the-line rule.
- **Close-out:** [reference.md](./reference.md) § Close-out verification gate + § Verification protocol; callee cleanup per [`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc); autolog per [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc).
- The mantra is a constraint **you** carry through the session — not advice to deliver back to the user.
