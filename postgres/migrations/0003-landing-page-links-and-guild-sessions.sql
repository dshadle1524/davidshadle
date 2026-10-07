-- ============================================================================
-- Migration 0003: Landing page section links + designing-for-people-and-agents
-- ============================================================================
-- Adds LandingPageSections.LinkLabel / LinkHref (an optional link under a
-- section), refreshes vw_landing_page_sections to expose them, and seeds the
-- second landing page (designing-for-people-and-agents, unpublished).
-- Applied via postgres/apply-migration.sh, never postgres/init-db.sh.
--
-- Idempotent: ADD COLUMN IF NOT EXISTS / CREATE OR REPLACE. The new view
-- columns are appended after the existing ones, so CREATE OR REPLACE is valid.
-- Seed rows use ON CONFLICT DO NOTHING so a re-run never overwrites copy
-- edited through the admin CMS.
-- ============================================================================

SET timezone = 'UTC';

-- ============================================================================
-- COLUMNS
-- ============================================================================

ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS link_label TEXT;                         -- Optional link text shown under the section.
ALTER TABLE landing_page_sections ADD COLUMN IF NOT EXISTS link_href TEXT;                          -- Optional link target. A link to another landing page is shown only while that page is published.
COMMENT ON COLUMN landing_page_sections.link_label IS 'Optional link text shown under the section.';
COMMENT ON COLUMN landing_page_sections.link_href IS 'Optional link target. A link to another landing page is shown only while that page is published.';

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- get_landing_page_sections_link_label
-- Helper function: Get LinkLabel from LandingPageSections by LandingPageSectionId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_sections_link_label(p_landing_page_section_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT link_label FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id);
$$ LANGUAGE sql STABLE;

-- get_landing_page_sections_link_href
-- Helper function: Get LinkHref from LandingPageSections by LandingPageSectionId
-- Used for join-free cross-table references in aggregations

CREATE OR REPLACE FUNCTION get_landing_page_sections_link_href(p_landing_page_section_id TEXT)
RETURNS TEXT AS $$
  SELECT (SELECT link_href FROM landing_page_sections WHERE landing_page_section_id = p_landing_page_section_id);
$$ LANGUAGE sql STABLE;

-- ============================================================================
-- VIEWS
-- ============================================================================

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
  t.body_text,                                                                  -- Section body copy. Paragraph breaks encoded as \n\n.
  t.link_label,                                                                 -- Optional link text shown under the section.
  t.link_href                                                                   -- Optional link target. A link to another landing page is shown only while that page is published.
FROM landing_page_sections t;

-- ============================================================================
-- SEED ROWS (designing-for-people-and-agents)
-- ============================================================================

