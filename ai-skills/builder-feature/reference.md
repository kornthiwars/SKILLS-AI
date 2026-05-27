# builder-feature — reference

## Workflow (detail)

Load this section when executing a phase. Run phases **in order**.

### 1) Workflow analysis

Analyze user actions, success path, async flows/retries, permissions, rollback/failure scenarios, cross-system dependencies.

Output: workflow map, failure scenarios, dependency analysis.

### 2) Existing system analysis

Inspect current features, shared APIs/schemas, infra capabilities, reusable patterns. Reuse vs create? Ownership conflicts?

Output: reuse opportunities, duplication risks, extension constraints.

### 3) Feature boundary design

Define feature boundary, shared vs local modules, ownership zones, integration surfaces.

Output: boundary map, ownership map.

### 4) Specialist delegation

Delegate to `/builder-ui`, `/builder-api`, `/builder-schema`, `/builder-infrastructure` as needed.

Output: delegated task map, ownership matrix, sequencing plan.

### 5) State + integration coordination

Coordinate frontend vs server state, async updates, cache invalidation, optimistic updates and failure reconciliation.

Output: integration map, state ownership plan.

### 6) Rollout + reliability coordination

Plan feature flags, staged rollout, rollback, monitoring, migration/deployment safety, incident hooks.

Output: rollout plan, operational readiness assessment.

### 7) Cross-layer verification

Verify workflow continuity, reuse, ownership, integration, permissions, async reliability, observability, rollback. Use `/scrutinize` before merge.

Reject if: unclear ownership, duplicated systems, excessive coupling, rollback impossible, incomplete observability.

---

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
