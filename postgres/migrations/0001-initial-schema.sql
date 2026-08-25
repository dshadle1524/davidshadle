-- ============================================================================
-- Migration 0001: Initial schema (bases-hosted, persistent CMS database)
-- ============================================================================
-- Applied via postgres/apply-migration.sh, never postgres/init-db.sh.
-- This is a snapshot of the rulebook-generated schema as of the introduction
-- of the admin CMS (includes ProofPoints.ImageUrl from the start — there was
-- no earlier deployed bases schema that predates it).
--
-- Idempotent by construction: every statement is safe to re-run.
-- Unlike init-db.sh's 01-drop-and-create-tables.sql, nothing here ever DROPs
-- a table. Views use DROP VIEW IF EXISTS ... CASCADE only because this is the
-- very first migration against a fresh, empty base — nothing can depend on a
-- view that has never existed. Later migrations that touch an existing view
-- must not casually reuse this DROP CASCADE pattern without checking for
-- real dependents first.
-- ============================================================================

SET timezone = 'UTC';

-- ============================================================================
-- TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS site_settings (
  site_setting_id                     TEXT                 PRIMARY KEY
);
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS contact_email TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS contact_phone TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS site_domain TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS portfolio_company_count TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS self_description_line TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS positioning_statement TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_headline TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_subheadline TEXT;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS banyan_title TEXT;

CREATE TABLE IF NOT EXISTS currently_items (
  currently_item_id                   TEXT                 PRIMARY KEY
);
ALTER TABLE currently_items ADD COLUMN IF NOT EXISTS title TEXT;
ALTER TABLE currently_items ADD COLUMN IF NOT EXISTS body_text TEXT;
ALTER TABLE currently_items ADD COLUMN IF NOT EXISTS sort_order INTEGER;

CREATE TABLE IF NOT EXISTS bio_variants (
  bio_variant_id                      TEXT                 PRIMARY KEY
);
ALTER TABLE bio_variants ADD COLUMN IF NOT EXISTS label TEXT;
ALTER TABLE bio_variants ADD COLUMN IF NOT EXISTS usage_context TEXT;
ALTER TABLE bio_variants ADD COLUMN IF NOT EXISTS body_text TEXT;
ALTER TABLE bio_variants ADD COLUMN IF NOT EXISTS sort_order INTEGER;

CREATE TABLE IF NOT EXISTS how_i_work_sections (
  how_i_work_section_id               TEXT                 PRIMARY KEY
);
ALTER TABLE how_i_work_sections ADD COLUMN IF NOT EXISTS heading TEXT;
ALTER TABLE how_i_work_sections ADD COLUMN IF NOT EXISTS body_text TEXT;
ALTER TABLE how_i_work_sections ADD COLUMN IF NOT EXISTS short_body_text TEXT;
ALTER TABLE how_i_work_sections ADD COLUMN IF NOT EXISTS sort_order INTEGER;

CREATE TABLE IF NOT EXISTS proof_points (
  proof_point_id                      TEXT                 PRIMARY KEY
);
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS title TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS problem_text TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS action_text TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS outcome_text TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS attribution_note TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS register_note TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS client_or_category TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS status_label TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS featured_on_work_page BOOLEAN;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS featured_in_resume_selected_work BOOLEAN;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS image_url TEXT;
ALTER TABLE proof_points ADD COLUMN IF NOT EXISTS sort_order INTEGER;

CREATE TABLE IF NOT EXISTS job_entries (
  job_entries_id                      TEXT                 PRIMARY KEY
);
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS job_entry_id TEXT;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS company TEXT;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS job_title TEXT;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS start_date DATE;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS end_date DATE;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS is_current BOOLEAN;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS display_group_key TEXT;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS summary_text_variant_a TEXT;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS summary_text_variant_b TEXT;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS compressed_line TEXT;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS include_in_variant_a BOOLEAN;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS include_in_variant_b BOOLEAN;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS is_pre2019 BOOLEAN;
ALTER TABLE job_entries ADD COLUMN IF NOT EXISTS sort_order INTEGER;

