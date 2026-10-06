# Build prompt: davidshadle.com/designing-for-people-and-agents

**Run this in the `davidshadle-v4` repo.** Written for the Claude Code session that builds the page there.

## Task

Add one promotional landing page at **`/designing-for-people-and-agents`** that promotes the "Designing for People and Agents" Guild Session series: a series of five 40-minute live online sessions for Banyan Software operating companies (OpCos). The page gives a summary of the series, why now, and a description of each of the five sessions. The route segment uses hyphens, matching the site's other routes (`how-i-work`).

The page serves two readers: an OpCo leader deciding whether to send themselves or their team, and an Operating Partner deciding whether to pass the series on. Both need to see quickly what a session covers, what attendees leave with, and what to do next. Keep it calm and plain, like the rest of the site.

Place the page in `web/app/(site)/designing-for-people-and-agents/page.tsx`.

## Read this first: how this repo works

This repo (`davidshadle-v4`) is an **Effortless Rulebook (ERB)** project with a Next.js app in `web/`. Before doing anything, read the root `CLAUDE.md` and `web/AGENTS.md`, and obey them. The points that matter for this task:

- **Content is data, not code.** Site copy lives in `effortless-rulebook/effortless-rulebook.json` and is read by the app from `vw_*` views through `web/lib/content.ts` (see how `getHowIWorkSections` and `getSelectedWorkProofPoints` work). Pages render rows. They do not hardcode copy. Follow that pattern.
- **Never read the rulebook whole.** Query it with small python one-liners.
- **Ask permission before** editing the rulebook, running `effortless build`, or building on a dirty git tree. Do not `git add` or `git commit`; leave the tree for the user.
- **Local dev DB is disposable.** `effortless build` drops and recreates it. No hand-written `ALTER TABLE` locally.
- **The admin CMS database is persistent and migration-only.** It lives on bases.effortlessapi.com. A schema change starts as a rulebook edit, then needs an idempotent hand-written `postgres/migrations/NNNN-*.sql` applied with `postgres/apply-migration.sh`. Never run `init-db.sh` against it. Look at `postgres/migrations/0001-initial-schema.sql` for the style.
- **This is not the Next.js you know** (Next 16, React 19). Read the relevant guide in `web/node_modules/next/dist/docs/` before writing routing, metadata or data-fetching code.
- Pages under `web/app/(site)/` use `export const dynamic = "force-dynamic"` through the shared layout, the shared `Header` and `Footer`, and the CSS classes in `web/app/globals.css` (design tokens: Raleway body, Roboto Slab serif, accent `#2fc7f3`). Reuse the existing classes: `band`, `band-alt`, `container`, `hero-col`, `eyebrow`, `h1-inner`, `h2`, `h3`, `accent-rule`, `lede-inner`, `body-text`, `btn`, `btn-arrow`, `principle-list` / `principle-item` / `principle-number`, `stage-list` / `stage-item`, `project-item`. Look at `how-i-work/page.tsx` and `work/page.tsx` for the rhythm of alternating `band` and `band-alt` sections. Add new classes to `globals.css` only where nothing existing fits, using the existing tokens.
- Voice: direct and practical, no jargon, confident but unpretentious. No exclamation marks. No em dashes. Do not add claims, numbers, testimonials or client names that are not in the copy below.

## Shared data model (two pages use it)

Two pages are being added to this site, `/idea-to-evidence` and `/designing-for-people-and-agents`, and they are specified in two separate prompts. They share one generic model so the schemas cannot conflict. **First check whether these tables already exist in the rulebook. If they do, reuse them as they are and only add rows.** If they do not, add them exactly as below.

Follow the rulebook conventions (PascalCase plural table names; first field `<Entity>Id` raw string; a calculated `Name`; FK fields singular with no `Id` suffix; every table and field has a `Description`; no many-to-many).

