---
name: sql
metadata:
  version: "1.0.0"
description: >-
  Single SQL skill: classify every request as READ, MIGRATE, or WRITE before
  executing. Read queries with EXPLAIN/LIMIT discipline; migrations via the
  project's migrate toolchain only; guarded writes with blocklist and prod
  confirmation. Trigger on /sql, "run this query", "migrate the database", or
  "check rows in". Use when handling SQL read, write, or migration requests that require safe classification and verification.
disable-model-invocation: true
---

# SQL

Role: Database operator

Mission: Classify the request, precheck, execute through the correct channel, report results. Never guess the environment or credentials.

## Purpose

One entry point for database work in any project:

| Mode | What it covers |
|------|----------------|
| **READ** | `SELECT`, `WITH … SELECT`, `EXPLAIN`, `SHOW`, `DESCRIBE` |
| **MIGRATE** | Apply or inspect **versioned migrations** via repo toolchain |
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

Do NOT activate for: application-only bugs with no DB angle, or when user only wants ORM/code review (use `/scrutinize`).

---

# Phase 1 — Context

Establish before classification:

1. **Engine** — Postgres, MySQL, SQL Server, SQLite, etc. (from repo config, MCP server, or user)
2. **Environment** — `local` | `dev` | `staging` | `prod` (ask if unclear; never assume prod is safe)
3. **Connection path** — MCP database tool, `psql` / `mysql` CLI, or project script (`npm run db:…`)
4. **User intent** — explore data, change data, or apply schema migrations

Never print full connection URLs. Use env var names only (`DATABASE_URL`, `POSTGRES_URL`).

---

# Phase 2 — Classify

Parse the user request and any pasted SQL. Choose **one** mode:

## READ

- Statements that only read metadata or data: `SELECT`, `EXPLAIN`, `SHOW`, `DESCRIBE`, `\\d` (psql meta-commands)
- "How many rows…", "what's in table X", "why is this slow" (start with `EXPLAIN`)

## MIGRATE

- User asks to run / status / rollback **migrations**
- User points at `migrations/`, `prisma/migrations`, Flyway/Liquibase paths
- Schema change request → default to MIGRATE (create file + toolchain), not raw DDL in prod

## WRITE

- `INSERT`, `UPDATE`, `DELETE`, `MERGE`
- DDL: `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, indexes, constraints
- Pasted SQL that mutates state when user explicitly wants it executed

## BLOCKED

- `DELETE` or `UPDATE` without `WHERE` (unless user explicitly confirms narrow table + reason)
- `DROP DATABASE`, `TRUNCATE` on prod without explicit confirmation
- Prod WRITE/MIGRATE without confirmation phrase (see Commit gate)
- Credentials missing or connection refused with no fallback

---

# SQL decision matrix

After classification, apply environment rules:

| Mode | local / dev | staging | prod |
|------|-------------|---------|------|
| **READ** | Run (with `LIMIT` default) | Run (with `LIMIT`) | Run (with `LIMIT`; avoid wide `SELECT *` on huge tables) |
| **MIGRATE** | Toolchain dev commands allowed if user asked | `deploy` / `upgrade` only | `deploy` / `upgrade` only + **confirm prod** |
| **WRITE** | Run after summarizing impact | Summarize + confirm | **confirm prod** required |
| **BLOCKED** | Stop | Stop | Stop |

---

# Phase 3 — Precheck

## READ precheck

- Add `LIMIT` (default **100**) if missing and table size unknown
- For heavy queries: run `EXPLAIN` (or `EXPLAIN ANALYZE` on dev only) before full execute
- Reject `SELECT *` on prod without `LIMIT` when table is known to be large

## MIGRATE precheck

1. Detect toolchain from repo (first match wins):

| Signals in repo | Dev (create) | Apply (deploy) | Status |
|-----------------|--------------|----------------|--------|
| `prisma/schema.prisma` | `npx prisma migrate dev` | `npx prisma migrate deploy` | `npx prisma migrate status` |
| `knexfile.*` | `npx knex migrate:make` | `npx knex migrate:latest` | `npx knex migrate:status` |
| `alembic.ini` | `alembic revision --autogenerate` | `alembic upgrade head` | `alembic current` |
| `flyway.conf` / `db/migration` | — | `flyway migrate` | `flyway info` |
| `bin/rails` + `db/migrate` | `bin/rails generate migration` | `bin/rails db:migrate` | — |
| `Makefile` target `db-migrate` | use documented target | use documented target | — |

2. Prefer `package.json` / `Makefile` scripts if defined (`npm run migrate`, etc.)
3. Do **not** paste contents of migration files into CLI unless user explicitly wants manual SQL on dev

## WRITE precheck

- Show: statement type, tables touched, estimated scope (`WHERE` clause present?)
- Blocklist unless user explicitly confirms with table name + reason:
  - `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`
  - `DELETE FROM t` / `UPDATE t SET` with no `WHERE`
- Prefer transaction: `BEGIN` → execute → show result → `COMMIT` only after user confirms on staging/prod

---

# Commit gate (prod & destructive)

### Explicit confirmation required

- Any **prod** WRITE or MIGRATE deploy
- Any blocklisted statement on any environment

Accept phrases (examples): **ยืนยัน prod**, **confirm prod**, **yes run on production**

### NOT sufficient

- `/sql` alone
- "ok" without environment context after a prod warning

---

# Phase 4 — Execute

Use the connection path from Phase 1. Prefer MCP or project-wrapped CLI over raw credentials in chat.

## READ

```bash
# Example — adapt to engine; use env vars
psql "$DATABASE_URL" -c "EXPLAIN …"
psql "$DATABASE_URL" -c "SELECT … LIMIT 100;"
```

## MIGRATE

Run the **deploy** command for the detected toolchain — not ad-hoc DDL on prod.

## WRITE

Run inside a transaction when the client supports it. Report rows affected.

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
- **Safer alternative:** (e.g. use READ, add WHERE, use `prisma migrate dev`)

---

# Common failures

| Error | Likely cause | Fix |
|-------|--------------|-----|
| connection refused | wrong env / VPN / service down | check `DATABASE_URL`, docker, MCP |
| permission denied | read-only role | use READ or escalate credentials |
| relation does not exist | wrong schema / migration not applied | MIGRATE status, check search_path |
| timeout | missing index / no LIMIT | EXPLAIN, add LIMIT, fix query |
| duplicate key | WRITE without checking | READ first, fix data or use UPSERT |

---

# Operating rules

- **One mode per turn** — if user mixes migrate + ad-hoc WRITE, split into ordered steps
- **No secrets in output** — mask connection strings and PII columns when possible
- **Distinguish claim vs result** — "user asked to delete rows" vs "DELETE returned 0 rows"
- **When unsure, READ first** — `SELECT COUNT(*)`, sample rows, then WRITE
- **Schema changes** → MIGRATE path on dev; never raw `ALTER` on prod without migration file + deploy

---

# Success criteria

- Correct mode chosen before execution
- Prod mutations only with explicit confirmation
- Migrations go through project toolchain
- User receives actionable summary with evidence from real command output
