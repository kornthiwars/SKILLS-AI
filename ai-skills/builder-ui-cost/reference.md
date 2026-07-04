# builder-ui-cost — reference

**Goal:** **Pixel match** (literal SVG + verify) at **lowest practical session tokens**. User may attach **PNG and/or SVG**.

**Not guaranteed:** automatic 100% on every property — see § Fidelity tiers.

---

## Fidelity tiers (honest targets)

| Tier | Path | Typography / border | Typical match |
|------|------|---------------------|---------------|
| **S** | A or B + SVG `font-*` / `stroke-*` | Literal in manifest | **~98–100%** |
| **A** | A/B, text as SVG paths | Measure from SVG bounds or micro-PNG | **~95–98%** |
| **B** | C PNG ≤1280 only | Vision + `verify` | **~92–96%** |

READY claims **Tier S or A** after `verify` with no unresolved deltas · Tier B cap CONFIDENCE at 90.

---

## Attach strategy (pick one — phase 0)

| Path | Attach | Best for | Cost | Fidelity |
|------|--------|----------|------|----------|
| **A — SVG + micro-PNG** | Trimmed **SVG** + optional **PNG crop** (effects only, ≤400px) | Shadows/blur + literals | **Lowest** when effects exist | Tier S/A |
| **B — SVG only** (prefer when no blur) | One frame, layers hidden | Vector UI, no heavy effects | **Lowest** when no micro-PNG needed | Tier S/A |
| **C — PNG only** | Full frame **≤1280px** crop | No SVG | Medium | Tier B |

**Default:** B if no blur/shadow · A if effects · C if no SVG.

**Forbidden:** 4K PNG + full SVG same frame — ask to drop one.

### User hygiene

| Input | Rule |
|-------|------|
| SVG | Copy as SVG · hidden layers removed · keep text as text when Figma allows |
| PNG | Crop artboard · ≤**1280px** (micro-PNG ≤400px for effects only) |
| Paste | **File attach** — not megabyte inline SVG |

---

## Mandatory turns

### Turn 1 — Intake (attach here)

1. Parse attachment · pick tier S/A/B.
2. **Write** `ui-intake.manifest.md` in repo (canonical — full tables allowed).
3. Chat reply **≤12 lines**: path, tier, frame size, `manifest: ui-intake.manifest.md`, top gaps, assumptions ≤3.

**Manifest file must include** § Typography & borders rows for every text style and bordered control in frame.

**Forbidden Turn 1:** component code · browser MCP · echoing SVG XML in chat.

### Turn 2 — Build

User: `build` (no re-attach). Read manifest from disk only.

**Agent:** code files · Tailwind **arbitrary** when default scale wrong (`text-[13px]`, `border-[1.5px]`) · REPORT ≤15 lines.

### Turn 3 — Verify

User: `verify` · one `browser_snapshot` · list deltas (size/weight/border/color) · fix if in budget.

`waive verify` → RISKS · CONFIDENCE cap 85.

### Split-chat (recommended for lowest cost)

| Chat | Action |
|------|--------|
| A | Attach → write `ui-intake.manifest.md` → ≤12 line pointer |
| B | `build from ui-intake.manifest.md` — **no attach** | saves **30–50%** on build context |

---

## Typography & borders (manifest rows — required)

| Property | SVG source | If text is paths | CSS/Tailwind |
|----------|------------|------------------|--------------|
| font-size | `font-size` | height of path group / manifest measure | `text-[Npx]` not `text-sm` when N≠14 |
| font-weight | `font-weight` | `stroke-width` or PNG compare | `font-[600]` etc. |
| line-height | `line-height` or derive | gap between lines in SVG | `leading-[Npx]` |
| letter-spacing | `letter-spacing` | — | `tracking-[Nem]` |
| border width | `stroke-width` | rect stroke | `border-[Npx]` |
| border color | `stroke` | — | exact hex |
| radius | `rx`/`ry` | — | `rounded-[Npx]` |

**Rule:** never round 13px → 14px without documenting in manifest `rounded: no`.

---

## Cost levers (additional vs v1.0.0)

| Lever | Δ tokens | Fidelity |
|-------|----------|----------|
| Manifest in **file** not chat | **−15–25%** output/history | Same or better (full table allowed) |
| Prefer **Path B** over A when no effects | **−10–30%** vs dual attach | Tier S when SVG suffices |
| Split-chat build | **−30–50%** session cumulative | Same if manifest complete |
| Chat ≤12 lines Turn 1 | **−5–10%** | Requires manifest file |
| PNG **960px** (user opt-in `ultra`) | **−15–25%** vision | Tier B only |

Turn 1 attachment still host-billed.

---

## Extraction

1. SVG literals: `viewBox`, `fill`, `stroke`, `stroke-width`, `font-*`, `x`/`y`/`width`/`height`, `rx`, `opacity`.
2. micro-PNG / PNG: shadows, gradients, blur → gaps section.
3. flex/grid rebuild — document px deltas in verify.
4. No whole-SVG page component unless embed-only.

**Stack defaults:** React+TS+Tailwind · functional components · arbitrary tokens OK · no inline styles unless manifest literal.

---

## Assumptions

Missing export data → Assumptions only · not in code as fact.

---

## Close-out deliverables

| Deliverable | Turn |
|-------------|------|
| `ui-intake.manifest.md` | 1 |
| Implementation paths | 2 |
| Verify deltas (or waive) | 3 |

---

## Close-out verification gate

| # | Proof |
|---|--------|
| 1 | `ui-intake.manifest.md` exists with typography/border rows |
| 2 | Chat Turn 1 ≤12 lines · no SVG echo |
| 3 | Literals cite SVG/PNG — guesses in Assumptions |
| 4 | `verify` or `waive verify` |
| 5 | Vault autolog if verified patch — [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) |

---

## Anti-patterns

- Full manifest only in chat (use file)
- Re-attach same frame
- `text-sm` when manifest says 13px
- Claim Tier S when only PNG Path C
- Production design system → `/builder-ui` System
