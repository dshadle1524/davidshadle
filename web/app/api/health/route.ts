import { NextResponse } from "next/server";
import { pool } from "@/lib/db";

// Setup-phase smoke test: confirms the app can reach Postgres and read
// the generated vw_* views. Not a final API surface.
const VIEWS = [
  "vw_site_settings",
  "vw_currently_items",
  "vw_bio_variants",
  "vw_how_i_work_sections",
  "vw_proof_points",
  "vw_job_entries",
  "vw_resume_variants",
  "vw_resume_list_items",
  "vw_education_entries",
];

export async function GET() {
  try {
    const counts: Record<string, number> = {};
    for (const view of VIEWS) {
      const result = await pool.query(`SELECT COUNT(*)::int AS count FROM ${view}`);
      counts[view] = result.rows[0].count;
    }
    return NextResponse.json({ ok: true, counts });
  } catch (error) {
    return NextResponse.json(
      { ok: false, error: error instanceof Error ? error.message : String(error) },
      { status: 500 },
    );
  }
}