CREATE TABLE IF NOT EXISTS resume_variants (
  resume_variant_id                   TEXT                 PRIMARY KEY
);
ALTER TABLE resume_variants ADD COLUMN IF NOT EXISTS label TEXT;
ALTER TABLE resume_variants ADD COLUMN IF NOT EXISTS audience_description TEXT;
ALTER TABLE resume_variants ADD COLUMN IF NOT EXISTS summary_text TEXT;
ALTER TABLE resume_variants ADD COLUMN IF NOT EXISTS published_on_site BOOLEAN;

CREATE TABLE IF NOT EXISTS resume_list_items (
  resume_list_item_id                 TEXT                 PRIMARY KEY
);
ALTER TABLE resume_list_items ADD COLUMN IF NOT EXISTS category TEXT;
ALTER TABLE resume_list_items ADD COLUMN IF NOT EXISTS label TEXT;
ALTER TABLE resume_list_items ADD COLUMN IF NOT EXISTS sort_order INTEGER;

CREATE TABLE IF NOT EXISTS education_entries (
  education_entries_id                TEXT                 PRIMARY KEY
);
ALTER TABLE education_entries ADD COLUMN IF NOT EXISTS education_entry_id TEXT;
ALTER TABLE education_entries ADD COLUMN IF NOT EXISTS institution TEXT;
ALTER TABLE education_entries ADD COLUMN IF NOT EXISTS degree TEXT;
ALTER TABLE education_entries ADD COLUMN IF NOT EXISTS field_of_study TEXT;
ALTER TABLE education_entries ADD COLUMN IF NOT EXISTS grad_year INTEGER;

-- ============================================================================
-- FUNCTIONS (Name-formula calculations backing each view's `name` column)
-- ============================================================================

SET check_function_bodies = off;

CREATE OR REPLACE FUNCTION calc_site_settings_name(p_site_setting_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(site_setting_id, '') FROM site_settings WHERE site_setting_id = p_site_setting_id))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_currently_items_name(p_currently_item_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(title, '') FROM currently_items WHERE currently_item_id = p_currently_item_id))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_bio_variants_name(p_bio_variant_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(label, '') FROM bio_variants WHERE bio_variant_id = p_bio_variant_id))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_how_i_work_sections_name(p_how_i_work_section_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(heading, '') FROM how_i_work_sections WHERE how_i_work_section_id = p_how_i_work_section_id))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_proof_points_name(p_proof_point_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(title, '') FROM proof_points WHERE proof_point_id = p_proof_point_id))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_job_entries_name(p_job_entries_id TEXT)
RETURNS TEXT AS $$
  SELECT (CONCAT((SELECT NULLIF(company, '') FROM job_entries WHERE job_entries_id = p_job_entries_id), ' - ', (SELECT NULLIF(job_title, '') FROM job_entries WHERE job_entries_id = p_job_entries_id)))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_resume_variants_name(p_resume_variant_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(label, '') FROM resume_variants WHERE resume_variant_id = p_resume_variant_id))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_resume_list_items_name(p_resume_list_item_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(label, '') FROM resume_list_items WHERE resume_list_item_id = p_resume_list_item_id))::text;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION calc_education_entries_name(p_education_entries_id TEXT)
RETURNS TEXT AS $$
  SELECT (CONCAT((SELECT NULLIF(institution, '') FROM education_entries WHERE education_entries_id = p_education_entries_id), ' - ', (SELECT NULLIF(degree, '') FROM education_entries WHERE education_entries_id = p_education_entries_id)))::text;
$$ LANGUAGE sql STABLE;

-- ============================================================================
-- VIEWS
-- ============================================================================
-- DROP ... CASCADE is safe here ONLY because this is the first migration
-- against a fresh base: nothing can yet depend on a view that has never
-- existed. Do not copy this pattern into a later migration without first
-- checking for real dependents (use CREATE OR REPLACE VIEW there instead,
-- or verify with pg_depend).

