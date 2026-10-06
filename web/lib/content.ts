import { pool } from "./db";

// Every query reads from vw_* views, never base tables, per CLAUDE.md.

/**
 * Split a rich-text field into paragraphs. The rulebook stores "\n\n" between
 * paragraphs, but the admin CMS textarea round-trips through the browser and
 * saves Windows line endings ("\r\n\r\n"), so a bare split("\n\n") silently
 * collapses everything into one paragraph. Normalize first, then split on any
 * run of two-or-more newlines.
 */
export function splitParagraphs(text: string): string[] {
  return text
    .replace(/\r\n?/g, "\n")
    .split(/\n{2,}/)
    .map((p) => p.trim())
    .filter(Boolean);
}

export interface SiteSettings {
  site_setting_id: string;
  contact_email: string;
  contact_phone: string | null;
  site_domain: string;
  portfolio_company_count: string;
  self_description_line: string;
  positioning_statement: string;
  hero_headline: string;
  hero_subheadline: string;
  banyan_title: string;
}

export interface CurrentlyItem {
  currently_item_id: string;
  title: string;
  body_text: string;
  sort_order: number;
}

export interface BioVariant {
  bio_variant_id: string;
  label: string;
  usage_context: string;
  body_text: string;
  sort_order: number;
}

export interface HowIWorkSection {
  how_i_work_section_id: string;
  heading: string;
  body_text: string;
  short_body_text: string | null;
  sort_order: number;
}

export interface ProofPoint {
  proof_point_id: string;
  title: string;
  problem_text: string;
  action_text: string;
  outcome_text: string;
  attribution_note: string | null;
  client_or_category: string | null;
  status_label: string | null;
  featured_on_work_page: boolean;
  featured_in_resume_selected_work: boolean;
  sort_order: number;
  image_url: string | null;
}

export interface JobEntry {
  job_entry_id: string;
  company: string;
  job_title: string | null;
  start_date: Date;
  end_date: Date | null;
  is_current: boolean;
  display_group_key: string | null;
  summary_text_variant_a: string | null;
  compressed_line: string | null;
  include_in_variant_a: boolean;
  is_pre2019: boolean;
  sort_order: number;
}

export interface ResumeVariant {
  resume_variant_id: string;
  label: string;
  audience_description: string;
  summary_text: string;
  published_on_site: boolean;
}

export interface ResumeListItem {
  resume_list_item_id: string;
  category: string;
  label: string;
  sort_order: number;
}

export interface EducationEntry {
  education_entry_id: string;
  institution: string;
  degree: string;
  field_of_study: string | null;
  grad_year: number | null;
}

export async function getSiteSettings(): Promise<SiteSettings> {
  const { rows } = await pool.query("SELECT * FROM vw_site_settings LIMIT 1");
  return rows[0];
}

export async function getCurrentlyItems(): Promise<CurrentlyItem[]> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_currently_items ORDER BY sort_order",
  );
  return rows;
}

export async function getBioVariant(id: string): Promise<BioVariant> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_bio_variants WHERE bio_variant_id = $1",
    [id],
  );
  return rows[0];
}

export async function getHowIWorkSections(): Promise<HowIWorkSection[]> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_how_i_work_sections ORDER BY sort_order",
  );
  return rows;
}

export async function getFeaturedWorkProofPoints(): Promise<ProofPoint[]> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_proof_points WHERE featured_on_work_page = true ORDER BY sort_order",
  );
  return rows;
}

export async function getSelectedWorkProofPoints(): Promise<ProofPoint[]> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_proof_points WHERE featured_in_resume_selected_work = true ORDER BY sort_order",
  );
  return rows;
}

export async function getResumeVariant(id: string): Promise<ResumeVariant> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_resume_variants WHERE resume_variant_id = $1",
    [id],
  );
  return rows[0];
}

export async function getJobEntriesForVariantA(): Promise<JobEntry[]> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_job_entries WHERE include_in_variant_a = true ORDER BY sort_order",
  );
  return rows;
}

export async function getResumeListItems(): Promise<ResumeListItem[]> {
  const { rows } = await pool.query(
    "SELECT * FROM vw_resume_list_items ORDER BY category, sort_order",
  );
  return rows;
}

export async function getEducationEntries(): Promise<EducationEntry[]> {
  const { rows } = await pool.query("SELECT * FROM vw_education_entries");
  return rows;
}

export interface LandingPageFact {
  landing_page_item_fact_id: string;
  label: string;
  body_text: string;
  sort_order: number;
}

export interface LandingPageItem {
  landing_page_item_id: string;
  label: string | null;
  heading: string;
  body_text: string | null;
  sort_order: number;
  facts: LandingPageFact[];
}

export type LandingPageSectionKind = "prose" | "list" | "steps" | "cards" | "callout";

export interface LandingPageSection {
  landing_page_section_id: string;
  kind: LandingPageSectionKind;
  anchor_id: string | null;
  eyebrow: string | null;
  heading: string;
  body_text: string | null;
  sort_order: number;
  items: LandingPageItem[];
}

export interface LandingPage {
  landing_page_id: string;
  meta_title: string;
  meta_description: string;
  eyebrow: string;
  headline: string;
  lede: string;
  video_url: string | null;
  primary_cta_label: string;
  primary_cta_href: string;
  secondary_cta_label: string | null;
  secondary_cta_href: string | null;
  is_published: boolean;
  sections: LandingPageSection[];
}

/** A published landing page with sections, items and facts in order, or null. */
export async function getLandingPage(slug: string): Promise<LandingPage | null> {
  const { rows: pages } = await pool.query(
    "SELECT * FROM vw_landing_pages WHERE landing_page_id = $1 AND is_published = TRUE",
    [slug],
  );
  if (pages.length === 0) return null;

  const { rows: sections } = await pool.query(
    "SELECT * FROM vw_landing_page_sections WHERE landing_page = $1 ORDER BY sort_order",
    [slug],
  );
  const { rows: items } = await pool.query(
    "SELECT * FROM vw_landing_page_items WHERE landing_page_section = ANY($1) ORDER BY sort_order",
    [sections.map((s) => s.landing_page_section_id)],
  );
  const { rows: facts } = await pool.query(
    "SELECT * FROM vw_landing_page_item_facts WHERE landing_page_item = ANY($1) ORDER BY sort_order",
    [items.map((i) => i.landing_page_item_id)],
  );

  const factsByItem = new Map<string, LandingPageFact[]>();
  for (const f of facts) {
    const list = factsByItem.get(f.landing_page_item) ?? [];
    list.push(f);
    factsByItem.set(f.landing_page_item, list);
  }
  const itemsBySection = new Map<string, LandingPageItem[]>();
  for (const i of items) {
    const list = itemsBySection.get(i.landing_page_section) ?? [];
    list.push({ ...i, facts: factsByItem.get(i.landing_page_item_id) ?? [] });
    itemsBySection.set(i.landing_page_section, list);
  }

  return {
    ...pages[0],
    sections: sections.map((s) => ({
      ...s,
      items: itemsBySection.get(s.landing_page_section_id) ?? [],
    })),
  };
}
