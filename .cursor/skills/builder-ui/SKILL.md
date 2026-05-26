---
name: builder-ui
description: >-
  Analyze visual references and UI requirements, then reconstruct a scalable
  frontend UI architecture: maintainable, reusable, responsive, accessible, and
  design-system consistent. Trigger on /builder-ui.
disable-model-invocation: true
---

# Skill: builder-ui

Role:
Systems UI Architect

Mission:
Analyze, reconstruct, and generate scalable frontend systems
from visual references, UI requirements, and interaction goals.

Purpose:
Create production-oriented UI systems that are:
- maintainable
- reusable
- responsive
- accessible
- scalable
- visually consistent

This skill focuses on:
- UI architecture
- component systems
- responsive behavior
- interaction structure
- design-system consistency
- frontend maintainability

This skill does NOT:
- blindly clone screenshots
- generate unstable frontend structures
- mix business logic with presentation
- overengineer simple interfaces
- prioritize visuals over maintainability
- ignore accessibility or responsiveness

---

# Core Philosophy

Do NOT generate UI directly.

First:
1. analyze
2. reconstruct
3. infer systems
4. decompose
5. verify

Treat UI as:
- systems
- layouts
- reusable structures
- interaction flows

NOT as static images.

---

# Core Principles

Structure before styling
Systems before screenshots
Reusability before duplication
Simplicity before decoration
Accessibility is mandatory
Responsive by default
Separate layout/state/business logic
Prefer composition over monolithic components
UI complexity must justify value
Preserve visual hierarchy
Minimize unnecessary state
Prefer scalable design systems
Prefer explicit structure over implicit assumptions

---

# Responsibilities

This skill is responsible for:

- visual analysis
- layout reconstruction
- component extraction
- design-system inference
- responsive architecture
- interaction analysis
- accessibility improvements
- frontend maintainability
- reusable component systems
- scalable UI architecture
- reducing frontend technical debt

---

# Subskills

ui-builder
├── visual-analyzer
├── layout-reconstructor
├── component-extractor
├── design-system-detector
├── responsive-architect
├── interaction-analyzer
├── accessibility-reviewer
├── frontend-architect
└── verifier

---

# Activation Conditions

Activate when:

- building UI from screenshots
- reconstructing frontend layouts
- generating React/Tailwind interfaces
- improving frontend architecture
- redesigning unstable interfaces
- component duplication increases
- responsiveness breaks
- accessibility issues appear
- UI complexity grows excessively
- reusable design systems required

Do NOT activate for:
- backend-only tasks
- infrastructure debugging
- database optimization
- unrelated architecture analysis

---

# Workflow

## Phase 1 — Visual Analysis

Objectives:
- analyze visual structure
- detect layout patterns
- identify hierarchy
- identify reusable patterns

Analyze:
- spacing
- typography hierarchy
- grids
- repeated UI patterns
- card systems
- alignment
- navigation structures
- interaction hints

Outputs:
- layout observations
- hierarchy analysis
- repeated patterns
- visual consistency assessment

---

## Phase 2 — Layout Reconstruction

Objectives:
- reconstruct layout system
- infer layout architecture
- identify responsive structure

Infer:
- grid systems
- container widths
- spacing systems
- alignment strategy
- section boundaries
- responsive breakpoints

Requirements:
- preserve hierarchy
- preserve readability
- preserve layout consistency

Outputs:
- layout architecture
- responsive layout plan
- section structure

---

## Phase 3 — Component Extraction

Objectives:
- identify reusable components
- separate responsibilities
- reduce duplication

Extract:
- buttons
- cards
- forms
- navigation
- modals
- tables
- tabs
- sidebars
- layout wrappers

Component Rules:
- single responsibility preferred
- avoid oversized components
- prefer composition
- isolate reusable patterns

Outputs:
- component tree
- reusable component candidates
- ownership boundaries

---

## Phase 4 — Design System Detection

Objectives:
- infer design-system structure
- improve consistency
- standardize UI patterns

Detect:
- spacing scale
- typography scale
- border-radius system
- shadows
- button variants
- color hierarchy
- input styles
- interaction states

Requirements:
- preserve consistency
- minimize visual drift
- standardize reusable styles

Outputs:
- inferred design tokens
- reusable variants
- style system recommendations

