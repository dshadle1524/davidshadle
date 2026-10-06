-- ============================================================================
-- Migration 0002: Landing pages (LandingPages, LandingPageSections,
--                 LandingPageItems, LandingPageItemFacts)
-- ============================================================================
-- Projects the rulebook's landing-page tables onto the bases-hosted CMS
-- database, plus the first page (idea-to-evidence, unpublished).
-- Applied via postgres/apply-migration.sh, never postgres/init-db.sh.
--
-- Idempotent: CREATE TABLE IF NOT EXISTS / ADD COLUMN IF NOT EXISTS /
-- CREATE OR REPLACE FUNCTION / CREATE OR REPLACE VIEW. Nothing is dropped.
-- Seed rows use ON CONFLICT DO NOTHING so a re-run never overwrites copy
-- edited through the admin CMS.
-- ============================================================================

SET timezone = 'UTC';

-- ============================================================================
-- TABLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- LandingPages: Table: LandingPages. One promotional landing page per row, reachable only by its direct URL. LandingPageId is the URL slug.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS landing_pages (
  landing_page_id                     TEXT                 PRIMARY KEY          -- Stored identity. The URL slug, for example idea-to-evidence.
);
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS meta_title TEXT;                                 -- Browser title and Open Graph title.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS meta_description TEXT;                           -- Meta description and Open Graph description.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS eyebrow TEXT;                                    -- Small label above the headline in the hero.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS headline TEXT;                                   -- The page h1.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS lede TEXT;                                       -- Opening paragraph under the headline.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS video_url TEXT;                                  -- Optional YouTube link. When present, the video is shown in the hero between the eyebrow and the headline.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS primary_cta_label TEXT;                          -- Label of the primary call-to-action button.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS primary_cta_href TEXT;                           -- Target of the primary call-to-action button (mailto: or path).
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS secondary_cta_label TEXT;                        -- Label of the optional secondary button.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS secondary_cta_href TEXT;                         -- Target of the optional secondary button.
ALTER TABLE landing_pages ADD COLUMN IF NOT EXISTS is_published BOOLEAN;                            -- Whether the page is served. Unpublished pages return 404.
COMMENT ON TABLE landing_pages IS 'Table: LandingPages. One promotional landing page per row, reachable only by its direct URL. LandingPageId is the URL slug.';
COMMENT ON COLUMN landing_pages.landing_page_id IS 'Stored identity. The URL slug, for example idea-to-evidence.';
COMMENT ON COLUMN landing_pages.meta_title IS 'Browser title and Open Graph title.';
COMMENT ON COLUMN landing_pages.meta_description IS 'Meta description and Open Graph description.';
COMMENT ON COLUMN landing_pages.eyebrow IS 'Small label above the headline in the hero.';
COMMENT ON COLUMN landing_pages.headline IS 'The page h1.';
COMMENT ON COLUMN landing_pages.lede IS 'Opening paragraph under the headline.';
COMMENT ON COLUMN landing_pages.video_url IS 'Optional YouTube link. When present, the video is shown in the hero between the eyebrow and the headline.';
COMMENT ON COLUMN landing_pages.primary_cta_label IS 'Label of the primary call-to-action button.';
COMMENT ON COLUMN landing_pages.primary_cta_href IS 'Target of the primary call-to-action button (mailto: or path).';
COMMENT ON COLUMN landing_pages.secondary_cta_label IS 'Label of the optional secondary button.';
COMMENT ON COLUMN landing_pages.secondary_cta_href IS 'Target of the optional secondary button.';
COMMENT ON COLUMN landing_pages.is_published IS 'Whether the page is served. Unpublished pages return 404.';

