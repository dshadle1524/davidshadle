import { Pool } from "pg";

// Separate pool for the admin CMS, pointed at the persistent bases-hosted
// Postgres (BASES_DATABASE_URL) — never the local dev database. Admin writes
// go to base tables directly; reads go through vw_* for calculated columns.
// Kept physically separate from web/lib/db.ts's pool so there is no code
// path that could accidentally query the wrong database.
const globalForPg = globalThis as unknown as { adminPgPool?: Pool };

export const adminPool =
  globalForPg.adminPgPool ??
  new Pool({
    connectionString: process.env.BASES_DATABASE_URL,
    ssl: false,
  });

if (process.env.NODE_ENV !== "production") {
  globalForPg.adminPgPool = adminPool;
}
