\set ON_ERROR_STOP on
\timing on

-- Expect these psql vars to be provided by script/CLI:
-- initial_rows, payload_bytes, update_rounds, update_modulus, delete_percent

SET client_min_messages TO warning;

CREATE SCHEMA IF NOT EXISTS lab;
DROP TABLE IF EXISTS lab.bloat_test;

CREATE TABLE lab.bloat_test (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  payload text NOT NULL,
  marker integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
) WITH (
  autovacuum_enabled = false,
  toast.autovacuum_enabled = false,
  fillfactor = 100
);

INSERT INTO lab.bloat_test (payload)
SELECT repeat(md5(g::text), ((:payload_bytes + 31) / 32))
FROM generate_series(1, :initial_rows) AS g;

ANALYZE lab.bloat_test;

SELECT format(
  'UPDATE lab.bloat_test
   SET payload = repeat(md5(random()::text), %s),
       marker = marker + 1
   WHERE id %% %s = 0;',
  ((:payload_bytes + 31) / 32),
  :update_modulus
)
FROM generate_series(1, :update_rounds)
\gexec

DELETE FROM lab.bloat_test
WHERE id % 100 < :delete_percent;

UPDATE lab.bloat_test
SET payload = repeat(md5(random()::text), ((:payload_bytes + 31) / 32)),
    marker = marker + 1
WHERE id % 10 = 0;

ANALYZE lab.bloat_test;

\echo === Bloat summary (post workload) ===
\i sql/size_report.sql
