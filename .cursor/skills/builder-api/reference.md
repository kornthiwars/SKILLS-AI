# builder-api — reference checklist

## Extended anti-patterns

- giant controllers
- business logic in routes
- inconsistent schemas
- missing validation
- unstable contracts
- overfetching responses
- hidden side effects
- weak auth boundaries
- inconsistent error handling
- undocumented breaking changes

## Detailed prompts

### Contracts
- Is every endpoint typed and version-aware?
- Are nullable/optional fields explicit?
- Are error responses stable across endpoints?

### Security
- Least privilege enforced?
- Ownership checks centralized?
- Token/session lifetimes documented?

### Reliability
- Timeouts/retries policy defined?
- Idempotency for safe retries?
- Request IDs propagated end-to-end?
