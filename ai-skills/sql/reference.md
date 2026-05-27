# sql — reference

Load for **Phase 3–4** detail, matrices, and failure patterns. Run **Phase 1–2** from [`SKILL.md`](./SKILL.md) first.

---

## SQL decision matrix

| Mode | local / dev | staging | prod |
|------|-------------|---------|------|
| **READ** | Run (with `LIMIT` default) | Run (with `LIMIT`) | Run (with `LIMIT`; avoid wide `SELECT *` on huge tables) |
| **MIGRATE** | Toolchain dev commands allowed if user asked | `deploy` / `upgrade` only | `deploy` / `upgrade` only + **confirm prod** |
| **WRITE** | Run after summarizing impact | Summarize + confirm | **confirm prod** required |
| **BLOCKED** | Stop | Stop | Stop |

---

## Phase 3 — Precheck

### READ precheck

- Add `LIMIT` (default **100**) if missing and table size unknown
- For heavy queries: run `EXPLAIN` (or `EXPLAIN ANALYZE` on dev only) before full execute
- Reject `SELECT *` on prod without `LIMIT` when table is known to be large

### MIGRATE precheck — toolchain

| Signals in repo | Dev (create) | Apply (deploy) | Status |
|-----------------|--------------|----------------|--------|
| `prisma/schema.prisma` | `npx prisma migrate dev` | `npx prisma migrate deploy` | `npx prisma migrate status` |
| `knexfile.*` | `npx knex migrate:make` | `npx knex migrate:latest` | `npx knex migrate:status` |
| `alembic.ini` | `alembic revision --autogenerate` | `alembic upgrade head` | `alembic current` |
| `flyway.conf` / `db/migration` | — | `flyway migrate` | `flyway info` |
| `bin/rails` + `db/migrate` | `bin/rails generate migration` | `bin/rails db:migrate` | — |
| `Makefile` target `db-migrate` | use documented target | use documented target | — |

1. Prefer `package.json` / `Makefile` scripts if defined (`npm run migrate`, etc.)
2. Do **not** paste migration file contents into CLI unless user wants manual SQL on dev

### WRITE precheck

- Show: statement type, tables touched, estimated scope (`WHERE` present?)
- Blocklist unless user explicitly confirms with table name + reason:
  - `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`
  - `DELETE FROM t` / `UPDATE t SET` with no `WHERE`
- Prefer transaction: `BEGIN` → execute → show result → `COMMIT` only after user confirms on staging/prod

---

## Commit gate (prod & destructive)

### Explicit confirmation required

- Any **prod** WRITE or MIGRATE deploy
- Any blocklisted statement on any environment

Accept: **ยืนยัน prod**, **confirm prod**, **yes run on production**

### NOT sufficient

- `/sql` alone
- "ok" without environment context after a prod warning

---

## Phase 4 — Execute

Use connection path from Phase 1. Prefer MCP or project-wrapped CLI.

### READ

```bash
psql "$DATABASE_URL" -c "EXPLAIN …"
psql "$DATABASE_URL" -c "SELECT … LIMIT 100;"
```

### MIGRATE

Run **deploy** for detected toolchain — not ad-hoc DDL on prod.

### WRITE

Run in a transaction when supported. Report rows affected.

---

## Common failures

| Error | Likely cause | Fix |
|-------|--------------|-----|
| connection refused | wrong env / VPN / service down | check `DATABASE_URL`, docker, MCP |
| permission denied | read-only role | use READ or escalate credentials |
| relation does not exist | wrong schema / migration not applied | MIGRATE status, check search_path |
| timeout | missing index / no LIMIT | EXPLAIN, add LIMIT, fix query |
| duplicate key | WRITE without checking | READ first, fix data or use UPSERT |
