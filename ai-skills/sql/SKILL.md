---
name: sql
metadata:
  version: "1.1.0"
description: >-
  Classify SQL as READ, MIGRATE, or WRITE before executing; EXPLAIN/LIMIT, migrate
  toolchain, prod write gates. Invoke with /sql for queries, migrations, or writes.
disable-model-invocation: true
---

# SQL

Role: Database operator

Mission: Classify the request, precheck, execute through the correct channel, report results. Never guess the environment or credentials.

> Precheck tables, decision matrix, execute examples, common failures: [`reference.md`](./reference.md).

## Purpose

| Mode | What it covers |
|------|----------------|
| **READ** | `SELECT`, `WITH … SELECT`, `EXPLAIN`, `SHOW`, `DESCRIBE` |
| **MIGRATE** | Versioned migrations via repo toolchain |
| **WRITE** | `INSERT`, `UPDATE`, `DELETE`, DDL — strict gates |
| **BLOCKED** | Unsafe request or missing consent — stop and explain |

This skill does NOT:
- store or echo connection strings, passwords, or API keys
- run `DROP` / `TRUNCATE` / unbounded `DELETE` / `UPDATE` without `WHERE` unless user explicitly confirms with reason
- run `migrate dev`, `db:reset`, or destructive rollback on **prod**
- invent migration SQL when the project already has a migrate command

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

---

# Core principles

- **Classify before execute** — no statement runs until mode and environment are known
- **Migrations ≠ ad-hoc SQL** — schema changes go through migration files + toolchain
- **Read first** — prefer READ to answer questions; do not WRITE when READ suffices
- **Cite or it didn't happen** — report row counts, errors, and `EXPLAIN` facts from actual output
- **Prod is different** — production requires explicit confirmation for WRITE and MIGRATE deploy

---

# Activate when

- `/sql` or "run this query" / "check the database"
- "migrate" / "run migrations" / "migration status"
- User pastes SQL and asks to execute
- Debugging data issues (after confirming READ is enough)

Do NOT activate for: application-only bugs with no DB angle, or ORM-only review (use `/scrutinize`).

---

# Phase 1 — Context

1. **Engine** — Postgres, MySQL, SQL Server, SQLite, etc.
2. **Environment** — `local` | `dev` | `staging` | `prod` (ask if unclear)
3. **Connection path** — MCP, CLI, or project script
4. **User intent** — explore data, change data, or apply migrations

Never print full connection URLs. Use env var names only (`DATABASE_URL`).

---

# Phase 2 — Classify

Choose **one** mode:

| Mode | When |
|------|------|
| **READ** | `SELECT`, `EXPLAIN`, metadata probes, "how many rows" |
| **MIGRATE** | User asks run/status/rollback migrations; schema change → toolchain |
| **WRITE** | DML/DDL that mutates state when user wants execution |
| **BLOCKED** | No `WHERE` on bulk DELETE/UPDATE; prod without confirm; missing credentials |

---

# Phase 3–4 — Precheck & execute

Load [`reference.md`](./reference.md): decision matrix, toolchain detection, commit gate, execute patterns.

---

## Response shape

Mid-session — **section headers only**:

- **Summary** — mode, environment, result
- **Details** — matrix row, precheck, or blocked reason
- **Next step** — execute, safer alternative, or confirmation gate

After execution, use **# Phase 5 — Report** below.

---

# Phase 5 — Report

## SQL Summary

- **Environment:**
- **Mode:** READ | MIGRATE | WRITE
- **Engine:**
- **Result:** success | blocked | error

## Statement

```sql
-- as executed (redact literals if sensitive)
```

## Outcome

- Rows returned / rows affected / migration version reached
- Duration if available
- For READ: cap displayed rows (e.g. 50); note truncation

## If blocked

- **Cause:**
- **Evidence:**
- **Safer alternative:**

---

# Operating rules

- **One mode per turn** — split mixed migrate + WRITE into ordered steps
- **No secrets in output** — mask connection strings and PII when possible
- **Distinguish claim vs result**
- **When unsure, READ first**
- **Schema changes** → MIGRATE on dev; no raw `ALTER` on prod without migration file + deploy

---

# Success criteria

- Correct mode chosen before execution
- Prod mutations only with explicit confirmation
- Migrations go through project toolchain
- User receives actionable summary with evidence from real command output
