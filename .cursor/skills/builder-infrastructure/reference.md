# builder-infrastructure — reference checklist

This file keeps extended depth so `SKILL.md` can stay focused and token-efficient.

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

