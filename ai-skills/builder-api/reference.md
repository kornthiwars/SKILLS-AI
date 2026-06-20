# builder-api — reference

## Slice brief intake (phase 0)

Same triggers and required fields as [builder-ui/reference.md](../builder-ui/reference.md) § Slice brief intake.

Contract: [`templates/template.slice-brief.md`](../../templates/template.slice-brief.md).

**Owner focus:** implement **Contracts** and API boundaries from the brief only; do not expand UI/schema scope — hand off or escalate to `/builder-feature`.

---

## Workflow (detail)

Load this section when executing a phase. Run phases **in order**.

### 1) Domain analysis

Identify:
- actors and permissions
- resources and workflows
- ownership boundaries
- state transitions

Output:
- domain map
- ownership map

### 2) Resource modeling

Define:
- entities and identifiers
- relationships and lifecycle states
- naming standards

Output:
- resource model
- lifecycle rules

### 3) Contract design

Define per endpoint:
- request schema
- response schema
- status code behavior
- error contract

Output:
- endpoint contract set
- schema definitions

### 4) Validation architecture

Validate:
- path/query/body
- auth context
- business invariants

Rules:
- validate early
- reject invalid input immediately
- structured validation errors

Output:
- validation plan
- error payload standard

### 5) AuthN/AuthZ

Design:
- session/token flow
- role/scope checks
- ownership-based access

Output:
- auth flow
- authorization matrix

### 6) Error system

Require fields:
- code
- message
- details
- request_id
- retryability
- docs reference

Output:
- error taxonomy
- retry guidance

### 7) Scalability architecture

Assess:
- traffic profile
- concurrency and hotspots
- pagination and caching
- batching/async opportunities
- rate limiting

Output:
- scaling strategy
- bottleneck risks

### 8) Observability + reliability

Require:
- structured logs
- metrics and tracing
- health checks
- latency/failure tracking

Output:
- observability plan

### 9) Backend architecture

Layer boundaries:
- routes/controllers
- services
- repositories/domain
- validation/middleware

Rules:
- separate transport from business logic
- minimize cross-module coupling

Output:
- backend structure
- dependency boundaries

### 10) Verification

Verify:
- contract consistency
- validation coverage
- auth boundaries
- error consistency
- backward compatibility
- pagination/rate-limit behavior
- performance basics

Reject if:
- inconsistent contracts
- unclear auth boundaries
- unstable error payloads
- missing validation

---

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

---

## Close-out deliverables (SKILL REPORT `ARTIFACTS`)

Canonical list for close-out `ARTIFACTS` — map to workflow phase outputs:

| Deliverable | Phases |
|-------------|--------|
| API Analysis | 1 |
| Resource Architecture | 2 |
| API Contracts | 3 |
| Security Architecture | 5 |
| Backend Structure | 9 |
| Reliability Plan | 7–8 |
| Verification Plan | 10 |

---

## Close-out verification gate (phase 10)

| # | Proof |
|---|--------|
| 1 | Contract tests or OpenAPI diff reviewed |
| 2 | Auth matrix covers every mutating route |
| 3 | Error payload shape consistent |
| 4 | Pagination/rate limits specified |
| 5 | **Callee redirect cleanup** — grep old handlers/exports if routes or call targets changed ([`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc)) |
| 6 | `/scrutinize` + optional integration test RUN output cited |

Pass/reject only after IDENTIFY→RUN→READ on highest-risk endpoint.
