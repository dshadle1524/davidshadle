-- ============================================================================
-- 99-fk-constraints.sql — FK CONSTRAINTS (off by default)
-- ============================================================================
-- Demos must never fail on FK violations, so init-db.sh SKIPS this file
-- unless EFFORTLESS_ENFORCE_FKS=true is set in the environment.
--
--   EFFORTLESS_ENFORCE_FKS=true bash init-db.sh    # apply constraints
--   bash init-db.sh                                # leave them documented but unenforced
--
-- The rulebook always documents the FK relationships, and 01-drop-and-create-tables.sql
-- always installs the supporting indexes inline. This file just declares the actual
-- enforcement. Idempotent: every constraint is dropped if present, then added.
-- ============================================================================

-- LandingPageSections
ALTER TABLE landing_page_sections DROP CONSTRAINT IF EXISTS fk_landing_page_sections_landing_page;
ALTER TABLE landing_page_sections ADD CONSTRAINT fk_landing_page_sections_landing_page
  FOREIGN KEY (landing_page) REFERENCES landing_pages (landing_page_id);

-- LandingPageItems
ALTER TABLE landing_page_items DROP CONSTRAINT IF EXISTS fk_landing_page_items_landing_page_section;
ALTER TABLE landing_page_items ADD CONSTRAINT fk_landing_page_items_landing_page_section
  FOREIGN KEY (landing_page_section) REFERENCES landing_page_sections (landing_page_section_id);

-- LandingPageItemFacts
ALTER TABLE landing_page_item_facts DROP CONSTRAINT IF EXISTS fk_landing_page_item_facts_landing_page_item;
ALTER TABLE landing_page_item_facts ADD CONSTRAINT fk_landing_page_item_facts_landing_page_item
  FOREIGN KEY (landing_page_item) REFERENCES landing_page_items (landing_page_item_id);

-- 3 FK constraint(s) declared (off unless EFFORTLESS_ENFORCE_FKS=true).