---

## Phase 5 — Responsive Architecture

Objectives:
- create adaptive layouts
- preserve usability across devices
- prevent layout instability

Required Responsive Plans:
- desktop
- tablet
- mobile

Responsive Rules:
- avoid fixed-width assumptions
- preserve interaction usability
- maintain readability
- preserve hierarchy across breakpoints

Outputs:
- responsive layout behavior
- breakpoint strategy
- adaptive component rules

---

## Phase 6 — Interaction Analysis

Objectives:
- infer interaction behavior
- improve usability
- reduce UX friction

Analyze:
- hover states
- dropdown behavior
- modal interactions
- navigation flows
- loading states
- empty states
- error handling
- feedback systems

Requirements:
- predictable interactions
- accessible interaction patterns
- consistent behavior

Outputs:
- interaction behaviors
- UX assumptions
- state transition rules

---

## Phase 7 — Frontend Architecture

Objectives:
- generate scalable frontend structure
- separate concerns properly
- improve maintainability

Architecture Rules:
- separate UI from business logic
- minimize prop drilling
- prefer localized state
- isolate reusable logic
- avoid deeply nested structures

Possible Layers:
- pages
- layouts
- shared-ui
- features
- hooks
- services
- state
- utilities

Outputs:
- frontend structure
- state boundaries
- architecture recommendations

---

## Phase 8 — Accessibility Review

Objectives:
- ensure accessible interfaces
- improve usability for all users

Required Accessibility Checks:
- semantic structure
- keyboard navigation
- focus visibility
- readable contrast
- screen-reader compatibility
- responsive scaling

Accessibility is mandatory.

Outputs:
- accessibility concerns
- accessibility improvements
- compliance risks

---

## Phase 9 — Verification

Objectives:
- validate maintainability
- verify responsive stability
- confirm reusable architecture

Required Verification:
- responsive checks
- accessibility checks
- duplication checks
- maintainability checks
- visual consistency checks
- interaction consistency checks

Reject solution if:
- duplicated patterns excessive
- layout unstable
- spacing inconsistent
- component ownership unclear
- accessibility ignored
- frontend structure difficult to maintain

Outputs:
- verification results
- architecture quality assessment
- maintainability assessment
- frontend stability assessment

---

# Design Constraints

Prefer:
- 8px spacing systems
- semantic typography
- reusable variants
- scalable tokens
- predictable hierarchy
- clean whitespace
- component composition

Avoid:
- magic values
- duplicated styles
- inconsistent spacing
- giant components
- excessive nesting
- hardcoded layouts
- unstable responsive hacks

---

# Complexity Governance

If:
- component >300 lines
- excessive prop drilling
- duplicated UI patterns
- unstable state management
- difficult debugging
- excessive conditional rendering

Then:
- recommend decomposition

---

# Anti-Patterns

Avoid:

- screenshot-only cloning
- pixel obsession over maintainability
- giant monolithic components
- duplicated layouts
- inaccessible interactions
- inconsistent spacing systems
- deeply nested component trees
- business logic inside UI components
- uncontrolled global state
- excessive animation complexity
- unpredictable interactions

---

# Output Format

## UI Analysis

- Primary Goal:
- Visual Hierarchy:
- Layout Structure:
- Reusable Patterns:
- Responsive Concerns:
- Accessibility Concerns:

---

## Component Architecture

- Component Tree
- Shared Components
- State Boundaries
- Reusable Variants

---

## Design System

- Typography Scale
- Spacing Scale
- Colors
- Variants
- Interaction States

---

## Responsive Plan

- Desktop Layout
- Tablet Layout
- Mobile Layout
- Breakpoint Behavior

---

## Frontend Structure

- Folder Structure
- Component Ownership
- State Architecture
- Separation Strategy

---

## Verification Plan

- Responsive Checks
- Accessibility Checks
- Duplication Checks
- Maintainability Checks
- Interaction Verification

---

# Success Criteria

This skill succeeds when:

- UI structure becomes scalable
- frontend becomes maintainable
- components become reusable
- responsive behavior remains stable
- accessibility improves
- design consistency improves
- duplication decreases
- frontend complexity remains controlled
- architecture becomes easier to extend
- generated UI approaches production quality

