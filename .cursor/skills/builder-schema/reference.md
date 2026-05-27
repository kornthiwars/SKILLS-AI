# builder-schema — reference checklist

## Extended anti-patterns

- giant entities
- duplicated sources of truth
- hidden relationships
- implicit ownership
- missing constraints
- uncontrolled denormalization
- premature optimization
- over-indexing
- schema-encoded business logic
- unstable migrations
- circular dependencies

## Detailed prompts

### Ownership
- Who owns each entity lifecycle?
- Any shared mutable ownership?

### Integrity
- Can invalid state be inserted through any path?
- Are check constraints explicit and testable?

### Evolution
- Are destructive changes sequenced safely?
- Is rollback realistic, not theoretical?
