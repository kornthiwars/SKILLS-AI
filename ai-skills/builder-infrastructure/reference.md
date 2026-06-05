# builder-infrastructure — reference

## Workflow (detail)

Load this section when executing a phase. Run phases **in order**.

### 1) Workload & SLO analysis

Capture traffic/concurrency/latency profile, uptime targets, RTO/RPO, growth and failure tolerance.

Output: workload profile + reliability requirements.

### 2) Boundaries & environments

Define service/trust boundaries, ownership zones, local/dev/staging/prod/DR strategy, config isolation.

Output: boundary map + environment strategy.

### 3) Deployment architecture

Design CI/CD flow, release strategy (rolling/blue-green/canary), rollback, post-deploy verification.

Output: deploy and rollback plan.

### 4) Compute + networking

Choose compute model (containers/k8s/serverless/VMs/managed). Define ingress/egress, routing, DNS/LB, least-exposure boundaries.

Output: compute placement + network topology.

### 5) Security + secrets

Define IAM boundaries, secret storage/rotation, encryption, auditability.

Output: security model + secrets strategy.

### 6) Observability

Require metrics, logs, traces, dashboards, alerts, health checks. Track latency, throughput, failures, saturation.

Output: observability and alerting plan.

### 7) Reliability + recovery

Plan dependency/deployment/scale/regional failures, backup/restore, failover, graceful degradation.

Output: resilience and recovery plan.

### 8) Scale + cost

Analyze autoscaling, storage/traffic growth, bottlenecks, waste.

Output: scalability + cost optimization plan.

### 9) IaC + verification

IaC: version-controlled, declarative, reusable modules. Verify deployment, rollback drill, backup-restore, failover, security, observability, scalability.

Reject if: rollback impossible, ownership unclear, observability incomplete, weak security, unreliable automation.

---

## Detailed anti-patterns

- manual-only deployments
- snowflake servers
- hidden infra dependencies
- missing rollback strategies
- unmonitored systems
- insecure secrets handling
- oversized Kubernetes for simple systems
- infrastructure sprawl
- environment inconsistency
- undocumented networking rules
- weak disaster recovery planning
- overprovisioning without justification
- premature distributed-systems complexity

## Detailed phase prompts

### Workload analysis
- Peak/avg RPS?
- p95/p99 latency targets?
- request burst shape?
- regional constraints?
- data growth curves?
- compliance constraints?

### Boundaries
- Who owns each service?
- Which trust boundaries exist?
- Where are cross-account / cross-VPC links?
- Which dependencies are critical vs optional?

### Environments
- Drift detection strategy?
- Promotion path dev -> staging -> prod?
- Secret/config segregation by environment?

### Deployment
- What breaks rollback?
- What verifies canary health?
- What deployment metadata is emitted?

### Compute
- Is orchestration complexity justified?
- Capacity envelope and scaling limits?
- Workload affinity/anti-affinity needs?

### Networking
- Ingress rules minimal?
- Internal service exposure controlled?
- mTLS / TLS policy?
- egress allowlist policy?

### Security
- IAM least privilege tested?
- secret rotation periodicity?
- key/cert lifecycle defined?
- audit event retention?

### Observability
- SLI/SLO mapped to alerts?
- high-cardinality metric control?
- trace sampling strategy?
- runbook links in alerts?

### Reliability & DR
- RTO/RPO documented per service?
- backup restore tested schedule?
- failover rehearsal cadence?
- graceful degradation behavior defined?

### Cost
- Unit economics per workload?
- cost anomaly alerts?
- idle-resource cleanup policy?
- storage tiering/retention policy?

## Verification drill matrix (example)

| Check | Cadence | Pass signal |
|---|---|---|
| rollback test | every release train | service healthy + no data loss |
| backup restore | weekly/monthly | restore within RTO |
| failover drill | quarterly | traffic recovers within target |
| alert quality review | bi-weekly | low noise + actionable routing |
| autoscaling test | release or monthly | stable p95 under load profile |

---

## CI failure triage (PR checks)

When a PR check fails ([openai/gh-fix-ci](https://officialskills.sh/openai/skills/gh-fix-ci) pattern — link only):

| Step | Action |
|------|--------|
| 1 IDENTIFY | Which job/step failed; link to run URL |
| 2 RUN | `gh run view <id> --log-failed` or CI log in session |
| 3 READ | First actionable error — not cascading noise |
| 4 LOCALIZE | Infra config vs app vs flaky external |
| 5 FIX | Minimal patch; re-run same check |

Pack CI reference: `.github/workflows/skills-quality.yml` — smoke + budget checks. Hand off app-runtime failures to [`/debug`](../debug/SKILL.md).

---

## Close-out verification gate (phase 9)

| # | Proof |
|---|--------|
| 1 | Rollback procedure documented + tested or drill scheduled |
| 2 | Observability: metrics/alerts map to SLOs |
| 3 | Secrets strategy — not in repo |
| 4 | Cost/scale limits stated |
| 5 | **Callee redirect cleanup** — remove superseded resources/modules when grep shows zero refs ([`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc)) |
| 6 | `/scrutinize` before merge · `/git-push` for ship |

Cite `terraform plan`, health check, or drill output — IDENTIFY→RUN→READ.
