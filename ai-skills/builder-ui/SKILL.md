---
name: builder-ui
metadata:
  version: "1.2.4"
description: >-
  Design scalable, accessible UI systems from visual references — layout,
  components, responsive behavior, a11y. Invoke with /builder-ui for frontend
  architecture and component structure.
paths: "**/*.{tsx,jsx,vue,svelte,css,scss,html,rs}"
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
- blindly clone screenshots
- mix business logic inside presentation
- overengineer simple interfaces
- sacrifice accessibility/responsiveness for speed

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Full-stack feature | [`/builder-feature`](../builder-feature/SKILL.md) |
| API contract for UI | [`/builder-api`](../builder-api/SKILL.md) |
| Pre-merge review | [`/scrutinize`](../scrutinize/SKILL.md) |
| Runtime UI bug | [`/debug`](../debug/SKILL.md) |

Deliver in **vertical slices** — [builder-feature/reference.md](../builder-feature/reference.md) § Incremental vertical slices.

## Quick cheat sheet

| # | Phase | Gate |
|---|--------|------|
| 1 | Visual analysis | hierarchy map |
| 2 | Layout | responsive plan |
| 3 | Components | reuse tree |
| 4 | Design system | tokens + variants |
| 5 | Interaction | state contract |
| 6 | a11y | keyboard + contrast |
| 7 | Verification | [reference.md](./reference.md) § Close-out gate |

---

# Core philosophy

Do NOT generate UI directly from pixels.

First:
1. analyze visual hierarchy
2. reconstruct layout system
3. extract reusable components
4. infer design-system rules
5. verify responsive + accessibility behavior

Treat UI as systems and interaction flows, not static images.

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
| 1 | Visual analysis | observations, hierarchy, patterns |
| 2 | Layout reconstruction | layout architecture, responsive plan |
| 3 | Component extraction | component tree, shared candidates |
| 4 | Design-system inference | tokens, variant rules |
| 5 | Interaction + state | interaction contract, state notes |
| 6 | Accessibility review | a11y concerns and fixes |
| 7 | Verification | pass/reject per checklist |

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/builder-ui` |
|---------|---------------|
| STATUS | IN_PROGRESS = phase N; READY = close-out gate passed; BLOCKED = missing reference/input |
| OBJECTIVE | UI architecture from references — components, design system, responsive plan |
| DISCOVERIES | Reference patterns, hierarchy, reuse opportunities, a11y/responsive concerns |
| ANALYSIS | Architecture choices, state boundaries, duplication risks |
| RISKS | Inconsistent design system, missing a11y, responsive gaps |
| ARTIFACTS | Close-out: UI Analysis, Component Architecture, Design System, Responsive Plan, Frontend Structure, Verification Plan |
| NEXT ACTIONS | Next workflow phase or open question |
| HANDOFF | `/builder-feature` · `/scrutinize` · `none` |
| CONFIDENCE | 0–100; pass [reference.md](./reference.md) § Close-out gate before READY |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE.

---

# Reference

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.
