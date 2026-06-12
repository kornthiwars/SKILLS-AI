---
name: debug
metadata:
  version: "1.3.6"
description: >-
  Four-step debugging: reproduce, trace fail path, falsify hypothesis, cross-reference
  breadcrumbs. Stop-the-line, reduce, bisection, Prove-It, verification gate, untrusted
  errors. Phase exit criteria, hypothesis table, instrumentation lifecycle.
  Read errors and recent changes first. User may attach /debug for mantra; apply four
  steps silently otherwise. Not for known copy/label-only changes.
disable-model-invocation: true
---

# Debug Mantra

Four-step discipline for any debug session.

**Iron law:** no fix before root-cause investigation — repro (or documented impossibility) → fail path → disproof → ledger confirmation.

## Quick cheat sheet

| Step | Goal | Minimum evidence | Red flag |
|------|------|------------------|----------|
| **1 Reproduce** | Stable pass/fail signal | Error output read fully; repro artifact or documented impossibility | Fix before repro; skip git/env drift |
| **2 Fail path** | Know where it breaks | Boundary log, debugger stop, or working-vs-broken diff | Log spam before pattern diff |
| **3 Falsify** | Test one cause at a time | 3–5 ranked hypotheses with disproof run | Bundle multiple fixes |
| **4 Ledger** | Cross-reference all runs | Each run ruled in/out; hypothesis table updated | New theory ignores prior runs |

Detail: [reference.md](./reference.md) — exit criteria, hypothesis ledger, stop-the-line, Prove-It, verification gate.

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

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Change-control (application code)

When editing app/source code, follow [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) (patch budget, confidence, no patch before diagnosis). This skill owns steps 1–4 of that sequence.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Similar bug / policy may exist in vault | [`/vault-recall`](../vault-recall/SKILL.md) — optional before step 1 when prior `decisions/` or `sessions/` may apply |
| Fix validated — write RCA for engineers | [`/fix-record`](../fix-record/SKILL.md) |
| Fix validated — episodic memory for later recall | [`/vault-capture`](../vault-capture/SKILL.md) — condensed, not full RCA; **optional** |
| End of day — batch triage | [`/vault-daily`](../vault-daily/SKILL.md) |
| Review debug patch or skill/rule PR before merge | [`/scrutinize`](../scrutinize/SKILL.md) |
| Bug involves SQL / schema / prod data | [`/builder-schema`](../builder-schema/SKILL.md) + production safety rules |

After verification passes: **vault autolog is mandatory** for any verified fix patch (bullet in daily) — see [reference.md](./reference.md) § Verification gate step 5 and [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc). **Then offer** `/fix-record` when non-trivial, or **`/vault-capture`** for a short session note (optional; not a substitute for RCA).

## Reference depth (load on demand)

[`reference.md`](./reference.md) — pattern analysis, boundary evidence, backward trace, stop-the-line, reduce, bisection, log probe budget, Prove-It, untrusted errors, verification gate, hypothesis ledger, instrumentation lifecycle, rationalizations, architecture escape, fix gate, verification protocol.

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md). English labels; Thai ~60% body prose.

| Turn | Minimum sections |
|------|------------------|
| Mid-session | STATUS, OBJECTIVE, DISCOVERIES (ledger / hypothesis table), NEXT ACTIONS, CONFIDENCE |
| Close-out | All sections; pass verification gate + callee redirect cleanup + **vault autolog** before STATUS=READY |

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

## 1. Reproduce reliably

Build a runnable repro before anything else.

- **Read errors fully** — complete stack traces, line numbers, error codes; don't skim warnings that sit above the throw site.
- **Check recent changes** — when a repro exists, scan `git log` / diff, new dependencies, config or env drift, deploy vs local differences.
- **Who runs the repro** ([reference.md](./reference.md) § Reproduction routing):
  - Existing failing test → run it yourself
  - Simple CLI/curl/script repro → write and run it yourself
  - UI, manual steps, or bundled/HMR cache → numbered steps for user; offer to write a script
- **Reliable repro** → capture exact steps, inputs, and environment as a runnable artifact: failing test, curl script, CLI invocation, replay harness.
- **Flaky repro** → the bug is not yet debuggable. Raise the rate first: loop the trigger, parallelise, add stress, narrow timing windows, replace blind sleeps with condition polls ([reference.md](./reference.md) § Condition-based waiting). 50% flake is debuggable; 1% is not.
- **No repro at all** → stop. Say so explicitly. Ask the user for env access, captured artifacts (HAR, log dump, core), or permission to instrument. Do **not** proceed to hypothesise.

Target: a fast (1–5 s), deterministic pass/fail signal. Pin time, seed the RNG, freeze network, isolate filesystem.

