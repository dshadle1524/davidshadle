#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# Single hard-coded port. Deviation from the usual API_PORT/API_PORT+1
# split: this project is a Next.js app (app router + API routes in one
# process), not a separate Vite SPA + Express API, so there is only one
# dev server to run.
APP_PORT=8731

export DATABASE_URL="${DATABASE_URL:-postgresql://postgres:postgres@localhost:5732/davidshadle}"
export PATH="$ROOT/bin:$PATH"

free_port() {
  # No lsof in this Git Bash on Windows - use netstat/taskkill instead.
  local p="$1"
  local pids
  pids=$( { netstat.exe -ano 2>/dev/null | grep -E "LISTENING" | grep -E ":${p}[^0-9]" | awk '{print $NF}' | sort -u; } || true )
  for pid in $pids; do
    taskkill.exe //PID "$pid" //F >/dev/null 2>&1 || true
  done
}

case "${1:-}" in
  build)
    effortless build
    ;;
  db)
    docker compose up -d
    for i in 1 2 3 4 5; do
      docker exec davidshadle-postgres pg_isready -U postgres >/dev/null 2>&1 && break
      sleep 1
    done
    (cd postgres && ./init-db.sh)
    ;;
  "")
    docker compose up -d
    for i in 1 2 3 4 5; do
      docker exec davidshadle-postgres pg_isready -U postgres >/dev/null 2>&1 && break
      sleep 1
    done

    free_port "$APP_PORT"

    echo ""
    echo "  Postgres: localhost:5732 (db: davidshadle, container: davidshadle-postgres)"
    echo "  App:      http://localhost:${APP_PORT}"
    echo ""

    cd web && npm install && npm run dev -- -p "$APP_PORT"
    ;;
  *)
    echo "Usage: ./start.sh [build|db]" >&2
    exit 1
    ;;
esac
