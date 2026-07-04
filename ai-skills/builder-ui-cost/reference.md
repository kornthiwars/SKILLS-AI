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
2. **Emit** `## Intake manifest` **in the chat reply** (canonical — full tables allowed). **Do not** `Write` any `.md` file to the repo.
3. After the manifest block: one-line summary — path, tier, frame size, top gaps, assumptions ≤3.

**Manifest block must include** § Typography & borders rows for every text style and bordered control in frame.

**Forbidden Turn 1:** component code · browser MCP · echoing SVG XML in chat · creating `ui-intake.manifest.md` or other intake markdown on disk.

### Turn 2 — Build

User: `build` (no re-attach). Read manifest from **this thread's Turn 1 chat** only.

**Agent:** code files · Tailwind **arbitrary** when default scale wrong (`text-[13px]`, `border-[1.5px]`) · REPORT ≤15 lines.

### Turn 3 — Verify

User: `verify` · one `browser_snapshot` · list deltas (size/weight/border/color) · fix if in budget.

`waive verify` → RISKS · CONFIDENCE cap 85.

### Same-thread build (default — lowest friction)

| Chat | Action |
|------|--------|
| Single thread | Attach → `## Intake manifest` in chat → user `build` → user `verify` |

**Optional split-chat:** new thread with **paste of the `## Intake manifest` block** (user copy) or re-attach — never require a repo file.

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

## Cost levers

| Lever | Δ tokens | Fidelity |
|-------|----------|----------|
| Manifest **in chat** (no repo file) | Avoids repo noise · history carries manifest | Same if tables complete |
| Prefer **Path B** over A when no effects | **−10–30%** vs dual attach | Tier S when SVG suffices |
| Same-thread `build` after intake | No re-attach · no file I/O | Same if manifest complete |
| Compact manifest tables (no prose) | **−5–10%** vs essay | Requires complete rows |
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
| `## Intake manifest` block in chat | 1 |
| Implementation paths | 2 |
| Verify deltas (or waive) | 3 |

---

## Close-out verification gate

| # | Proof |
|---|--------|
| 1 | Turn 1 chat contains `## Intake manifest` with typography/border rows — **no** intake `.md` written to repo |
| 2 | No SVG echo in chat |
| 3 | Literals cite SVG/PNG — guesses in Assumptions |
| 4 | `verify` or `waive verify` |
| 5 | Vault autolog if verified patch — [`vault-autolog.mdc`](../../ai-rules/workflow/vault-autolog.mdc) |

---

## Anti-patterns

- Writing `ui-intake.manifest.md` (or any intake markdown) into app/pack repo
- Re-attach same frame without design change
- `text-sm` when manifest says 13px
- Claim Tier S when only PNG Path C
- Production design system → `/builder-ui` System
