---
name: builder-ui
metadata:
  version: "1.3.2"
description: >-
  Use when building UI from Figma (Copy as SVG), screenshots, or mocks — pixel-fidelity
  or component-system paths. Layout, tokens, responsive, a11y, browser verify. Slice
  briefs from /builder-feature. Invoke /builder-ui or "slice N go".
paths: "**/*.{tsx,jsx,vue,svelte,css,scss,html,rs}"
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Skill: builder-ui

Role: Systems UI Architect

Mission: Analyze and reconstruct UI into maintainable, reusable, responsive, accessible frontend architecture.

## Purpose

Production UI — maintainable, responsive, accessible. **Do NOT:** monolithic SVG dump · logic in presentation · skip a11y.

**Build mode** (phase 0): **Pixel** (Figma SVG + ตรงเป๊ะ) · **System** (default). [reference.md](./reference.md) § Build modes.

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails · app code: [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc).

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Low-token 100% pixel (PNG/SVG) | [`/builder-ui-cost`](../builder-ui-cost/SKILL.md) |
| Full-stack feature (plan) | [`/builder-feature`](../builder-feature/SKILL.md) |
| Slice brief from feature plan | Load [reference.md](./reference.md) § Slice brief intake **before** phase 1 |
| API contract for UI | [`/builder-api`](../builder-api/SKILL.md) |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |
| Runtime UI bug | [`/debug`](../debug/SKILL.md) |

Deliver in **vertical slices** — [builder-feature/reference-slice-handoff.md](../builder-feature/reference-slice-handoff.md) § Slice backlog.

## Quick cheat sheet

| Step | Action |
|------|--------|
| 0 | **Mode:** Pixel (Figma SVG + ตรงเป๊ะ) or System (default) · stack if not stated |
| 0b | **Cost:** attach once · compact intake · never echo SVG — [reference.md](./reference.md) § Cost-efficient intake |
| 1–7 | Phases per mode — [reference.md](./reference.md) § Workflow (detail) |

| # | Phase | Gate |
|---|--------|------|
| 0 | Intake | brief or SVG + screenshot + mode |
| 1 | Visual analysis | hierarchy map |
| 2 | Layout | responsive plan |
| 3 | Components | reuse tree |
| 4 | Design system | tokens + variants |
| 5 | Interaction | state contract |
| 6 | a11y | keyboard + contrast |
| 7 | Verification | [reference.md](./reference.md) § Close-out gate |

Philosophy & phase detail: [reference.md](./reference.md) § Build modes · § Workflow (detail).

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-ui` |
|---------|---------------|
| STATUS | IN_PROGRESS = phase N; READY = close-out gate **and** vault autolog passed; BLOCKED = missing reference/input |
| OBJECTIVE | Mode + UI from references — fidelity (Pixel) or architecture (System) |
| DISCOVERIES | Reference patterns, hierarchy, reuse opportunities, a11y/responsive concerns |
| ANALYSIS | Architecture choices, state boundaries, duplication risks |
| RISKS | Inconsistent design system, missing a11y, responsive gaps |
| ARTIFACTS | Close-out deliverables: [reference.md](./reference.md) § Close-out deliverables |
| NEXT ACTIONS | Next workflow phase or open question |
| HANDOFF | `/builder-feature` · `/scrutinize` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.
