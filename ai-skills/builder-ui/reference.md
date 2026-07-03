# builder-ui — reference

## Slice brief intake (phase 0)

Run **before** visual analysis when any of:

- User says **`slice N go`** after `/builder-feature`
- Chat contains **`## Slice N brief (from /builder-feature)`**
- User pastes a slice row from a feature **Slice backlog** table

### Required fields (block if missing — ask or hand back to `/builder-feature`)

Contract: [`templates/template.slice-brief.md`](../../templates/template.slice-brief.md).

| Field | Use |
|-------|-----|
| **Outcome** | Scope lock for this slice |
| **Non-goals** | What not to touch |
| **Verify** | Command or walkthrough for close-out |
| **Workflow steps covered** | Optional — maps to components |

If **standalone** `/builder-ui` (no feature plan): phase 0 = confirm scope + non-goals in chat; no brief required.

### Intake protocol

1. Parse brief into SKILL REPORT OBJECTIVE + non-goals.
2. Do **not** redesign cross-slice architecture — implement brief; escalate conflicts to `/builder-feature`.
3. Close-out: cite **Verify** from brief in phase 7 gate.

---

## Build modes (phase 0 — pick one)

| Mode | User signals | Goal | Trade-off |
|------|--------------|------|-----------|
| **Pixel** | Figma **Copy as SVG**, "ตรงเป๊ะ", pixel-perfect, landing/demo | Visual match to frame using **extracted SVG values** | Less reusable; document in SKILL REPORT |
| **System** | slice brief, production app, `/builder-feature` handoff | Reusable components + tokens + responsive system | ~85–95% visual match acceptable |

**Default:** System. Switch to Pixel when user provides SVG and asks for fidelity over component extraction.

---

## Figma / SVG intake (Pixel mode)

### Required inputs

| Input | Required | Use |
|-------|----------|-----|
| SVG (Figma Copy as SVG) | **Yes** | Colors, positions, sizes, fonts, radius, paths |
| Screenshot (same frame) | Strongly recommended | Shadows, gradients, blur — SVG often incomplete |
| Stack | Ask if missing | e.g. React+TypeScript+Tailwind, HTML/CSS only |
| Functional requirements | Optional | Scope; do not invent interactions |

### Extraction protocol

1. Read `viewBox` / root `width`×`height` → frame size.
2. Parse groups: layout regions (header, sidebar, main, cards).
3. Extract **literal** values — `fill`, `stroke`, `font-family`, `font-size`, `font-weight`, `x`/`y`/`width`/`height`, `rx`/`ry`, `opacity`, `filter`.
4. Compare screenshot → note gaps (gradient angle, box-shadow, backdrop-blur).
5. Rebuild with **flex/grid** from structure — avoid absolute-position soup unless export is flat-only.
6. **Do not** paste the whole SVG as the page component unless user requests embed-only.

### Stack appendix (when user specifies)

| Stack | Defaults |
|-------|----------|
| React + TS + Tailwind | Functional components, no inline styles, shared primitives |
| HTML/CSS | Semantic markup, CSS variables from extracted tokens |
| Vue / Svelte | Match project conventions if repo context exists |

### Pixel workflow (phases 1–7)

| Phase | Deliver |
|-------|---------|
| 1 | SVG parse + screenshot diff notes |
| 2 | Frame layout (grid/flex), spacing from SVG |
| 3 | UI blocks (split for readability — not one file if >300 lines) |
| 4 | Token table from extracted values |
| 5 | **Assumptions** only for missing interaction — see below |
| 6 | Minimum a11y: semantic tags, `aria-label` on icon-only controls |
| 7 | Visual verify (browser snapshot/screenshot) + close-out gate § Pixel |

### Confidence report (required in Pixel; use in System when inferring)

For each inferred item:

| Item | Confidence | Why |
|------|------------|-----|
| e.g. primary `#2563EB` | High | `fill` in SVG path `...` |
| e.g. hover state | Low | not in SVG — listed under Assumptions |

**High** = literal in SVG or confirmed by screenshot · **Medium** = derived from spacing rhythm · **Low** = guessed — must appear in Assumptions, not implemented as fact.

### Assumptions block

When SVG/screenshot lack interaction (hover, click, validation):

```markdown
## Assumptions
- [ ] Button hover: not in export — skipped
- [ ] Modal open: user did not specify — static only
```

Never hallucinate interactions the design does not show.

### Component checklist (System mode; optional in Pixel)

Header, Sidebar, Navigation, Card, Table, Modal, Button, Input, Select, Tabs, Badge, Avatar, Pagination, Empty State, Loading State — extract only what appears in the design.

---

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

- monolithic inline SVG as entire page (Pixel mode — unless embed-only requested)
- screenshot-only cloning **without** parsing SVG values (Pixel mode)
- pixel-perfect obsession **in System mode** when reuse matters
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

## Web quality (beyond browser MCP)

For performance, accessibility, SEO, and best-practice audits beyond runtime browser MCP:

| Topic | Pack scope |
|-------|------------|
| Holistic audit | Phases 1–7 + close-out gate in this skill |
| Core Web Vitals | Document in Verification Plan; measure with user tooling |
| Accessibility | a11y checklist in phases; browser snapshot for runtime |
| Performance | Note hot paths in UI Analysis; avoid unbounded re-renders |

This pack owns **component architecture + tokens + a11y checklist** in phases 1–7. Lighthouse-grade or SEO depth requires user-chosen external tooling — not linked from this pack.

---

## Close-out deliverables (SKILL REPORT `ARTIFACTS`)

Canonical list for close-out `ARTIFACTS` — map to workflow phase outputs:

| Deliverable | Phases |
|-------------|--------|
| UI Analysis | 1 |
| Component Architecture | 2 |
| Design System | 3 |
| Responsive Plan | 4 |
| Frontend Structure | 5–6 |
| Verification Plan | 7 |

**Pixel mode ARTIFACTS:** Extracted tokens, layout notes, Confidence table, Assumptions, implementation paths (component tree optional).

---

## Close-out verification gate — Pixel mode

| # | Proof |
|---|--------|
| 1 | Values cited from SVG (colors, spacing, type) — not guessed |
| 2 | Screenshot compared for shadow/gradient gaps — noted in DISCOVERIES |
| 3 | Assumptions block for anything not in export |
| 4 | Confidence table in SKILL REPORT or close-out |
| 5 | Browser/visual check when runtime available |
| 6 | Vault autolog if verified patch — [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) |

---

## Close-out verification gate — System mode (phase 7)

| # | Proof |
|---|--------|
| 1 | Component tree + tokens documented |
| 2 | a11y checklist passed (keyboard, focus, contrast) |
| 3 | Responsive breakpoints defined — not one width only |
| 4 | Browser/runtime check on critical path if UI behavior claimed — use Cursor browser MCP (`browser_snapshot`, `browser_take_screenshot`) per [scrutinize/reference.md](../scrutinize/reference.md) § Browser / UI review |
| 5 | **Callee redirect cleanup** — if implementation changed call targets, grep old symbols per [`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc) |
| 6 | **Vault autolog** — [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc): `Read` `templates/vault/notes/template.vault-daily.md` if missing → `Write` `vault/daily/<today>.md` → `append-daily`; reply **`Vault daily: updated vault/daily/YYYY-MM-DD.md`** |
| 7 | `/scrutinize` before merge |

IDENTIFY → RUN (snapshot/test/story) → READ output → autolog → then pass/reject.
