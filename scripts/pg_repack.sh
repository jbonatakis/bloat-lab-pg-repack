#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! docker compose ps --services --status running | rg -qx "postgres"; then
  echo "postgres service is not running. Start it with ./scripts/start_db.sh" >&2
  exit 1
fi

exec docker compose run --rm --no-deps -T pg_repack "$@"
