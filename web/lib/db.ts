import { Pool } from "pg";

// Reads from vw_* views only, per CLAUDE.md — never base tables.
// DATABASE_URL is provided by start.sh / .env.local.
const globalForPg = globalThis as unknown as { pgPool?: Pool };

export const pool =
  globalForPg.pgPool ??
  new Pool({
    connectionString: process.env.DATABASE_URL,
  });

if (process.env.NODE_ENV !== "production") {
  globalForPg.pgPool = pool;
}