INSERT INTO landing_pages (landing_page_id, meta_title, meta_description, eyebrow, headline, lede, video_url, primary_cta_label, primary_cta_href, secondary_cta_label, secondary_cta_href, is_published)
VALUES ('designing-for-people-and-agents', 'Designing for People and Agents: Guild Sessions by David Shadle', 'Five 40-minute Guild Sessions for Banyan operating companies on how AI agents change forms, reports, help, and the service behind the screen. Each one leaves you something to try the following week.', 'Guild Sessions', 'Designing for People and Agents', 'Software was built for a person at a screen. More and more, the user is an agent acting for that person, with no screen at all, and most analytics cannot see it. Five 40-minute Guild Sessions, each on one place the shift shows up in a product.', NULL, 'Ask about the next session', 'mailto:david@davidshadle.com?subject=Guild%20Sessions%3A%20Designing%20for%20People%20and%20Agents', 'See the five sessions', '#the-five-sessions', FALSE) ON CONFLICT (landing_page_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text, link_label, link_href)
VALUES ('designing-for-people-and-agents-the-series', 'designing-for-people-and-agents', 1, 'prose', NULL, 'The series', 'One shift, five places it shows up.', 'Designing for People and Agents is a series of five 40-minute Guild Sessions, held monthly, live and online, presented by David Shadle. Each one covers one place the shift shows up in a product. Every session leaves attendees with something to try the following week.

The sessions build on one another. The series starts with seeing who uses the product, moves through what the product exposes and what its terms mean, and ends with how the service runs and how people interact with it. Each session also stands on its own.

Any role at an OpCo can attend: leadership, product, engineering, design, and customer-facing teams. Technical topics stay at a high level, leaning technical where they apply to the business and the reasons to integrate.', NULL, NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text, link_label, link_href)
VALUES ('designing-for-people-and-agents-why-now', 'designing-for-people-and-agents', 2, 'prose', NULL, 'Why now', 'The shift is already in the traffic.', 'Fastly reported in June 2026 that AI traffic grew about 6.5 times faster than human traffic in the first five months of the year. Cloudflare reported in July 2026 that more than half of internet traffic is now non-human. DataDome counted 17.7 billion AI agent requests in a single quarter, up 45 percent on the quarter before.

Some of that traffic collects content and sends nothing back. Some of it is an agent acting for a real customer: checking availability, comparing options, completing a task. Most products were not designed for that customer, and most measurement does not count it. Forms, reports, and help, the patterns that shaped business software, are changing at the same time.

Much of what OpCos need to respond is not new. The principles behind it have been in use for decades. What is new is how much they now matter, and how quickly. The series connects the two.', NULL, NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text, link_label, link_href)
VALUES ('designing-for-people-and-agents-the-five-sessions', 'designing-for-people-and-agents', 3, 'cards', 'the-five-sessions', 'The five sessions', 'One session a month.', 'After each session, attendees receive a one-page takeaway with the self-check and the action to try.', NULL, NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text, link_label, link_href)
VALUES ('designing-for-people-and-agents-after-the-session', 'designing-for-people-and-agents', 4, 'cards', NULL, 'After the session', 'Two ways to use what you learn.', NULL, 'How an Idea to Evidence engagement works', '/idea-to-evidence') ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text, link_label, link_href)
VALUES ('designing-for-people-and-agents-who-presents', 'designing-for-people-and-agents', 5, 'prose', NULL, 'Who presents', 'David Shadle.', 'Content for every session is written and presented by David Shadle, who has spent twenty years leading product, design, and engineering teams. Examples drawn from the portfolio are named only with the OpCo''s agreement. The series informs. It does not assess any OpCo, roadmap, or team.', NULL, NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_sections (landing_page_section_id, landing_page, sort_order, kind, anchor_id, eyebrow, heading, body_text, link_label, link_href)
VALUES ('designing-for-people-and-agents-next-session', 'designing-for-people-and-agents', 6, 'callout', NULL, 'Next session', 'Ask about the next session.', 'Dates will be announced to Banyan operating companies. To be told first, or to ask about bringing a pattern into your own product, get in touch.', NULL, NULL) ON CONFLICT (landing_page_section_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see', 'designing-for-people-and-agents-the-five-sessions', 1, 'Month 1', 'The user you cannot see', 'Agents now use products directly. Most analytics are built for a browser and cannot count them.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform', 'designing-for-people-and-agents-the-five-sessions', 2, 'Month 2', 'Every product is a platform', 'When an agent uses the product, the interface is what lies under the screen: field names, tool descriptions, and error messages.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere', 'designing-for-people-and-agents-the-five-sessions', 3, 'Month 3', 'One definition, served everywhere', 'People and agents need the same answer to the same question. Most companies hold several answers.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen', 'designing-for-people-and-agents-the-five-sessions', 4, 'Month 4', 'Design the service, not the screen', 'Steps in a customer''s journey now happen where nobody sees them, carried out by software acting for someone.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-beyond-the-form', 'designing-for-people-and-agents-the-five-sessions', 5, 'Month 5', 'Beyond the form', 'Forms, reports, and help shaped business software. AI is turning them into intent, answers, and action.') ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('designing-for-people-and-agents-after-the-session-on-your-own', 'designing-for-people-and-agents-after-the-session', 1, NULL, 'On your own', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_items (landing_page_item_id, landing_page_section, sort_order, label, heading, body_text)
VALUES ('designing-for-people-and-agents-after-the-session-in-an-engagement', 'designing-for-people-and-agents-after-the-session', 2, NULL, 'In an engagement', NULL) ON CONFLICT (landing_page_item_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see-fact-1', 'designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see', 1, 'Participants learn', 'How agent traffic differs from human traffic, and from crawlers that only collect content.
How to read server logs as a journey map: retries, dead ends, and paths nobody documented.
Why task completion is a better measure than page views when the user is an agent.
How to decide which agents get in, before a vendor default decides it.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see-fact-2', 'designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see', 2, 'Try it on your own', 'Pull 30 days of logs. Separate browser traffic, your own clients, and everything else. Rebuild one agent session in order and note where it stopped.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see-fact-3', 'designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see', 3, 'Take it into an engagement', 'Agent traffic read-out. The team leaves with an agent journey map, a first definition of a good agent session, and a draft access policy.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see-fact-4', 'designing-for-people-and-agents-the-five-sessions-the-user-you-cannot-see', 4, 'Reports against', 'Gross and net retention, where agents act for existing customers.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform-fact-1', 'designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform', 1, 'Participants learn', 'How to map every way into the product, including the ones nobody designed.
Which rules the screens enforced that an agent calling the product never sees.
What MCP solves, and what it leaves for the product team.
How to write error messages an agent can recover from.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform-fact-2', 'designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform', 2, 'Try it on your own', 'List every way into the product and who owns each. Give an AI assistant one tool description and a real task. Watch where it goes wrong.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform-fact-3', 'designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform', 3, 'Take it into an engagement', 'Door map and agent test. The team leaves with an inventory of every way in, with owners, and one core task an agent can complete without a person stepping in.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform-fact-4', 'designing-for-people-and-agents-the-five-sessions-every-product-is-a-platform', 4, 'Reports against', 'Time from idea to release.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere-fact-1', 'designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere', 1, 'Participants learn', 'Why competitors are agreeing on shared definitions for metrics.
What context engineering is, and why support tickets and call recordings are now product assets.
How content written in structured pieces serves every channel and every agent.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere-fact-2', 'designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere', 2, 'Try it on your own', 'Ask five leaders to write down, separately, what an active customer is. Compare the answers.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere-fact-3', 'designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere', 3, 'Take it into an engagement', 'Define once. The team leaves with agreed definitions, an owner for each, and a plan to structure one knowledge source.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere-fact-4', 'designing-for-people-and-agents-the-five-sessions-one-definition-served-everywhere', 4, 'Reports against', 'The Value Creation Plan metrics themselves.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen-fact-1', 'designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen', 1, 'Participants learn', 'How a service blueprint shows what the customer sees and everything behind it.
Where an agent sits in the blueprint, and what changes when it acts unattended.
How a demo works as a storyboard: one picture of the future service for every department.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen-fact-2', 'designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen', 2, 'Try it on your own', 'Pick one journey, such as onboarding or renewal. Mark each step where an agent acts or could act, and whether the customer can see it.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen-fact-3', 'designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen', 3, 'Take it into an engagement', 'Blueprint with agents. The team leaves with a current and future blueprint, a demo of the future service, and a candidate opportunity.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen-fact-4', 'designing-for-people-and-agents-the-five-sessions-design-the-service-not-the-screen', 4, 'Reports against', 'Gross and net retention.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-beyond-the-form-fact-1', 'designing-for-people-and-agents-the-five-sessions-beyond-the-form', 1, 'Participants learn', 'Where a form can accept what a person means, in place of what a field requires.
When software should decide, when it should ask, and how it shows what it assumed.
How work changes when people supervise agents in place of doing the task.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-beyond-the-form-fact-2', 'designing-for-people-and-agents-the-five-sessions-beyond-the-form', 2, 'Try it on your own', 'Pick one form. At each field, decide whether the software should ask, decide, or act.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-beyond-the-form-fact-3', 'designing-for-people-and-agents-the-five-sessions-beyond-the-form', 3, 'Take it into an engagement', 'Paradigm ideation. The team leaves with a demo of a new way of working and a plan for a prototype to test with customers.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-the-five-sessions-beyond-the-form-fact-4', 'designing-for-people-and-agents-the-five-sessions-beyond-the-form', 4, 'Reports against', 'Upsell, good-better-best packaging, and net retention.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-after-the-session-on-your-own-fact-1', 'designing-for-people-and-agents-after-the-session-on-your-own', 1, 'What it involves', 'The self-check during the session and the action in the takeaway. No outside help and no cost.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-after-the-session-on-your-own-fact-2', 'designing-for-people-and-agents-after-the-session-on-your-own', 2, 'What you have at the end', 'A first view of the pattern in your own product, and a decision on whether to go further.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-after-the-session-in-an-engagement-fact-1', 'designing-for-people-and-agents-after-the-session-in-an-engagement', 1, 'What it involves', 'A free Discovery conversation, then the Idea to Evidence Assessment, targeted at the pattern. The working session for that pattern runs inside the Assessment.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
INSERT INTO landing_page_item_facts (landing_page_item_fact_id, landing_page_item, sort_order, label, body_text)
VALUES ('designing-for-people-and-agents-after-the-session-in-an-engagement-fact-2', 'designing-for-people-and-agents-after-the-session-in-an-engagement', 2, 'What you have at the end', 'A demo that aligns leadership on the idea, and, if you continue, a prototype tested with your own customers and a Value Review at 90 and 180 days.') ON CONFLICT (landing_page_item_fact_id) DO NOTHING;