-- ----------------------------------------------------------------------------
-- LandingPageSections: Table: LandingPageSections. The ordered sections of a landing page. Kind selects the renderer.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS landing_page_sections (
  landing_page_section_id             TEXT                 PRIMARY KEY          -- Stored identity, slug form.
);
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS landing_page TEXT;                       -- The landing page this section belongs to.
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS sort_order INTEGER;                      -- Display order within the page.
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS kind TEXT;                               -- Renderer: prose, list, steps, cards or callout.
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS anchor_id TEXT;                          -- Optional HTML id for the section, for in-page links.
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS eyebrow TEXT;                            -- Small label above the section heading.
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS heading TEXT;                            -- Section heading.
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS body_text TEXT;                          -- Section body copy. Paragraph breaks encoded as \n\n.
COMMENT ON TABLE landing_page_sections IS 'Table: LandingPageSections. The ordered sections of a landing page. Kind selects the renderer.';
COMMENT ON COLUMN landing_page_sections.landing_page_section_id IS 'Stored identity, slug form.';
COMMENT ON COLUMN landing_page_sections.landing_page IS 'The landing page this section belongs to.';
COMMENT ON COLUMN landing_page_sections.sort_order IS 'Display order within the page.';
COMMENT ON COLUMN landing_page_sections.kind IS 'Renderer: prose, list, steps, cards or callout.';
COMMENT ON COLUMN landing_page_sections.anchor_id IS 'Optional HTML id for the section, for in-page links.';
COMMENT ON COLUMN landing_page_sections.eyebrow IS 'Small label above the section heading.';
COMMENT ON COLUMN landing_page_sections.heading IS 'Section heading.';
COMMENT ON COLUMN landing_page_sections.body_text IS 'Section body copy. Paragraph breaks encoded as \n\n.';

-- ----------------------------------------------------------------------------
-- LandingPageItems: Table: LandingPageItems. The ordered items inside a landing page section (cards, steps, list entries).
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS landing_page_items (
  landing_page_item_id                TEXT                 PRIMARY KEY          -- Stored identity, slug form.
);
ALTER TABLE landing_page_items ADD COLUMN IF NOT EXISTS landing_page_section TEXT;                  -- The section this item belongs to.
ALTER TABLE landing_page_items ADD COLUMN IF NOT EXISTS sort_order INTEGER;                         -- Display order within the section.
ALTER TABLE landing_page_items ADD COLUMN IF NOT EXISTS label TEXT;                                 -- Optional short marker, for example a step number.
ALTER TABLE landing_page_items ADD COLUMN IF NOT EXISTS heading TEXT;                               -- Item heading.
ALTER TABLE landing_page_items ADD COLUMN IF NOT EXISTS body_text TEXT;                             -- Item body copy.
COMMENT ON TABLE landing_page_items IS 'Table: LandingPageItems. The ordered items inside a landing page section (cards, steps, list entries).';
COMMENT ON COLUMN landing_page_items.landing_page_item_id IS 'Stored identity, slug form.';
COMMENT ON COLUMN landing_page_items.landing_page_section IS 'The section this item belongs to.';
COMMENT ON COLUMN landing_page_items.sort_order IS 'Display order within the section.';
COMMENT ON COLUMN landing_page_items.label IS 'Optional short marker, for example a step number.';
COMMENT ON COLUMN landing_page_items.heading IS 'Item heading.';
COMMENT ON COLUMN landing_page_items.body_text IS 'Item body copy.';

-- ----------------------------------------------------------------------------
-- LandingPageItemFacts: Table: LandingPageItemFacts. Labeled lines shown under a landing page item.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS landing_page_item_facts (
  landing_page_item_fact_id           TEXT                 PRIMARY KEY          -- Stored identity, slug form.
);
ALTER TABLE landing_page_item_facts ADD COLUMN IF NOT EXISTS landing_page_item TEXT;                -- The item this fact belongs to.
ALTER TABLE landing_page_item_facts ADD COLUMN IF NOT EXISTS sort_order INTEGER;                    -- Display order within the item.
ALTER TABLE landing_page_item_facts ADD COLUMN IF NOT EXISTS label TEXT;                            -- Fact label, for example What happens.
ALTER TABLE landing_page_item_facts ADD COLUMN IF NOT EXISTS body_text TEXT;                        -- Fact text. One fact per line when it is a list.
COMMENT ON TABLE landing_page_item_facts IS 'Table: LandingPageItemFacts. Labeled lines shown under a landing page item.';
COMMENT ON COLUMN landing_page_item_facts.landing_page_item_fact_id IS 'Stored identity, slug form.';
COMMENT ON COLUMN landing_page_item_facts.landing_page_item IS 'The item this fact belongs to.';
COMMENT ON COLUMN landing_page_item_facts.sort_order IS 'Display order within the item.';
COMMENT ON COLUMN landing_page_item_facts.label IS 'Fact label, for example What happens.';
COMMENT ON COLUMN landing_page_item_facts.body_text IS 'Fact text. One fact per line when it is a list.';

