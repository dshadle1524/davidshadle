#!/usr/bin/env bash
# ============================================================================
# apply-migration.sh - Apply one hand-written migration to local dev, then
# (only after explicit confirmation) to the persistent bases-hosted DB.
# ============================================================================
# Usage: postgres/apply-migration.sh postgres/migrations/NNNN-description.sql
#
# Unlike init-db.sh (drop + recreate, local-dev-only, refuses to run against
# bases.effortlessapi.com), this script is the ONLY sanctioned way to change
# the schema of a persistent database that can't be dropped. Every migration
# file must be idempotent (safe to re-run) — see postgres/migrations/README
# if one exists, or the header comment of 0001-initial-schema.sql.
#
# Env vars:
#   DATABASE_URL        local dev Postgres (defaults to the standard local
#                        connection string, same default as init-db.sh)
#   BASES_DATABASE_URL   the persistent bases.effortlessapi.com database.
#                        Required to apply to bases; if unset, this script
#                        only applies locally and exits.
# ============================================================================

set -euo pipefail

MIGRATION_FILE="${1:-}"
if [ -z "$MIGRATION_FILE" ]; then
    echo "usage: postgres/apply-migration.sh postgres/migrations/NNNN-description.sql" >&2
    exit 1
fi
if [ ! -f "$MIGRATION_FILE" ]; then
    echo "migration file not found: $MIGRATION_FILE" >&2
    exit 1
fi

DEFAULT_CONN="postgresql://postgres:postgres@localhost:5732/davidshadle"
LOCAL_DATABASE_URL="${DATABASE_URL:-$DEFAULT_CONN}"

echo "[apply-migration] file: $MIGRATION_FILE"
echo "[apply-migration] step 1/2: applying to local dev ($LOCAL_DATABASE_URL)"
psql "$LOCAL_DATABASE_URL" -v ON_ERROR_STOP=1 -f "$MIGRATION_FILE"
echo "[apply-migration] local dev applied cleanly."

if [ -z "${BASES_DATABASE_URL:-}" ]; then
    echo "[apply-migration] BASES_DATABASE_URL not set — skipping bases apply. Done."
    exit 0
fi

echo ""
echo "[apply-migration] step 2/2: bases is migration-only and can never be"
echo "dropped/recreated. Review the migration file above before continuing."
echo "Target: $BASES_DATABASE_URL"
echo ""
read -r -p "Type the exact phrase 'apply to bases' to continue, anything else to abort: " CONFIRM
if [ "$CONFIRM" != "apply to bases" ]; then
    echo "[apply-migration] aborted — bases was not touched."
    exit 2
fi

echo "[apply-migration] applying to bases..."
psql "$BASES_DATABASE_URL" -v ON_ERROR_STOP=1 -f "$MIGRATION_FILE"
echo "[apply-migration] bases applied cleanly. Done."