**Exit step 1** only when [reference.md](./reference.md) § Phase 1 exit criteria are satisfied (artifacts, not intuition).

## 2. Know the fail path

Once reproducible, find *where* the code breaks and *what stops it from breaking*. The differential narrows the search.

0. **Working vs broken** — if similar working code exists, diff every behavioral difference before heavy tooling ([reference.md](./reference.md) § Pattern analysis).
1. **Attach a debugger.** If the env supports it, attach and step to the failure site. One breakpoint beats ten logs. Do this **before** turning any knobs.
2. **Source trace + knob enumeration.** If no debugger (or it can't reach the bug), trace the code path end-to-end and list every knob that can influence the outcome:
   - config flags, env vars, feature toggles
   - branch conditions, input shape
   - timing, concurrency, build options
   Each knob is a candidate axis to flip in the differential. Flip one at a time.
3. **In-code instrumentation.** If outside knobs can't move the failure, go inside: tagged logs at the suspected fail site ([reference.md](./reference.md) § Instrumentation lifecycle). Let the trace show where reality diverges from your model.
4. **Multi-component boundaries** — when failure crosses layers, one boundary logging pass to see **which** component diverges first ([reference.md](./reference.md) § Boundary evidence). Then narrow to that layer.
5. **Deep stack / bad value far from origin** — trace backward to the first bad input ([reference.md](./reference.md) § Root-cause backward tracing). Fix at source, not at the symptom handler.

Try tactics in order — escalate only when the prior tactic fails.

## 3. Falsify the hypothesis

When a candidate root cause surfaces, scrutinise it **before** testing it.

- Does it actually explain the symptom end-to-end? Walk it through.
- What is the simplest **proof**? What is the cleanest **disproof**?
- Run the **disproof first**. If the hypothesis survives, it's real. If it dies, you saved yourself from chasing a phantom.
- Generate 3–5 ranked hypotheses, not one. Single-hypothesis thinking anchors on the first plausible idea.
- Write the leading hypothesis explicitly: "I think X because Y" — vague theories are untestable.
- Update the **hypothesis table** after each run; cite evidence ([reference.md](./reference.md) § Hypothesis ledger).

## 4. Every run is a breadcrumb

Maintain a running **ledger** of every experiment in this session. Each entry: what changed, what happened, what it ruled in or out.

- When a new hypothesis surfaces, walk the ledger. Does it hold for **every** prior observation, not just the most recent?
- If any past run contradicts it, the hypothesis is wrong or incomplete — refine or discard.
- When in doubt, design the **single experiment** whose outcome makes it certain. Run that next, instead of churning on adjacent runs.
- Update the ledger after every run. It is your memory across the session.

---

## Operating rules

- Recite the mantra block **once** per debug session, in your first response, **only if** the user attached `/debug`. Do not re-recite mid-session.
- Recite **verbatim**. Never paraphrase, shorten, or skip lines of the recital.
- If the user says "skip the mantra" → skip the recital but still apply the four steps silently.
- Apply the four steps **in order**:
  - Do not propose a fix before #1 exit criteria are met ([reference.md](./reference.md) § Phase 1 exit criteria).
  - Do not start testing hypotheses before #2 has narrowed the fail path.
  - Do not commit to a hypothesis before #3 has tried to disprove it.
  - Do not declare a hypothesis correct until #4 confirms it against every prior breadcrumb.
- **Fix gate:** before the first patch, pin a failing repro artifact (test or script) unless the user explicitly waives — see [reference.md](./reference.md) § Fix gate.
- **Instrumentation:** do not remove probes until fix is log-verified — see [reference.md](./reference.md) § Instrumentation lifecycle.
- **3+ failed fix attempts:** stop patching; revisit step 1 or discuss architecture — see [reference.md](./reference.md) § Architecture escape.
- If you catch yourself proposing a fix without a reliable repro, stop and return to step 1.
- If you catch red-flag thinking, stop — see [reference.md](./reference.md) § Red flags and § Rationalizations.
- **Stop-the-line:** on unexpected failure — no new features until verification passes ([reference.md](./reference.md) § Stop-the-line rule).
- **Vault autolog (mandatory):** after any **verified fix patch** in the turn, run [reference.md](./reference.md) § Verification gate step 5 — [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc). Do **not** set STATUS=READY without `Vault daily: updated vault/daily/YYYY-MM-DD.md` or documented skip reason.
- **Close-out:** pass verification gate + verification protocol; if the fix changed call targets, grep old symbols per [`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc) — see [reference.md](./reference.md) § Verification protocol; then offer `/fix-record` when appropriate, or **`/vault-capture`** for a short session note (**optional** — autolog bullet is separate and mandatory).
- The mantra is a constraint **you** carry through the session — not advice to deliver back to the user.
