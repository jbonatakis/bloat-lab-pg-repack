# pg_repack Bloat Lab (Postgres 16)

This repo stands up PostgreSQL 16 with Docker Compose and generates heap bloat by:

1. Disabling autovacuum at server start (`postgres -c autovacuum=off`).
2. Creating a table with table-level autovacuum disabled.
3. Running a heavy insert/update/delete workload.

After the workload, live data should be much smaller than table disk usage.

The Docker image is pinned to `pg_repack` `v1.5.0` exactly.

Note: Postgres does not allow `autovacuum` as a per-database runtime setting, so this lab disables it at server level.

## Requirements

- Docker + Docker Compose
- `psql` client (or run the SQL from inside the container)

## Quick start

```bash
./scripts/start_db.sh
./scripts/run_bloat.sh
./scripts/report_bloat.sh
```

## Run pg_repack via wrapper

Use the wrapper as if `pg_repack` were locally installed; all args are forwarded as-is:

```bash
./scripts/pg_repack.sh --version
./scripts/pg_repack.sh --dbname=repack_lab --table=lab.bloat_test
```

Default connection details (configured inside scripts via `LAB_PG*` vars):

- host: `localhost`
- port: `5432`
- user: `postgres`
- password: `postgres`
- database: `repack_lab`

## Tunable workload knobs

You can scale up/down using env vars:

```bash
INITIAL_ROWS=3000000 \
PAYLOAD_BYTES=1000 \
UPDATE_ROUNDS=6 \
UPDATE_MODULUS=2 \
DELETE_PERCENT=97 \
./scripts/run_bloat.sh
```

To override DB connection without conflicting with your global `PG*` env:

```bash
LAB_PGHOST=localhost \
LAB_PGPORT=5432 \
LAB_PGUSER=postgres \
LAB_PGPASSWORD=postgres \
LAB_PGDATABASE=repack_lab \
./scripts/report_bloat.sh
```

Meaning:

- `INITIAL_ROWS`: rows inserted initially
- `PAYLOAD_BYTES`: approximate payload width per row
- `UPDATE_ROUNDS`: how many full update passes to run
- `UPDATE_MODULUS`: updates rows where `id % UPDATE_MODULUS = 0`
- `DELETE_PERCENT`: percent of rows deleted after updates

## Reset the lab

If you want a clean re-init (drops Docker volume/data):

```bash
./scripts/reset_db.sh
```

## Files

- `docker-compose.yml`: Postgres 16 service + persisted volume
- `sql/init/001_init.sql`: DB init (`pgstattuple` extension)
- `sql/bloat_workload.sql`: insert/update/delete workload
- `sql/size_report.sql`: reports live/dead tuple and table size stats
