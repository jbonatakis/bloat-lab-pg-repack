#!/usr/bin/env bash
set -euo pipefail

PGHOST="${LAB_PGHOST:-localhost}"
PGPORT="${LAB_PGPORT:-5432}"
PGUSER="${LAB_PGUSER:-postgres}"
PGPASSWORD="${LAB_PGPASSWORD:-postgres}"
PGDATABASE="${LAB_PGDATABASE:-repack_lab}"

export PGPASSWORD

psql \
  -h "$PGHOST" \
  -p "$PGPORT" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  -v ON_ERROR_STOP=1 \
  -f sql/size_report.sql
