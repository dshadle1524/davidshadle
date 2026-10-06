# Build prompt: davidshadle.com/idea-to-evidence

**Run this in the `davidshadle-v4` repo.** Written for the Claude Code session that builds the page there.

## Task

Add one promotional landing page at **`/idea-to-evidence`** that introduces the Idea to Evidence service offering to leadership of Banyan Software operating companies (OpCos). The page is the target of the "Visit Website" button on the Banyan vendor portal listing, so a visitor arrives knowing roughly what the service is and needs to decide quickly whether to ask for a conversation. The route segment uses hyphens, matching the site's other routes (`how-i-work`).

Primary action: request a free Discovery conversation. The page should be calm and plain, like the rest of the site. It is not a sales funnel: no countdowns, no pricing table, no stock imagery.

Place the page in `web/app/(site)/idea-to-evidence/page.tsx`.

Static asset: copy `David Shadle - Capability Statement.pdf` (the two-page PDF the user supplies from the `banyan_offerings` project, `docs/` folder) to `web/public/downloads/David-Shadle-Idea-to-Evidence-Capability-Statement.pdf`. If the file is not available, build everything else, leave the secondary button out, and say so in your report.

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

### LandingPages row

- `LandingPageId`: `idea-to-evidence`
- `MetaTitle`: `Idea to Evidence: David Shadle`
- `MetaDescription`: `One product idea, carried to a working prototype your customers have tested, so you decide what to build on evidence. A service for Banyan operating companies.`
- `Eyebrow`: `Idea to Evidence`
- `Headline`: `New interaction concepts, prototyped and tested with your customers.`
- `Lede`: `Idea to Evidence takes one idea for how your product could work and carries it to a working prototype that your customers (or agents) can interact with. You leave with evidence and a decision, not a recommendation.`
- `PrimaryCtaLabel`: `Request a free Discovery conversation`
- `PrimaryCtaHref`: `mailto:david@davidshadle.com?subject=Idea%20to%20Evidence%3A%20Discovery%20conversation`
- `SecondaryCtaLabel`: `Download the capability statement (PDF)`
- `SecondaryCtaHref`: `/downloads/David-Shadle-Idea-to-Evidence-Capability-Statement.pdf`
- `IsPublished`: `true` once the user has reviewed it, otherwise `false`

### Sections, in order

**1. Section, kind `prose`, eyebrow `Why now`, heading `AI can now do part of the work your customers do by hand.`**

BodyText:

AI can act on a customer's behalf, anticipate a need, and complete a task. Forms, reports, help, and transactions can all work differently. That opens new ways for your product to serve customers, and gives them a reason to renew and buy more.

Most leadership teams already have ideas about where to start. What is hard to find is the time to learn which idea is worth building before committing to build it. This engagement is built to find that out, in a few focused sessions, with the building and testing done outside your leadership team's calendar.

**2. Section, kind `cards`, eyebrow `What you get`, heading `Five things you take away.`**

Items (no facts needed; Heading plus BodyText):

1. Heading `A decision on evidence.` BodyText `Your customers use a working prototype before you commit to building it.`
2. Heading `New thinking on how your product works.` BodyText `That includes where AI and agents can do part of the work while your customer stays in control.`
3. Heading `A build-ready handoff.` BodyText `Working code, the full rulebook behind it, and an engineering scope your team can build from without starting over.`
4. Heading `A clear line to value.` BodyText `The metric is named before any paid work begins, a baseline is taken, and results are reported at 90 and 180 days.`
5. Heading `Your team, able to run the next cycle on its own.` BodyText `There is no retainer.`

**3. Section, kind `steps`, eyebrow `How it works`, heading `Six phases. You commit to one at a time.`**

BodyText: `Each paid phase has its own scope, fixed window, and fee, agreed before it begins. You can stop after any phase and keep everything it produced. Discovery is free.`

Items, in order. Each item has two facts: `What happens` and `You receive`.

