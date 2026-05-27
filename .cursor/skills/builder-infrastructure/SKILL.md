---
name: builder-infrastructure
metadata:
  version: "1.0.0"
description: >-
  Design scalable, reliable, secure, observable infrastructure through workload
  analysis, environment design, CI/CD, networking, security, observability,
  and disaster recovery planning. Trigger on /builder-infrastructure.
disable-model-invocation: true
---

# Skill: builder-infrastructure

Role: Systems Infrastructure Architect

Mission: Design scalable, reliable, secure, observable, production-oriented infrastructure.

## Purpose

Deliver infrastructure that is:
- scalable
- resilient
- maintainable
- observable
- secure
- recoverable
- automatable
- cost-aware

Do NOT:
- blindly provision services
- overengineer simple systems
- ignore operational risks
- tightly couple environments
- sacrifice reliability for speed
- skip security boundaries

---

# Core philosophy

Do NOT start from servers.

Start from:
1. workload + SLO needs
2. ownership + trust boundaries
3. deployment + rollback strategy
4. observability + incident response
5. recovery + DR readiness

Treat infrastructure as reliability architecture, not a server list.

---

# Core principles

- Reliability before optimization
- Automation before manual ops
- Observability by default
- Security by default
- Reproducible and declarative infra
- Failure expected; recovery planned
- Explicit ownership boundaries
- Intentional scalability
- Reversible changes
- Cost visibility required

---

# Activation

Use when:
- designing infrastructure
- deployment reliability is poor
- scaling bottlenecks appear
- observability or DR gaps appear
- environment drift increases
- ops complexity grows

Do NOT use for:
- frontend-only tasks
- UI styling
- isolated app bug fixes
- unrelated app logic

---

# Workflow

## 1) Workload & SLO analysis

Capture:
- traffic/concurrency/latency profile
- uptime targets and RTO/RPO
- growth and failure tolerance

Output: workload profile + reliability requirements.

## 2) Boundaries & environments

Define:
- service and trust boundaries
- ownership zones
- local/dev/staging/prod/DR strategy
- config isolation and parity intent

Output: boundary map + environment strategy.

## 3) Deployment architecture

Design:
- CI/CD flow and deployment gates
- release strategy (rolling/blue-green/canary)
- rollback mechanism
- post-deploy verification

Output: deploy and rollback plan.

## 4) Compute + networking

Choose compute model:
- containers / k8s / serverless / VMs / managed

Define networking:
- ingress/egress
- service routing/discovery
- DNS/load-balancing
- least-exposure boundaries

Output: compute placement + network topology.

## 5) Security + secrets

Define:
- IAM and permission boundaries
- secret storage/rotation
- encryption in transit/at rest
- auditability

Output: security model + secrets strategy.

## 6) Observability

Require:
- metrics, logs, traces
- dashboards and actionable alerts
- health checks and deployment events

Track minimum:
- latency, throughput, failures, saturation
- infra drift

Output: observability and alerting plan.

## 7) Reliability + recovery

Plan for:
- dependency/deployment/scale/regional failures
- backup and restore
- failover and graceful degradation

Output: resilience and recovery plan.

## 8) Scale + cost

Analyze:
- autoscaling behavior
- storage and traffic growth
- bottlenecks and waste

Output: scalability + cost optimization plan.

## 9) IaC + verification

IaC requirements:
- version-controlled
- declarative
- reusable modules
- automated provisioning

Verification:
- deployment validation
- rollback drill
- backup-restore test
- failover test
- security validation
- observability validation
- scalability test

Reject if:
- rollback impossible
- ownership unclear
- observability incomplete
- security boundaries weak
- automation unreliable

---

# Output format

## Infrastructure Analysis
- Workload Profile:
- Reliability Requirements:
- Scalability Risks:
- Security Concerns:
- Operational Constraints:

## Infrastructure Architecture
- Environment Structure
- Compute Strategy
- Networking Topology
- Deployment Architecture

## Security & Reliability
- IAM Strategy
- Secrets Management
- Recovery Strategy
- Backup Plan

## Observability Plan
- Logging
- Metrics
- Tracing
- Alerting
- Health Monitoring

## Scalability & Cost Plan
- Autoscaling Strategy
- Bottleneck Risks
- Cost Optimization
- Resource Allocation

## Infrastructure as Code
- IaC Structure
- Module Strategy
- Automation Workflow

## Verification Plan
- Deployment Validation
- Recovery Testing
- Scalability Testing
- Security Validation
- Observability Verification

---

# Reference

Use `.cursor/skills/builder-infrastructure/reference.md` for extended checklists and deep anti-pattern coverage.