| Table | Fields (raw unless noted) |
|---|---|
| `LandingPages` | `LandingPageId` (the slug, for example `idea-to-evidence`), `Name` (calculated), `MetaTitle`, `MetaDescription`, `Eyebrow`, `Headline`, `Lede`, `PrimaryCtaLabel`, `PrimaryCtaHref`, `SecondaryCtaLabel` (nullable), `SecondaryCtaHref` (nullable), `IsPublished` (boolean) |
| `LandingPageSections` | `LandingPageSectionId`, `Name` (calculated), `LandingPage` (FK), `SortOrder`, `Kind` (`prose`, `list`, `steps`, `cards`, `callout`), `AnchorId` (nullable; rendered as the section's HTML `id`), `Eyebrow` (nullable), `Heading`, `BodyText` (nullable; paragraphs separated by a blank line) |
| `LandingPageItems` | `LandingPageItemId`, `Name` (calculated), `LandingPageSection` (FK), `SortOrder`, `Label` (nullable), `Heading`, `BodyText` (nullable) |
| `LandingPageItemFacts` | `LandingPageItemFactId`, `Name` (calculated), `LandingPageItem` (FK), `SortOrder`, `Label`, `BodyText` (one fact per line when it is a list) |

Rendering rules:
- Sections render in `SortOrder`, alternating `band` and `band-alt`.
- `prose` renders `BodyText` paragraphs. `list` renders items as a plain list. `steps` renders items as a numbered list (reuse `stage-list`). `cards` renders items as a responsive grid. `callout` renders a single highlighted statement.
- An item's facts render as labeled lines under it. A fact whose `BodyText` has several lines renders as a bulleted list.
- Add a `getLandingPage(slug)` function to `web/lib/content.ts` that returns the page with its sections, items and facts in order, reading only from `vw_*` views. Return `null` when the slug does not exist or `IsPublished` is false, and have the route call `notFound()` in that case.
- Both pages must be reachable only by their direct URL for now. **Do not add them to `NAV_ITEMS` in `Header.tsx`.** Add `robots: { index: true }` metadata normally, but do not add them to any sitemap or footer link until the user says so.
- Admin: the admin CMS only edits tables registered in `web/lib/admin/schema.ts` (see the `how_i_work_sections` / `vw_how_i_work_sections` entry). Register these four there, following that entry, so the user can edit and publish these pages without code.

Schema workflow, in order: (1) edit the rulebook (ask permission), (2) `effortless build`, (3) write one idempotent migration `postgres/migrations/NNNN-landing-pages.sql` (next free number) that creates the four tables and their `vw_*` views with `IF NOT EXISTS` / `CREATE OR REPLACE`, (4) apply it with `postgres/apply-migration.sh`, which asks for confirmation before it touches the bases database, (5) load the rows for the page below into both local and bases databases the same way the existing content rows were loaded (check how `postgres/05-insert-data.sql` and the admin CMS handle seed rows, and use the same route).

## Definition of done (both pages)

- The page renders at its URL, server-rendered, from database rows only. Searching the page component for the copy below finds nothing.
- Looks like the rest of the site: same header, footer, fonts, bands, rhythm. Works at phone width, with no horizontal scroll.
- Title, meta description and Open Graph tags set from the `LandingPages` row.
- Keyboard accessible, one `h1`, headings in order, links have clear text, contrast meets AA.
- `npm run lint` and `npm run build` pass in `web/`.
- You have started the dev server and looked at the page in a browser at desktop and phone widths.
- Report back: what you added, what you could not verify, and any decision you made that the user should confirm.


## Page content

Load this as rows in the shared model. The text is final copy: use it as written.

### Facts that are not decided yet

The series has not been scheduled or approved for funding, so the page must not state dates, times, a registration link, or the price of attendance. Build the page so those can be added later by editing rows, with no code change:

- Set `IsPublished` to `false` when you load the rows. The user will publish it from the admin CMS once Banyan has approved the series and set the first date.
- The primary call to action is a `mailto:` link to ask about dates (below). Do not invent a registration form.

### LandingPages row

- `LandingPageId`: `designing-for-people-and-agents`
- `MetaTitle`: `Designing for People and Agents: Guild Sessions by David Shadle`
- `MetaDescription`: `Five 40-minute Guild Sessions for Banyan operating companies on how AI agents change forms, reports, help, and the service behind the screen. Each one leaves you something to try the following week.`
- `Eyebrow`: `Guild Sessions`
- `Headline`: `Designing for People and Agents`
- `Lede`: `Software was built for a person at a screen. More and more, the user is an agent acting for that person, with no screen at all, and most analytics cannot see it. Five 40-minute Guild Sessions, each on one place the shift shows up in a product.`
- `PrimaryCtaLabel`: `Ask about the next session`
- `PrimaryCtaHref`: `mailto:david@davidshadle.com?subject=Guild%20Sessions%3A%20Designing%20for%20People%20and%20Agents`
- `SecondaryCtaLabel`: `See the five sessions`
- `SecondaryCtaHref`: `#the-five-sessions` (an in-page anchor; the section's `AnchorId` must match)
- `IsPublished`: `false`

### Sections, in order

**1. Section, kind `prose`, eyebrow `The series`, heading `One shift, five places it shows up.`**

BodyText:

Designing for People and Agents is a series of five 40-minute Guild Sessions, held monthly, live and online, presented by David Shadle. Each one covers one place the shift shows up in a product. Every session leaves attendees with something to try the following week.

The sessions build on one another. The series starts with seeing who uses the product, moves through what the product exposes and what its terms mean, and ends with how the service runs and how people interact with it. Each session also stands on its own.

Any role at an OpCo can attend: leadership, product, engineering, design, and customer-facing teams. Technical topics stay at a high level, leaning technical where they apply to the business and the reasons to integrate.

**2. Section, kind `prose`, eyebrow `Why now`, heading `The shift is already in the traffic.`**

BodyText:

Fastly reported in June 2026 that AI traffic grew about 6.5 times faster than human traffic in the first five months of the year. Cloudflare reported in July 2026 that more than half of internet traffic is now non-human. DataDome counted 17.7 billion AI agent requests in a single quarter, up 45 percent on the quarter before.

Some of that traffic collects content and sends nothing back. Some of it is an agent acting for a real customer: checking availability, comparing options, completing a task. Most products were not designed for that customer, and most measurement does not count it. Forms, reports, and help, the patterns that shaped business software, are changing at the same time.

Much of what OpCos need to respond is not new. The principles behind it have been in use for decades. What is new is how much they now matter, and how quickly. The series connects the two.

Add a small source line under this section (a `Sources` fact or a closing paragraph in muted style), linking each to the original where a URL is known: Fastly, "AI Traffic Grew 6.5x Faster Than Human Traffic This Year", June 2026 (`https://www.fastly.com/blog/ai-traffic-grew-6-5x-faster-than-human-traffic-this-year`). Cloudflare, "Content Independence Day, one year on", July 2026 (`https://blog.cloudflare.com/agentic-internet-bot-report`). DataDome, "The AI Traffic Report Q2 2026", July 2026 (`https://datadome.co/threat-research/ai-traffic-report-q2-2026`). Open the links and confirm they resolve before publishing, and tell the user if any do not.

**3. Section, kind `steps`, eyebrow `Inside each session`, heading `Every session has the same shape.`**

BodyText: `Attendees leave knowing what changed, how to see it in their own product, and what to do next.`

Items (Label is the minutes):

1. Label `5 min`, Heading `The shift`. BodyText `What has changed, and the earlier pattern that shows it has happened before.`
2. Label `12 min`, Heading `The pattern`. BodyText `What the pattern is, and what it looks like in a working product.`
3. Label `10 min`, Heading `In your product`. BodyText `A short self-check attendees work through against their own product.`
4. Label `5 min`, Heading `Try this next week`. BodyText `One action a team can take without outside help.`
5. Label `8 min`, Heading `Questions`. BodyText `Questions, and how to take the pattern further.`

**4. Section, kind `cards`, `AnchorId` `the-five-sessions`, eyebrow `The five sessions`, heading `One session a month.`**

BodyText: `After each session, attendees receive a one-page takeaway with the self-check and the action to try.`

Each item has facts in this order: `Participants learn` (a multi-line fact, one bullet per line), `Try it on your own`, `Take it into an engagement`, `Reports against`. Label is `Month N`.

1. Label `Month 1`, Heading `The user you cannot see`. BodyText `Agents now use products directly. Most analytics are built for a browser and cannot count them.`
   - Participants learn:
     - `How agent traffic differs from human traffic, and from crawlers that only collect content.`
     - `How to read server logs as a journey map: retries, dead ends, and paths nobody documented.`
     - `Why task completion is a better measure than page views when the user is an agent.`
     - `How to decide which agents get in, before a vendor default decides it.`
   - Try it on your own: `Pull 30 days of logs. Separate browser traffic, your own clients, and everything else. Rebuild one agent session in order and note where it stopped.`
   - Take it into an engagement: `Agent traffic read-out. The team leaves with an agent journey map, a first definition of a good agent session, and a draft access policy.`
   - Reports against: `Gross and net retention, where agents act for existing customers.`

2. Label `Month 2`, Heading `Every product is a platform`. BodyText `When an agent uses the product, the interface is what lies under the screen: field names, tool descriptions, and error messages.`
   - Participants learn:
     - `How to map every way into the product, including the ones nobody designed.`
     - `Which rules the screens enforced that an agent calling the product never sees.`
     - `What MCP solves, and what it leaves for the product team.`
     - `How to write error messages an agent can recover from.`
   - Try it on your own: `List every way into the product and who owns each. Give an AI assistant one tool description and a real task. Watch where it goes wrong.`
   - Take it into an engagement: `Door map and agent test. The team leaves with an inventory of every way in, with owners, and one core task an agent can complete without a person stepping in.`
   - Reports against: `Time from idea to release.`

3. Label `Month 3`, Heading `One definition, served everywhere`. BodyText `People and agents need the same answer to the same question. Most companies hold several answers.`
   - Participants learn:
     - `Why competitors are agreeing on shared definitions for metrics.`
     - `What context engineering is, and why support tickets and call recordings are now product assets.`
     - `How content written in structured pieces serves every channel and every agent.`
   - Try it on your own: `Ask five leaders to write down, separately, what an active customer is. Compare the answers.`
   - Take it into an engagement: `Define once. The team leaves with agreed definitions, an owner for each, and a plan to structure one knowledge source.`
   - Reports against: `The Value Creation Plan metrics themselves.`

4. Label `Month 4`, Heading `Design the service, not the screen`. BodyText `Steps in a customer's journey now happen where nobody sees them, carried out by software acting for someone.`
   - Participants learn:
     - `How a service blueprint shows what the customer sees and everything behind it.`
     - `Where an agent sits in the blueprint, and what changes when it acts unattended.`
     - `How a demo works as a storyboard: one picture of the future service for every department.`
   - Try it on your own: `Pick one journey, such as onboarding or renewal. Mark each step where an agent acts or could act, and whether the customer can see it.`
   - Take it into an engagement: `Blueprint with agents. The team leaves with a current and future blueprint, a demo of the future service, and a candidate opportunity.`
   - Reports against: `Gross and net retention.`

5. Label `Month 5`, Heading `Beyond the form`. BodyText `Forms, reports, and help shaped business software. AI is turning them into intent, answers, and action.`
   - Participants learn:
     - `Where a form can accept what a person means, in place of what a field requires.`
     - `When software should decide, when it should ask, and how it shows what it assumed.`
     - `How work changes when people supervise agents in place of doing the task.`
   - Try it on your own: `Pick one form. At each field, decide whether the software should ask, decide, or act.`
   - Take it into an engagement: `Paradigm ideation. The team leaves with a demo of a new way of working and a plan for a prototype to test with customers.`
   - Reports against: `Upsell, good-better-best packaging, and net retention.`

**5. Section, kind `cards`, eyebrow `After the session`, heading `Two ways to use what you learn.`**

Items, each with two facts `What it involves` and `What you have at the end`:

1. Heading `On your own`. What it involves: `The self-check during the session and the action in the takeaway. No outside help and no cost.` What you have at the end: `A first view of the pattern in your own product, and a decision on whether to go further.`
2. Heading `In an engagement`. What it involves: `A free Discovery conversation, then the Idea to Evidence Assessment, targeted at the pattern. The working session for that pattern runs inside the Assessment.` What you have at the end: `A demo that aligns leadership on the idea, and, if you continue, a prototype tested with your own customers and a Value Review at 90 and 180 days.`

Add one link under this section to `/idea-to-evidence` with the text `How an Idea to Evidence engagement works`. Link only when that page is published; guard the link on `getLandingPage("idea-to-evidence")` returning a row.

**6. Section, kind `prose`, eyebrow `Who presents`, heading `David Shadle.`**

BodyText:

Content for every session is written and presented by David Shadle, who has spent twenty years leading product, design, and engineering teams. Examples drawn from the portfolio are named only with the OpCo's agreement. The series informs. It does not assess any OpCo, roadmap, or team.

**7. Section, kind `callout`, eyebrow `Next session`, heading `Ask about the next session.`**

BodyText: `Dates will be announced to Banyan operating companies. To be told first, or to ask about bringing a pattern into your own product, email david@davidshadle.com.`

The callout's button is the primary CTA from the `LandingPages` row.

## Things deliberately left out

- **Dates, times, registration, cost of attendance.** Not yet decided. They are added later as rows.
- **The commercial arrangement with Banyan** (who funds the series, fees per session). Not for a public page.
- **Later session topics and the precedent timeline** from the proposal's appendices. Candidates for a later version.

## Open items to raise with the user in your report

- The series is a proposal until Banyan approves and funds it. The page is loaded with `IsPublished` false for that reason. Say clearly how the user publishes it.
- Whether to add a registration mechanism once a first date exists (form, calendar invite, or an external webinar tool).
- Whether a dedicated page per session is wanted later. The data model supports it, but this version is one page.
- The statistics in "Why now" are quoted from the sources the user lists. Report any source link that does not resolve or does not say what the copy says.
