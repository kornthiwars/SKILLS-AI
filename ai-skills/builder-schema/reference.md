# builder-schema — reference

## Slice brief intake (phase 0)

Same triggers and required fields as [builder-ui/reference.md](../builder-ui/reference.md) § Slice brief intake.

Contract: [`templates/template.slice-brief.md`](../../templates/template.slice-brief.md).

**Owner focus:** migrations and entity changes in brief **Contracts** / **Files likely touched**; production gates per schema rules; escalate cross-layer scope to `/builder-feature`.

---

## Workflow (detail)

Load this section when executing a phase. Run phases **in order**.

### 1) Domain analysis

Identify:
- actors, workflows, permissions
- entity ownership boundaries
- lifecycle and state transitions
- transactional boundaries

Output:
- domain map
- ownership boundaries

### 2) Entity modeling

Define:
- entities and attributes
- stable identifiers
- lifecycle states
- ownership rules

Output:
- entity definitions
- lifecycle rules

### 3) Relationship architecture

Model:
- one-to-one
- one-to-many
- many-to-many
- hierarchical/polymorphic where justified

Require:
- explicit FKs
- clear ownership
- predictable cascade behavior

Avoid:
- circular dependencies
- ambiguous ownership

Output:
- relationship map
- dependency structure

### 4) Normalization strategy

Evaluate:
- normalization level
- denormalization trade-offs
- read/write/update patterns

Require:
- controlled denormalization only
- duplicate source-of-truth avoidance

Output:
- normalization plan
- duplication risk assessment

### 5) Query pattern analysis

Analyze:
- read-heavy/write-heavy paths
- filters, sorts, aggregations
- pagination needs

Output:
- access pattern map
- scaling risks

### 6) Indexing strategy

Design:
- primary/unique/composite indexes
- partial/full-text where justified

Rule:
- index must map to real query patterns
- avoid over-indexing write-heavy paths

Output:
- indexing plan
- write/read trade-offs

### 7) Integrity enforcement

Require:
- FK constraints
- uniqueness constraints
- check constraints
- transactional guarantees

Output:
- integrity rules
- consistency boundaries

### 8) Scalability planning

Assess:
- data and query growth
- concurrency risks
- partitioning/replica/caching needs

Output:
- scalability plan
- operational concerns

### 9) Evolution strategy

Plan:
- backward compatibility
- safe migration sequencing
- rollback strategy
- deprecation lifecycle

Consider:
- nullable transitions
- dual-write windows

Output:
- migration strategy
- compatibility risks

### 10) Verification

Verify:
- relationship stability
- integrity constraints
- migration safety
- indexing validity
- query performance profile
- duplication/ownership clarity

Reject if:
- ownership unclear
- relationships unstable
- migrations unsafe
- indexing unjustified

---

## Extended anti-patterns

- tables before domain model
- missing FKs on relational data
- over-normalized hot read paths without plan
- under-indexed production queries
- breaking migrations without rollback
- shared mutable rows without ownership

## Detailed prompts

### Integrity
- Can every relationship enforce ownership in the DB?
- Are nullable columns intentional and documented?

### Performance
- Does each index map to a measured query?
- Is write amplification acceptable?

### Evolution
- Can you roll forward and back safely?
- Is dual-write window bounded and monitored?

---

## Close-out deliverables (SKILL REPORT `ARTIFACTS`)

Canonical list for close-out `ARTIFACTS` — map to workflow phase outputs:

| Deliverable | Phases |
|-------------|--------|
| Domain Analysis | 1 |
| Entity Architecture | 2 |
| Relationship Architecture | 3 |
| Query & Indexing Plan | 5 |
| Integrity & Evolution Plan | 6–7 |
| Verification Plan | 10 |

---

## Close-out verification gate (phase 10)

| # | Proof |
|---|--------|
| 1 | Migration up/down tested or dry-run cited |
| 2 | Hot queries have EXPLAIN or index justification |
| 3 | Integrity rules documented per relationship |
| 4 | Rollback/compatibility plan for prod |
| 5 | Migration path identified from project DB toolchain — not ad-hoc DDL |
| 6 | **Callee redirect cleanup** — drop deprecated columns/tables only after caller grep shows zero refs ([`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc)) |

For execution, use the project's migration toolchain and require explicit production confirmation for destructive operations. Pass/reject after cited tool output.
