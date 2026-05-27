# builder-ui — reference checklist

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
