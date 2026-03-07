\set ON_ERROR_STOP on

ANALYZE lab.bloat_test;

SELECT
  now() AS collected_at,
  current_database() AS db_name;

SHOW autovacuum;

SELECT
  relname,
  n_live_tup,
  n_dead_tup,
  vacuum_count,
  autovacuum_count
FROM pg_stat_user_tables
WHERE schemaname = 'lab'
  AND relname = 'bloat_test';

SELECT
  pg_size_pretty(pg_relation_size('lab.bloat_test')) AS heap_size,
  pg_size_pretty(pg_indexes_size('lab.bloat_test')) AS indexes_size,
  pg_size_pretty(pg_total_relation_size('lab.bloat_test')) AS total_size;

SELECT
  pg_size_pretty(table_len) AS table_len,
  pg_size_pretty(tuple_len) AS live_tuple_len,
  pg_size_pretty(dead_tuple_len) AS dead_tuple_len,
  ROUND((dead_tuple_len::numeric / NULLIF(table_len, 0)) * 100, 2) AS dead_tuple_pct,
  pg_size_pretty(free_space) AS free_space,
  ROUND((free_space::numeric / NULLIF(table_len, 0)) * 100, 2) AS free_space_pct
FROM pgstattuple('lab.bloat_test');

SELECT count(*) AS live_rows
FROM lab.bloat_test;
