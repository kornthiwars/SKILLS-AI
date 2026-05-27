---
name: builder-ui
metadata:
  version: "1.1.0"
description: >-
  Design scalable, accessible UI systems from visual references — layout,
  components, responsive behavior, a11y. Invoke with /builder-ui for frontend
  architecture and component structure.
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

# Output format

Short turns: use **Summary / Details / Next step** section headers; expand the full Output format below when delivering the final artifact.

## UI Analysis
- Primary Goal:
- Visual Hierarchy:
- Layout Structure:
- Reusable Patterns:
- Responsive Concerns:
- Accessibility Concerns:

## Component Architecture
- Component Tree
- Shared Components
- State Boundaries
- Reusable Variants

## Design System
- Typography Scale
- Spacing Scale
- Colors
- Variants
- Interaction States

## Responsive Plan
- Desktop Layout
- Tablet Layout
- Mobile Layout
- Breakpoint Behavior

## Frontend Structure
- Folder Structure
- Component Ownership
- State Architecture
- Separation Strategy

## Verification Plan
- Responsive Checks
- Accessibility Checks
- Duplication Checks
- Maintainability Checks
- Interaction Verification

---

# Reference

See [reference.md](./reference.md) for workflow detail, checklists, and anti-patterns.