DROP VIEW IF EXISTS vw_education_entries CASCADE;
DROP VIEW IF EXISTS vw_resume_list_items CASCADE;
DROP VIEW IF EXISTS vw_resume_variants CASCADE;
DROP VIEW IF EXISTS vw_job_entries CASCADE;
DROP VIEW IF EXISTS vw_proof_points CASCADE;
DROP VIEW IF EXISTS vw_how_i_work_sections CASCADE;
DROP VIEW IF EXISTS vw_bio_variants CASCADE;
DROP VIEW IF EXISTS vw_currently_items CASCADE;
DROP VIEW IF EXISTS vw_site_settings CASCADE;

CREATE VIEW vw_site_settings WITH (security_invoker = ON) AS
SELECT
  t.site_setting_id,
  calc_site_settings_name(t.site_setting_id) AS name,
  t.contact_email,
  t.contact_phone,
  t.site_domain,
  t.portfolio_company_count,
  t.self_description_line,
  t.positioning_statement,
  t.hero_headline,
  t.hero_subheadline,
  t.banyan_title
FROM site_settings t;

CREATE VIEW vw_currently_items WITH (security_invoker = ON) AS
SELECT
  t.currently_item_id,
  calc_currently_items_name(t.currently_item_id) AS name,
  t.title,
  t.body_text,
  t.sort_order
FROM currently_items t;

CREATE VIEW vw_bio_variants WITH (security_invoker = ON) AS
SELECT
  t.bio_variant_id,
  calc_bio_variants_name(t.bio_variant_id) AS name,
  t.label,
  t.usage_context,
  t.body_text,
  t.sort_order
FROM bio_variants t;

CREATE VIEW vw_how_i_work_sections WITH (security_invoker = ON) AS
SELECT
  t.how_i_work_section_id,
  calc_how_i_work_sections_name(t.how_i_work_section_id) AS name,
  t.heading,
  t.body_text,
  t.short_body_text,
  t.sort_order
FROM how_i_work_sections t;

CREATE VIEW vw_proof_points WITH (security_invoker = ON) AS
SELECT
  t.proof_point_id,
  calc_proof_points_name(t.proof_point_id) AS name,
  t.title,
  t.problem_text,
  t.action_text,
  t.outcome_text,
  t.attribution_note,
  t.register_note,
  t.client_or_category,
  t.status_label,
  t.featured_on_work_page,
  t.featured_in_resume_selected_work,
  t.image_url,
  t.sort_order
FROM proof_points t;

CREATE VIEW vw_job_entries WITH (security_invoker = ON) AS
SELECT
  t.job_entries_id,
  t.job_entry_id,
  calc_job_entries_name(t.job_entries_id) AS name,
  t.company,
  t.job_title,
  t.start_date,
  t.end_date,
  t.is_current,
  t.display_group_key,
  t.summary_text_variant_a,
  t.summary_text_variant_b,
  t.compressed_line,
  t.include_in_variant_a,
  t.include_in_variant_b,
  t.is_pre2019,
  t.sort_order
FROM job_entries t;

CREATE VIEW vw_resume_variants WITH (security_invoker = ON) AS
SELECT
  t.resume_variant_id,
  calc_resume_variants_name(t.resume_variant_id) AS name,
  t.label,
  t.audience_description,
  t.summary_text,
  t.published_on_site
FROM resume_variants t;

CREATE VIEW vw_resume_list_items WITH (security_invoker = ON) AS
SELECT
  t.resume_list_item_id,
  calc_resume_list_items_name(t.resume_list_item_id) AS name,
  t.category,
  t.label,
  t.sort_order
FROM resume_list_items t;

CREATE VIEW vw_education_entries WITH (security_invoker = ON) AS
SELECT
  t.education_entries_id,
  t.education_entry_id,
  calc_education_entries_name(t.education_entries_id) AS name,
  t.institution,
  t.degree,
  t.field_of_study,
  t.grad_year
FROM education_entries t;

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
-- Enabled on all 9 tables, no policies yet. The admin app connects with the
-- privileged `adminRole` credentials from apply-privileges-template, which
-- bypass RLS — so this doesn't block the CMS. Policies (if ever needed for
-- a lower-privileged/public role) are wired separately via
-- bases' setup-trusted-tenants + policy templates, not in this migration.

ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE currently_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE bio_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE how_i_work_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE proof_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_list_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE education_entries ENABLE ROW LEVEL SECURITY;
