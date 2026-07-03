---
name: builder-ui
metadata:
  version: "1.3.0"
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

Build production-oriented UI that is:
- maintainable
- reusable
- responsive
- accessible
- scalable
- visually consistent

Do NOT:
- dump Figma SVG as one monolithic component (unless user asks embed-only)
- mix business logic inside presentation
- overengineer simple interfaces
- sacrifice accessibility for speed (minimum semantic + labels even in Pixel mode)

**Build mode** (phase 0): **Pixel** = visual fidelity from SVG values · **System** = reusable components + tokens (default for slice backlog). Detail: [reference.md](./reference.md) § Build modes.

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails · app code: [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc).

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
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

---

# Core philosophy

**System mode (default):** analyze hierarchy → layout system → reusable components → design tokens → verify responsive + a11y.

**Pixel mode:** extract **real values** from Figma SVG (colors, spacing, type, radius) → rebuild UI to match the frame → validate shadows/gradients against screenshot. Trade maintainability for fidelity — state explicitly in SKILL REPORT.

Do not generate unanalyzed UI from pixels or SVG paths alone.

---

# Core principles

- Structure before styling
- Systems before screenshots
- Reusability before duplication
- Simplicity before decoration
- Accessibility is mandatory
- Responsive by default
- Separate layout/state/business logic
- Prefer composition over monoliths
- Minimize unnecessary state
- Complexity must justify value

---

# Workflow

Execute phases **in order**. Detail: [reference.md](./reference.md) § Workflow (detail).

| # | Phase | Deliver |
|---|--------|---------|
| 0 | Intake | mode, brief or SVG+screenshot, stack |
| 1 | Visual analysis | observations, hierarchy, patterns |
| 2 | Layout reconstruction | layout architecture, responsive plan |
| 3 | Component extraction | component tree, shared candidates |
| 4 | Design-system inference | tokens, variant rules |
| 5 | Interaction + state | interaction contract, state notes |
| 6 | Accessibility review | a11y concerns and fixes |
| 7 | Verification + vault autolog | pass/reject per checklist; [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) (daily template if missing → `append-daily`) |

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
