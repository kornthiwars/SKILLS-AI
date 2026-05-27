# builder-feature — reference checklist

## Delegation quality checklist

- Are responsibilities mapped to the right specialist?
- Any specialist overlap or duplicated ownership?
- Is sequencing explicit and dependency-aware?

## Reuse checklist

- Existing module/service reused where possible?
- Extension path evaluated before new build?
- Shared contracts preserved?

## Integration risk checklist

- Async flows and retries explicit?
- Cache invalidation behavior defined?
- Rollback behavior safe across layers?
- Permission boundaries consistent end-to-end?

## Anti-patterns

- builder-feature doing specialist implementation itself
- giant cross-layer feature module
- hidden dependencies between layers
- fragmented state ownership
- rollout without monitoring/rollback