CREATE INDEX IF NOT EXISTS idx_landing_page_sections_landing_page ON landing_page_sections (landing_page);
CREATE INDEX IF NOT EXISTS idx_landing_page_items_landing_page_section ON landing_page_items (landing_page_section);
CREATE INDEX IF NOT EXISTS idx_landing_page_item_facts_landing_page_item ON landing_page_item_facts (landing_page_item);

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- calc_landing_pages_name
-- Field: LandingPages.Name
-- Type: calculated | DataType: string | Returns: TEXT


CREATE OR REPLACE FUNCTION calc_landing_pages_name(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(headline, '') FROM landing_pages WHERE landing_page_id = p_landing_page_id))::text;
$$ LANGUAGE sql STABLE;

-- get_landing_pages_meta_title
-- Helper function: Get MetaTitle from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_meta_title(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT meta_title FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_meta_description
-- Helper function: Get MetaDescription from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_meta_description(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT meta_description FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_eyebrow
-- Helper function: Get Eyebrow from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_eyebrow(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT eyebrow FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_headline
-- Helper function: Get Headline from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_headline(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT headline FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_lede
-- Helper function: Get Lede from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_lede(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT lede FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_video_url
-- Helper function: Get VideoUrl from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_video_url(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT video_url FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_primary_cta_label
-- Helper function: Get PrimaryCtaLabel from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_primary_cta_label(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT primary_cta_label FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_primary_cta_href
-- Helper function: Get PrimaryCtaHref from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_primary_cta_href(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT primary_cta_href FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_secondary_cta_label
-- Helper function: Get SecondaryCtaLabel from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_secondary_cta_label(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT secondary_cta_label FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_secondary_cta_href
-- Helper function: Get SecondaryCtaHref from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_secondary_cta_href(p_landing_page_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT secondary_cta_href FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- get_landing_pages_is_published
-- Helper function: Get IsPublished from LandingPages by LandingPageId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_pages_is_published(p_landing_page_id TEXT)
RETURNS BOOLEAN AS $$
  SELECT (SELECT is_published FROM landing_pages WHERE landing_page_id = p_landing_page_id);
$$ LANGUAGE sql STABLE;

-- calc_landing_page_sections_name
-- Field: LandingPageSections.Name
-- Type: calculated | DataType: string | Returns: TEXT


CREATE OR REPLACE FUNCTION calc_landing_page_sections_name(p_landing_page_section_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(heading, '') FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id))::text;
$$ LANGUAGE sql STABLE;

-- get_landing_page_sections_sort_order
-- Helper function: Get SortOrder from LandingPageSections by LandingPageSectionId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_sections_sort_order(p_landing_page_section_id TEXT)
RETURNS INTEGER AS $$
  SELECT (SELECT sort_order FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_sections_kind
-- Helper function: Get Kind from LandingPageSections by LandingPageSectionId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_sections_kind(p_landing_page_section_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT kind FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_sections_eyebrow
-- Helper function: Get Eyebrow from LandingPageSections by LandingPageSectionId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_sections_eyebrow(p_landing_page_section_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT eyebrow FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_sections_heading
-- Helper function: Get Heading from LandingPageSections by LandingPageSectionId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_sections_heading(p_landing_page_section_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT heading FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_sections_body_text
-- Helper function: Get BodyText from LandingPageSections by LandingPageSectionId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_sections_body_text(p_landing_page_section_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT body_text FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id);
$$ LANGUAGE sql STABLE;

-- calc_landing_page_items_name
-- Field: LandingPageItems.Name
-- Type: calculated | DataType: string | Returns: TEXT


CREATE OR REPLACE FUNCTION calc_landing_page_items_name(p_landing_page_item_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(heading, '') FROM landing_page_items WHERE landing_page_item_id = p_landing_page_item_id))::text;
$$ LANGUAGE sql STABLE;

-- get_landing_page_items_sort_order
-- Helper function: Get SortOrder from LandingPageItems by LandingPageItemId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_items_sort_order(p_landing_page_item_id TEXT)
RETURNS INTEGER AS $$
  SELECT (SELECT sort_order FROM landing_page_items WHERE landing_page_item_id = p_landing_page_item_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_items_label
-- Helper function: Get Label from LandingPageItems by LandingPageItemId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_items_label(p_landing_page_item_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT label FROM landing_page_items WHERE landing_page_item_id = p_landing_page_item_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_items_heading
-- Helper function: Get Heading from LandingPageItems by LandingPageItemId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_items_heading(p_landing_page_item_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT heading FROM landing_page_items WHERE landing_page_item_id = p_landing_page_item_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_items_body_text
-- Helper function: Get BodyText from LandingPageItems by LandingPageItemId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_items_body_text(p_landing_page_item_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT body_text FROM landing_page_items WHERE landing_page_item_id = p_landing_page_item_id);
$$ LANGUAGE sql STABLE;

-- calc_landing_page_item_facts_name
-- Field: LandingPageItemFacts.Name
-- Type: calculated | DataType: string | Returns: TEXT


CREATE OR REPLACE FUNCTION calc_landing_page_item_facts_name(p_landing_page_item_fact_id TEXT)
RETURNS TEXT AS $$
  SELECT ((SELECT NULLIF(label, '') FROM landing_page_item_facts WHERE landing_page_item_fact_id = p_landing_page_item_fact_id))::text;
$$ LANGUAGE sql STABLE;

-- ============================================================================
-- MANY-SIDE RELATIONSHIP FUNCTIONS
-- These functions aggregate child records for many-side relationships
-- ============================================================================

-- ============================================================================
-- INVERSE RELATIONSHIP FUNCTIONS
-- These functions perform reverse FK lookups for inverse-side relationships
-- ============================================================================

-- ============================================================================
-- VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- vw_landing_pages: Table: LandingPages. One promotional landing page per row, reachable only by its direct URL. LandingPageId is the URL slug.
-- Combines base table columns with calculated/lookup/aggregation fields.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_landing_pages WITH (security_invoker = ON) AS
SELECT
  t.landing_page_id,                                                            -- Stored identity. The URL slug, for example idea-to-evidence.
  calc_landing_pages_name(t.landing_page_id) AS name,                           -- Display alias.
  t.meta_title,                                                                 -- Browser title and Open Graph title.
  t.meta_description,                                                           -- Meta description and Open Graph description.
  t.eyebrow,                                                                    -- Small label above the headline in the hero.
  t.headline,                                                                   -- The page h1.
  t.lede,                                                                       -- Opening paragraph under the headline.
  t.video_url,                                                                  -- Optional YouTube link. When present, the video is shown in the hero between the eyebrow and the headline.
  t.primary_cta_label,                                                          -- Label of the primary call-to-action button.
  t.primary_cta_href,                                                           -- Target of the primary call-to-action button (mailto: or path).
  t.secondary_cta_label,                                                        -- Label of the optional secondary button.
  t.secondary_cta_href,                                                         -- Target of the optional secondary button.
  t.is_published                                                                -- Whether the page is served. Unpublished pages return 404.
FROM landing_pages t;

-- ----------------------------------------------------------------------------
-- vw_landing_page_sections: Table: LandingPageSections. The ordered sections of a landing page. Kind selects the renderer.
-- Combines base table columns with calculated/lookup/aggregation fields.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_landing_page_sections WITH (security_invoker = ON) AS
SELECT
  t.landing_page_section_id,                                                    -- Stored identity, slug form.
  calc_landing_page_sections_name(t.landing_page_section_id) AS name,           -- Display alias.
  t.landing_page,                                                               -- The landing page this section belongs to.
  t.sort_order,                                                                 -- Display order within the page.
  t.kind,                                                                       -- Renderer: prose, list, steps, cards or callout.
  t.anchor_id,                                                                  -- Optional HTML id for the section, for in-page links.
  t.eyebrow,                                                                    -- Small label above the section heading.
  t.heading,                                                                    -- Section heading.
  t.body_text                                                                   -- Section body copy. Paragraph breaks encoded as \n\n.
FROM landing_page_sections t;

-- ----------------------------------------------------------------------------
-- vw_landing_page_items: Table: LandingPageItems. The ordered items inside a landing page section (cards, steps, list entries).
-- Combines base table columns with calculated/lookup/aggregation fields.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_landing_page_items WITH (security_invoker = ON) AS
SELECT
  t.landing_page_item_id,                                                       -- Stored identity, slug form.
  calc_landing_page_items_name(t.landing_page_item_id) AS name,                 -- Display alias.
  t.landing_page_section,                                                       -- The section this item belongs to.
  t.sort_order,                                                                 -- Display order within the section.
  t.label,                                                                      -- Optional short marker, for example a step number.
  t.heading,                                                                    -- Item heading.
  t.body_text                                                                   -- Item body copy.
FROM landing_page_items t;

-- ----------------------------------------------------------------------------
-- vw_landing_page_item_facts: Table: LandingPageItemFacts. Labeled lines shown under a landing page item.
-- Combines base table columns with calculated/lookup/aggregation fields.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_landing_page_item_facts WITH (security_invoker = ON) AS
SELECT
  t.landing_page_item_fact_id,                                                  -- Stored identity, slug form.
  calc_landing_page_item_facts_name(t.landing_page_item_fact_id) AS name,       -- Display alias.
  t.landing_page_item,                                                          -- The item this fact belongs to.
  t.sort_order,                                                                 -- Display order within the item.
  t.label,                                                                      -- Fact label, for example What happens.
  t.body_text                                                                   -- Fact text. One fact per line when it is a list.
FROM landing_page_item_facts t;

-- ============================================================================
-- SEED ROWS (idea-to-evidence)
-- ============================================================================

INSERT INTO landing_pages (landing_page_id, meta_title, meta_description, eyebrow, headline, lede, video_url, primary_cta_label, primary_cta_href, secondary_cta_label, secondary_cta_href, is_published)
VALUES ('idea-to-evidence', 'Idea to Evidence: David Shadle', 'One product idea, carried to a working prototype your customers have tested, so you decide what to build on evidence. A service for Banyan operating companies.', 'Idea to Evidence', 'New interaction concepts, prototyped and tested with your customers.', 'Idea to Evidence takes one idea for how your product could work and carries it to a working prototype that your customers (or agents) can interact with. You leave with evidence and a decision, not a recommendation.', 'https://www.youtube.com/watch?v=49NfG8CoGJQ', 'Let''s get started', 'mailto:david@davidshadle.com?subject=Idea%20to%20Evidence%3A%20Discovery%20conversation', 'Download the capability statement (PDF)', '/downloads/David-Shadle-Idea-to-Evidence-Capability-Statement.pdf', FALSE) ON CONFLICT (landing_page_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-why-now', 'idea-to-evidence', 1, 'prose', NULL, 'Why now', 'AI can now do part of the work your customers do by hand.', 'AI can act on a customer''s behalf, anticipate a need, and complete a task. Forms, reports, help, and transactions can all work differently. That opens new ways for your product to serve customers, and gives them a reason to renew and buy more.

Most leadership teams already have ideas about where to start. What is hard to find is the time to learn which idea is worth building before committing to build it. This engagement is built to find that out, in a few focused sessions, with the building and testing done outside your leadership team''s calendar.') ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-what-you-get', 'idea-to-evidence', 2, 'list', NULL, 'What you get', 'Five things you take away.', NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-ways-to-engage', 'idea-to-evidence', 3, 'cards', 'ways-to-engage', 'Ways to engage', 'Choose how far to go.', 'The level is chosen in Discovery and can be extended later.') ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-commitments', 'idea-to-evidence', 4, 'list', NULL, 'Commitments', 'Five commitments.', NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-who-it-is-for', 'idea-to-evidence', 5, 'prose', NULL, 'Who it is for', 'Operating company leadership.', 'Leadership of a Banyan operating company, usually the CEO or the person who holds product direction, working with the Operating Partner who owns the Value Creation Plan. OpCos arrive by referral from an Operating Partner or Banyan leadership, or after a Guild Session on an interaction pattern. Both routes begin with a free Discovery conversation.') ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-what-we-ask', 'idea-to-evidence', 6, 'list', NULL, 'What we ask of you', 'What the engagement needs from your side.', NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-your-data', 'idea-to-evidence', 7, 'prose', NULL, 'Your data', 'Your data stays yours.', 'Your data is used only for your engagement. Testing participants give consent and are not named. Everything produced, including testing records, transfers to you, and the provider keeps no copy. Nothing is shared with another company.') ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-about', 'idea-to-evidence', 8, 'prose', NULL, 'About', 'David Shadle.', 'Twenty years leading product, design, and engineering teams. I work where experience design and product strategy meet, and I build what I design. AI tools do the volume work of research, drafting, and building. My judgment decides what matters.') ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text)
VALUES ('idea-to-evidence-to-start', 'idea-to-evidence', 9, 'callout', 'to-start', 'To start', 'Request a free Discovery conversation.', 'One conversation to confirm fit, name the metric, and agree where to start.') ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-you-get-item-1', 'idea-to-evidence-what-you-get', 1, NULL, 'A decision on evidence.', 'Your customers use a working prototype before you commit to building it.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-you-get-item-2', 'idea-to-evidence-what-you-get', 2, NULL, 'New thinking on how your product works.', 'That includes where AI and agents can do part of the work while your customer stays in control.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-you-get-item-3', 'idea-to-evidence-what-you-get', 3, NULL, 'A build-ready handoff.', 'Working code, the full rulebook behind it, and an engineering scope your team can build from without starting over.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-you-get-item-4', 'idea-to-evidence-what-you-get', 4, NULL, 'A clear line to value.', 'The metric is named before any paid work begins, a baseline is taken, and results are reported at 90 and 180 days.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-you-get-item-5', 'idea-to-evidence-what-you-get', 5, NULL, 'Your team, able to run the next cycle on its own.', 'There is no retainer.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-ways-to-engage-understand', 'idea-to-evidence-ways-to-engage', 1, NULL, 'Understand', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-ways-to-engage-define', 'idea-to-evidence-ways-to-engage', 2, NULL, 'Define', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-ways-to-engage-prove', 'idea-to-evidence-ways-to-engage', 3, NULL, 'Prove', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-commitments-item-1', 'idea-to-evidence-commitments', 1, NULL, 'The initiative aligns to or extends your own roadmap.', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-commitments-item-2', 'idea-to-evidence-commitments', 2, NULL, 'Every engagement is tied to a Value Creation Plan metric, named in the first conversation.', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-commitments-item-3', 'idea-to-evidence-commitments', 3, NULL, 'The work ends in something built, used by your customers before any decision is made.', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-commitments-item-4', 'idea-to-evidence-commitments', 4, NULL, 'You own every output of each phase you complete.', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-commitments-item-5', 'idea-to-evidence-commitments', 5, NULL, 'Every engagement is time-bound and ends with your team able to run the next cycle.', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-we-ask-item-1', 'idea-to-evidence-what-we-ask', 1, NULL, 'A named owner.', 'Someone who holds the engagement and, after Handoff, the Value Review numbers.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-we-ask-item-2', 'idea-to-evidence-what-we-ask', 2, NULL, 'Leadership time.', 'For Discovery, the Assessment sessions, and the decision session.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('idea-to-evidence-what-we-ask-item-3', 'idea-to-evidence-what-we-ask', 3, NULL, 'Access and help.', 'The product, the data, and the people who know it best, plus help recruiting three to five customers for testing and engineering time at Handoff.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('idea-to-evidence-ways-to-engage-understand-fact-1', 'idea-to-evidence-ways-to-engage-understand', 1, 'Includes', 'Discovery and Audit') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('idea-to-evidence-ways-to-engage-understand-fact-2', 'idea-to-evidence-ways-to-engage-understand', 2, 'You take away', 'An outside, evidence-based view of your product and the opportunity worth pursuing.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('idea-to-evidence-ways-to-engage-define-fact-1', 'idea-to-evidence-ways-to-engage-define', 1, 'Includes', 'Understand, plus Assessment') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('idea-to-evidence-ways-to-engage-define-fact-2', 'idea-to-evidence-ways-to-engage-define', 2, 'You take away', 'One initiative, agreed and specified, ready to test or build.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('idea-to-evidence-ways-to-engage-prove-fact-1', 'idea-to-evidence-ways-to-engage-prove', 1, 'Includes', 'The full engagement') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('idea-to-evidence-ways-to-engage-prove-fact-2', 'idea-to-evidence-ways-to-engage-prove', 2, 'You take away', 'A tested prototype, a decision, a build-ready handoff, and the Value Review.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
