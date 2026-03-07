#!/usr/bin/env bash
set -euo pipefail

PGHOST="${LAB_PGHOST:-localhost}"
PGPORT="${LAB_PGPORT:-5432}"
PGUSER="${LAB_PGUSER:-postgres}"
PGPASSWORD="${LAB_PGPASSWORD:-postgres}"
PGDATABASE="${LAB_PGDATABASE:-repack_lab}"

INITIAL_ROWS="${INITIAL_ROWS:-1500000}"
PAYLOAD_BYTES="${PAYLOAD_BYTES:-800}"
UPDATE_ROUNDS="${UPDATE_ROUNDS:-4}"
UPDATE_MODULUS="${UPDATE_MODULUS:-2}"
DELETE_PERCENT="${DELETE_PERCENT:-95}"

export PGPASSWORD

psql \
  -h "$PGHOST" \
  -p "$PGPORT" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  -v ON_ERROR_STOP=1 \
  -v initial_rows="$INITIAL_ROWS" \
  -v payload_bytes="$PAYLOAD_BYTES" \
  -v update_rounds="$UPDATE_ROUNDS" \
  -v update_modulus="$UPDATE_MODULUS" \
  -v delete_percent="$DELETE_PERCENT" \
  -f sql/bloat_workload.sql
