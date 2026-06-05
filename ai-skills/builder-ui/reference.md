# builder-ui — reference

## Workflow (detail)

Load this section when executing a phase. Run phases **in order**.

### 1) Visual analysis

Analyze spacing rhythm, typography hierarchy, grid/container structure, repeated patterns, navigation and interaction cues.

Output: UI observations, hierarchy assessment, repeated pattern list.

### 2) Layout reconstruction

Infer layout grid, container widths, spacing system, breakpoints (desktop/tablet/mobile).

Output: layout architecture, responsive layout plan.

### 3) Component extraction

Extract buttons, cards, forms, nav, modals, tables, layout wrappers. Single responsibility; prefer composition.

Output: component tree, shared component candidates, ownership boundaries.

### 4) Design-system inference

Define spacing scale, typography scale, color/surface hierarchy, radius/shadow system, component variants and states.

Output: token proposal, variant rules.

### 5) Interaction + state plan

Specify hover/focus/active/disabled, loading/empty/error, modal/dropdown/nav behavior, state ownership.

Output: interaction contract, state transition notes.

### 6) Accessibility review

Require semantic structure, keyboard navigation, focus visibility, contrast, screen-reader compatibility.

Output: a11y concerns and fixes.

### 7) Verification

Verify responsive behavior, reuse, visual consistency, a11y and interaction consistency.

Reject if: excessive duplication, unstable layout across breakpoints, unclear ownership, accessibility ignored.

---

## Extended anti-patterns

- screenshot-only cloning
- pixel-perfect obsession over maintainability
- giant monolithic components
- duplicated layouts
- inconsistent spacing systems
- deeply nested trees
- business logic in UI components
- uncontrolled global state
- inaccessible interactions
- excessive animation complexity

## Detailed review prompts

### Visual structure
- Is hierarchy clear at first scan?
- Are spacing jumps intentional?
- Are repeated structures represented as shared components?

### Responsive
- What breaks first on narrow viewports?
- Which components need adaptive variants?
- Are touch targets usable on mobile?

### Accessibility
- Can all interactions be keyboard-driven?
- Are focus rings visible and consistent?
- Do color pairs pass contrast targets?

### Maintainability
- Any component >300 lines?
- Prop drilling hotspots?
- Reusable variants extracted?

---

## Static HTML mock (optional, out of repo)

For **standalone demos** (no framework build), the consumer project may keep mocks locally — not in the agent-skills repo.

| File | Role |
|------|------|
| `index.html` | Semantic layout, form labels, Thai/EN copy |
| `styles.css` | Tokens, components, responsive |
| `README.md` | How to open locally |

**Workflow:** Run phases 1–4 on the reference (screenshot/mock) → implement HTML/CSS in the target app → phase 6–7 checklist.

**Non-goals for mocks:** backend, auth, framework migration — unless user requests next step.

---

## Close-out verification gate (phase 7)

| # | Proof |
|---|--------|
| 1 | Component tree + tokens documented |
| 2 | a11y checklist passed (keyboard, focus, contrast) |
| 3 | Responsive breakpoints defined — not one width only |
| 4 | Browser/runtime check on critical path if UI behavior claimed — use Cursor browser MCP (`browser_snapshot`, `browser_take_screenshot`) per [scrutinize/reference.md](../scrutinize/reference.md) § Browser / UI review |
| 5 | **Callee redirect cleanup** — if implementation changed call targets, grep old symbols per [`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc) |
| 6 | `/scrutinize` before merge |

IDENTIFY → RUN (snapshot/test/story) → READ output → then pass/reject.
