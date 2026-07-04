---
name: builder-ui-cost
metadata:
  version: "1.0.1"
description: >-
  Low-token Figma-to-UI targeting pixel match (SVG literals + verify). Attach PNG
  and/or SVG once; intake manifest then build; never echo exports. Invoke
  /builder-ui-cost. Hand off to /builder-ui for production hardening.
paths: "**/*.{tsx,jsx,vue,svelte,css,scss,html}"
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation).
disable-model-invocation: true
---

# Skill: builder-ui-cost

Role: Pixel UI operator (cost-optimized)

Mission: Reconstruct UI **pixel match** (SVG literals + verify) from PNG and/or SVG at **minimum session tokens**.

## Purpose

**Pixel match** = literal SVG values where exported · PNG/micro-PNG for effects · `verify` catches deltas; unknowns → Assumptions only. **Lowest cost** = one attach · no echo · manifest file · split-chat for build. **Do NOT:** monolithic SVG dump · long essays · re-attach same frame.

Detail: [reference.md](./reference.md) only — do not load `builder-ui/reference.md` unless handoff.

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails · app code: [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc).

## Handoffs

| Situation | Skill |
|-----------|--------|
| Production components, slices, design system | [`/builder-ui`](../builder-ui/SKILL.md) System mode |
| Full feature plan | [`/builder-feature`](../builder-feature/SKILL.md) |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |
| Runtime UI bug | [`/debug`](../debug/SKILL.md) |

## Quick cheat sheet

| Step | Action |
|------|--------|
| 0 | Stack if missing · pick attach path — [reference.md](./reference.md) § Attach strategy |
| 1 | **Intake** — attach once · write `ui-intake.manifest.md` · chat **≤12 lines** (pointer + gaps only) |
| 2 | User: `build` — code files · REPORT ≤15 lines |
| 3 | User: `verify` — one browser compare · then READY |

| Iron law | |
|----------|--|
| Attach | Once per thread — re-attach only if design changed |
| Echo | **Never** raw SVG, paths, base64 |
| Fidelity | Values from manifest — Low confidence → Assumptions, not code |
| Cost | Load **this** reference only; skip `builder-ui` workflow tables |

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-ui-cost` |
|---------|-------------------|
| STATUS | IN_PROGRESS = turn 1–2; READY = verify passed or user waived · vault autolog if patch |
| OBJECTIVE | Pixel match · minimum tokens · stack + attach path |
| DISCOVERIES | Extracted tokens, SVG/screenshot gaps |
| ANALYSIS | Attach path taken, cost levers used |
| RISKS | SVG-heavy bill on turn 1; waived verify |
| ARTIFACTS | [reference.md](./reference.md) § Close-out deliverables |
| NEXT ACTIONS | `build` · `verify` · or handoff `/builder-ui` |
| HANDOFF | `/builder-ui` System · `/scrutinize` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

[reference.md](./reference.md)