1. Label `1`, Heading `Discovery (free)`. What happens: `One conversation to confirm fit, name the metric, and agree where to start.` You receive: `An engagement brief.`
2. Label `2`, Heading `Audit`. What happens: `An evidence-based look at your product as customers experience it, from key flows, support tickets, and stakeholder conversations.` You receive: `A tactical report, the named opportunity, and a baseline.`
3. Label `3`, Heading `Assessment`. What happens: `Working sessions with your leadership team to choose one initiative worth testing.` You receive: `A problem statement, the chosen initiative and test criteria, a specification, and the rulebook.`
4. Label `4`, Heading `Prototype and customer testing`. What happens: `The initiative is built and tested with three to five of your customers. You decide to adopt, change, or stop.` You receive: `A test report, a prototype demonstration, and a recorded decision.`
5. Label `5`, Heading `Handoff`. What happens: `Your engineers receive the working prototype, the full rulebook in plain language, and an engineering scope.` You receive: `The repository, the rulebook in plain language, an engineering scope, and a Value Review plan.`
6. Label `6`, Heading `Value Review`. What happens: `Short reviews at 90 and 180 days, compared to the baseline taken in the Audit.` You receive: `Two review reports, shared with your Operating Partner.`

**4. Section, kind `cards`, eyebrow `Ways to engage`, heading `Choose how far to go.`**

BodyText: `The level is chosen in Discovery and can be extended later.`

Items, each with two facts `Includes` and `You take away`:

1. Heading `Understand`. Includes: `Discovery and Audit`. You take away: `An outside, evidence-based view of your product and the opportunity worth pursuing.`
2. Heading `Define`. Includes: `Understand, plus Assessment`. You take away: `One initiative, agreed and specified, ready to test or build.`
3. Heading `Prove`. Includes: `The full engagement`. You take away: `A tested prototype, a decision, a build-ready handoff, and the Value Review.`

**5. Section, kind `list`, eyebrow `Commitments`, heading `Five commitments.`**

Items (Heading only):

1. `The initiative aligns to or extends your own roadmap.`
2. `Every engagement is tied to a Value Creation Plan metric, named in the first conversation.`
3. `The work ends in something built, used by your customers before any decision is made.`
4. `You own every output of each phase you complete.`
5. `Every engagement is time-bound and ends with your team able to run the next cycle.`

**6. Section, kind `prose`, eyebrow `Who it is for`, heading `Operating company leadership.`**

BodyText:

Leadership of a Banyan operating company, usually the CEO or the person who holds product direction, working with the Operating Partner who owns the Value Creation Plan. OpCos arrive by referral from an Operating Partner or Banyan leadership, or after a Guild Session on an interaction pattern. Both routes begin with a free Discovery conversation.

**7. Section, kind `list`, eyebrow `What we ask of you`, heading `What the engagement needs from your side.`**

Items (Heading plus BodyText):

1. Heading `A named owner.` BodyText `Someone who holds the engagement and, after Handoff, the Value Review numbers.`
2. Heading `Leadership time.` BodyText `For Discovery, the Assessment sessions, and the decision session.`
3. Heading `Access and help.` BodyText `The product, the data, and the people who know it best, plus help recruiting three to five customers for testing and engineering time at Handoff.`

**8. Section, kind `prose`, eyebrow `Your data`, heading `Your data stays yours.`**

BodyText:

Your data is used only for your engagement. Testing participants give consent and are not named. Everything produced, including testing records, transfers to you, and the provider keeps no copy. Nothing is shared with another company.

**9. Section, kind `prose`, eyebrow `About`, heading `David Shadle.`**

BodyText:

Twenty years leading product, design, and engineering teams. I work where experience design and product strategy meet, and I build what I design. AI tools do the volume work of research, drafting, and building. My judgment decides what matters.

**10. Section, kind `callout`, eyebrow `To start`, heading `Request a free Discovery conversation.`**

BodyText: `One conversation to confirm fit, name the metric, and agree where to start. Email david@davidshadle.com or call 425.417.2339.`

The callout's button is the page's primary CTA from the `LandingPages` row. The hero shows the primary CTA and, when present, the secondary CTA.

## Things deliberately left out

- **Fees.** The service says "fees on request" and the page carries no pricing. Do not add any.
- **Banyan internal framing** (how the service fits Banyan programs, what is asked of Banyan leadership). It is not for a public page.
- **Skills and tool names** used to run the engagement. They stay with the provider.

## Open items to raise with the user in your report

- The vendor listing and the capability-statement PDF link to `davidshadle.com/idea-to-evidence`. That URL is final, so do not rename it.
- The `mailto:` links are the only contact mechanism. Ask whether a form or a calendar booking link should replace them.
- Whether the page should be indexable by search engines from day one.
