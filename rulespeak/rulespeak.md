# 📘 David Shadle Website v4 — RuleSpeak®

_Rulebook for davidshadle.com v4: bio variants, method statement, proof/work entries, resume content, and site settings. Content and navigation as data, per the PM Portal discipline referenced in David_Shadle_Content_Strategy_v1.md._

> Declarative business rules rendered from the rulebook. Every statement
> below expresses truth in the business domain — it is neither a procedure
> nor an imperative. The rulebook's formulas are the single source of truth;
> this document is their plain-language reading.

## 1 Business Vocabulary

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Site Setting** | Singleton table of site-wide facts: contact info, positioning statement, and the undated 'Currently' block. One row. | — |
| Name | The same as its site setting ID. | _Display alias._ |
| Contact Email | A defined attribute. | _Primary contact email, shown in the Contact section on Home and Work._ |
| Contact Phone | A defined attribute. | _Contact phone number, as it appears on the resume header._ |
| Site Domain | A defined attribute. | _Canonical site domain._ |
| Portfolio Company Count | A defined attribute. | _Standardized portfolio count string, per Content Strategy Section 6 ('100+' everywhere, never 107 or 111)._ |
| Self Description Line | A defined attribute. | _The 'full stack product practitioner' anchor phrase. Per Section 2: say it once, never next to a list._ |
| Positioning Statement | A defined attribute. | _The core positioning paragraph everything else derives from (Content Strategy Section 2)._ |
| Hero Headline | A defined attribute. | _The large opening line of the Home hero, first person. First sentence of PositioningStatement, curated separately so the hero can style it distinctly from HeroSubheadline._ |
| Hero Subheadline | A defined attribute. | _The medium-sized second line of the Home hero, directly under HeroHeadline. Second/third sentence of PositioningStatement._ |
| Banyan Title | A defined attribute. | _Full Banyan title, used everywhere per Section 6: 'Technical Advisor, Product Strategy and UX'._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Contact Email | Contact Phone | Site Domain | Portfolio Company Count | Self Description Line | Positioning Statement | Hero Headline | Hero Subheadline | Banyan Title |
|---|---|---|---|---|---|---|---|---|---|
| default | david@davidshadle.com | 425.417.2339 | davidshadle.com | 100+ | A full stack product practitioner. Not just capable of wearing several hats at once, but confident delivering the outcome in each one. | I build the systems that turn strategy into working software. Most advisors stop at the recommendation. I keep going, through the model, the interface, and the handoff, so the thing that gets agreed on is the thing that gets shipped. I work from a rulebook: the rules of a domain written down once in plain language, with the technical pieces derived from that rather than maintained by hand. It is a discipline, not a product. It is what lets me carry a project through delivery instead of stopping at design and project management. | I build the systems that turn strategy into working software. | Most advisors stop at the recommendation. I keep going, through the model, the interface, and the handoff, so the thing that gets agreed on is the thing that gets shipped. | Technical Advisor, Product Strategy and UX |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Currently Item** | A currently item is identified by its name. | — |
| Name | The same as its title. | _Display alias._ |
| Title | A defined attribute. | _The bullet's title/name, e.g. 'Banyan Software' or 'Lookout Together'._ |
| Body Text | A defined attribute. | _The bullet's description text, under the title._ |
| Sort Order | A defined attribute. | _Display order._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Title | Body Text | Sort Order |
|---|---|---|---|
| Banyan Software | Banyan Software | Advising on product strategy and UX. Built a self-managed portal providing product management concepts/ frameworks with a focus on delivering strategic articulation, roadmaps and initiative audits to their portfolio of 100+ B2B SaaS operating companies. Delivered contextual executive dashboards to track workshop engagement, cloud spend and technical due diligence deal tracking. | 1 |
| Lookout Together | Lookout Together | A family scam-resilience service I conceived, designed and built on my own. Older adults get current, practical knowledge about how scams actually work and how to proactively protect themselves. Their adult children get a way to help without taking over. No monitoring, no account access, no one acting on anyone's behalf. Strategy, experience design and build, all one person. | 2 |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Bio Variant** | A bio variant is identified by its name. | — |
| Name | The same as its label. | _Display alias._ |
| Label | A defined attribute. | _Human label for this bio length/context, e.g. 'Fifty words'._ |
| Usage Context | A defined attribute. | _Where this variant gets used, e.g. 'Directory listings, conference programs, deck footers, introductions.'_ |
| Body Text | A defined attribute. | _The bio copy itself. Paragraph breaks encoded as \n\n._ |
| Sort Order | A defined attribute. | _Display order, shortest to longest._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Label | Usage Context | Body Text | Sort Order |
|---|---|---|---|---|
| One line | One line | Email signature, byline, Slack profile. | Technical Advisor, Product Strategy and UX at Banyan Software. I build the systems that turn strategy into working software. | 1 |
| One line (alternate) | One line (alternate) | Where Banyan is not the point. | Product strategy, design, and the systems that ship them. Full stack product practitioner. | 2 |
| Fifty words | Fifty words | Directory listings, conference programs, deck footers, introductions. | David Shadle builds the systems that turn strategy into working software. He is Technical Advisor, Product Strategy and UX at Banyan Software, working across a portfolio of more than 100 B2B SaaS operating companies, where he designed and built the product management platform the program runs on. | 3 |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **How I Work Section** | A how i work section is identified by its name. | — |
| Name | The same as its heading. | _Display alias._ |
| Heading | A defined attribute. | _Section heading as it appears on the page._ |
| Body Text | A defined attribute. | _Full-page body copy for this section. Paragraph breaks encoded as \n\n._ |
| Short Body Text | A defined attribute. | _Condensed ~1-paragraph version, used if How I Work becomes a Home section instead of its own page. Null where the short version drops the section entirely._ |
| Sort Order | A defined attribute. | _Display order on the page._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Heading | Body Text | Short Body Text | Sort Order |
|---|---|---|---|---|
| The problem comes first, and it gets its own document | The problem comes first, and it gets its own document | Designing against a problem nobody agreed on is the most expensive mistake available. It is also the easiest one to make, because solutions are more interesting to discuss than problems.<br><br>So every engagement starts with a brief that contains no screens, no architecture, and no charts. Only the problem, who has it, what it costs, and how we would know it was solved. It gets reviewed by the people who live with the problem before anything else begins.<br><br>Doing this properly means real analysis, and the analysis tends to turn things up. On one engagement it surfaced that staging and production were serving two different dashboards. That was a byproduct, not the goal. The goal was an executive team aligned on the problem, which is what makes the scoping and the specification that follow worth doing. | Every engagement starts with a brief containing no screens, no architecture, and no charts. Designing against a problem nobody agreed on is the most expensive mistake available. | 1 |
| The model gets written down once | The model gets written down once | Most drift starts small. A chart computes its own version of a metric. The documentation describes last quarter's schema. Two teams use the same word for different things. Nobody decides to let a system fall out of sync. It happens between decisions.<br><br>So I work from a rulebook. The rules of a domain get written down once, in plain language the person who owns the business meaning can read, and the technical pieces are derived from that rather than maintained by hand. Consistency comes from derivation rather than discipline.<br><br>What matters here is not the method but what it changed. My responsibility used to end at design and project management, with development handed to someone else. Working this way, I can carry a project from concept through delivery. | I work from a rulebook. The rules of a domain get written down in plain language, and the technical pieces are derived from that rather than maintained by hand. Consistency comes from derivation rather than discipline. It is what lets me carry a project through delivery rather than stopping at design. | 2 |
| The interface performs no business calculation | The interface performs no business calculation | Every number on screen traces back to a declared field. A chart that computes its own version of a metric is a defect, not a shortcut.<br><br>This sounds like an engineering rule. It is really a trust rule. The moment two surfaces can disagree about the same number, every surface becomes a thing to verify rather than a thing to use. | Every number traces back to a declared field. A chart that computes its own version of a metric is a defect. | 3 |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Proof Point** | A proof point is identified by its name. | — |
| Name | The same as its title. | _Display alias._ |
| Title | A defined attribute. | _Short title for this proof point._ |
| Problem Text | A defined attribute. | _The problem, as stated in the proof inventory._ |
| Action Text | A defined attribute. | _The action taken._ |
| Outcome Text | A defined attribute. | _The outcome._ |
| Attribution Note | A defined attribute. | _Precise attribution language required when describing this work (e.g. 'advised on and implemented,' not 'owned'). See Content Strategy Section 6._ |
| Register Note | A defined attribute. | _Internal guidance on tone/register for this proof point. Not published copy - for whoever writes site/resume text from this row._ |
| Client or Category | A defined attribute. | _Client name where nameable, otherwise a category label (e.g. 'Medical technology'). Shown as the first half of the Projects page meta row._ |
| Status Label | A defined attribute. | _Short status/type word for the Projects page meta row (e.g. 'Live in production', 'Problem brief')._ |
| Featured on Work Page | True when an empty string. | _Whether this proof point is one of the 2-3 engagements shown on the Work page (Section 10). First-pass selection - confirm with David before Phase 2._ |
| Featured in Resume Selected Work | True when an empty string. | _Whether this proof point appears in the resume's 'Selected work, 2024 to 2026' block (Variant A)._ |
| Image URL | A defined attribute. | _Public URL of this project's single representative image (hosted in Cloudflare R2). Optional — shown on the Work page when set._ |
| Sort Order | A defined attribute. | _Order matching Content Strategy Section 4 numbering._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Title | Problem Text | Action Text | Outcome Text | Attribution Note | Register Note | Client or Category | Status Label | Featured on Work Page | Featured in Resume Selected Work | Image URL | Sort Order |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| The rulebook approach (the through line) | The rulebook approach (the through line) | Most drift starts small. A chart computes its own version of a metric. The documentation describes last quarter's schema. Two teams use the same word for different things. Nobody decides to let a system fall out of sync, it happens between decisions. | Works from a rulebook. The rules of a domain get written down once, in plain language the person who owns the business meaning can read, and the technical pieces are derived from that rather than maintained by hand. | It made him materially more productive. Previously the responsibility ended at design and project management, with development handed to someone else. Working this way, a project can be carried from concept through delivery by one person. That is the claim. Not that the method is novel. | His working method, not his invention. Described, never sold. | Describe, do not sell. Two or three sentences max, never a section. Never name transpilers, toolchains, or vendors. Safe line, use sparingly and never more than once per document: 'Consistency comes from derivation rather than discipline.' | — | — | false | false | — | 1 |
| Product management platform, concept through production | Product management platform, concept through production | A program serving more than 100 operating companies had no home. Content, coaching, assessment, and deliverables were scattered. | Designed and built the platform end to end: personas and access model, corporate SSO, frontend, API, PostgreSQL, content and artifact layer, and containerized infrastructure with automated deployment. Content and navigation are data rather than code, so the product and its specification cannot drift apart. | Live in production, serving PMs, operating partners, delivery coordinators, and program leads. | Sole responsibility, concept through production. Language to use: 'Designed and built end to end.' | The single strongest artifact in the record. Sole responsibility, concept to production. | Banyan Software | Live in production | true | true | — | 2 |
| Training curriculum rebuilt as an execution engagement | Training curriculum rebuilt as an execution engagement | Inherited a module based program. Companies completed a course and went back to work unchanged. | Co-led the redesign with the program team: replaced the module sequence with a concept library surfaced at the point of need, removed hard gates in favor of facilitator judgment, capped CEO time at three to four hours. | Companies now finish with four artifacts they own, including a CEO signed strategy, a prioritized and capacity validated roadmap, a customer facing roadmap, and a ledger tracing every decision back to evidence. | Co-led with the program team. Language to use: 'Co-led the redesign.' | Line worth keeping: 'You don't take the program and then go build your roadmap. You build your roadmap in the program.' | Banyan Software | Program redesign | false | true | — | 3 |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Job Entry** | A job entry is identified by its name. | — |
| Name | Computed as the company, followed by “ - ”, followed by the job title. | _Display alias._ |
| Company | A defined attribute. | _Employer or entity name._ |
| Job Title | A defined attribute. | _Title held. Null on the single synthetic 'earlier roles' compressed row._ |
| Start Date | A defined attribute. | _Start, YYYY-MM._ |
| End Date | A defined attribute. | _End, YYYY-MM. Null if current._ |
| Is Current | True when an empty string. | _True if this role is ongoing._ |
| Display Group Key | A defined attribute. | _Rows sharing this key render as one entry in Variant A (which uses the coarser grouping). Null where no grouping applies._ |
| Summary Text Variant a | A defined attribute. | _Prose summary as it appears in Resume Variant A. On a grouped pair, only the earliest row in the group carries the merged text; the later row is null and the app renders the group using the earliest row's text with the group's full date range._ |
| Summary Text Variant B | A defined attribute. | _Bullet-point summary as it appears in Resume Variant B, bullets joined with \n._ |
| Compressed Line | A defined attribute. | _One-line compressed text, used only on the synthetic 'earlier roles' row for Variant A's single-line pre-2019 summary._ |
| Include in Variant a | True when an empty string. | _Whether this row is shown (individually or as part of a group) on Resume Variant A._ |
| Include in Variant B | True when an empty string. | _Whether this row is shown on Resume Variant B._ |
| Is Pre2019 | True when an empty string. | _True for roles before 2019, compressed in Variant A per Content Strategy Section 7._ |
| Sort Order | A defined attribute. | _Reverse chronological display order._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Company | Job Title | Start Date | End Date | Is Current | Display Group Key | Summary Text Variant a | Summary Text Variant B | Compressed Line | Include in Variant a | Include in Variant B | Is Pre2019 | Sort Order |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Banyan Software - Technical Advisor, Product Strategy and UX | Banyan Software | Technical Advisor, Product Strategy and UX | 2026-02 | — | true | banyan | Portfolio of 100+ B2B SaaS operating companies. Supports operating company teams, product management, and technology due diligence. Platform, reporting products, and workshop work described above. | Designed and built the product management platform serving the portfolio, concept through production: access model, frontend, API, PostgreSQL, content layer, and deployed infrastructure.<br>Advised on and implemented the experience layer across three executive reporting products: PM Workshop covering operating company maturity, participation and performance; Portfolio Operations covering cloud spend, escrow and compliance; and Technical Due Diligence covering deal management, time tracking and assignment.<br>Rebuilt the Portfolio Operations dashboard onto a database backed foundation, replacing generated exports with live data and improving performance.<br>Co-led the redesign of the AI PM Workshop from training curriculum to execution engagement, with four owned artifacts as the outcome.<br>Wrote the project brief for the diligence reporting rebuild, aligning the executive team on the problem before scoping. The supporting analysis surfaced a process breakdown where staging and production served two different dashboards. | — | true | true | false | 1 |
| m+d2 & Associates - Partner, Strategic Product Advisor and Designer | m+d2 & Associates | Partner, Strategic Product Advisor and Designer | 2025-10 | — | true | m-plus-d2 | Founded to take on a medical technology commercialization engagement. Led a pivot from a multi state Series A to a focused single state validation program, shifted the narrative from detection to prevention, and built the seed investor materials for two distinct audiences. | Led a medical technology client through a pivot from multi state Series A to focused single state validation.<br>Repositioned the narrative from detection to prevention and built seed investor materials for two distinct audiences.<br>Used a purpose built domain expert agent to research pilot program design, distribution opportunity, and insurance carrier risk, feeding the strategy the team aligned on before execution. | — | true | true | false | 2 |
| Vortent Partners - Co-founder, Strategic Product Advisor and Designer | Vortent Partners | Co-founder, Strategic Product Advisor and Designer | 2025-06 | — | true | vortent | Execution partners for late seed and Series A founders in life sciences, deep tech, and cleantech. For an AI driven materials discovery company, translated lab technology into a customer facing platform through facilitation and interactive prototyping, defining an agent interface and dashboard for a multi stage MVP. | Translated an AI driven materials discovery company's lab technology into a customer facing platform.<br>Facilitated cross functional sessions distilling complex scientific workflows into actionable product requirements.<br>Delivered strategy documentation, design concepts, and interactive prototypes guiding a multi stage MVP. | — | true | true | false | 3 |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Resume Variant** | A resume variant is identified by its name. | — |
| Name | The same as its label. | _Display alias._ |
| Label | A defined attribute. | _Variant label._ |
| Audience Description | A defined attribute. | _Who this variant targets and how it is distributed._ |
| Summary Text | A defined attribute. | _The opening capability statement ('What I do' / 'Summary'). Paragraph breaks encoded as \n\n._ |
| Published on Site | True when an empty string. | _Whether this variant is served from the public site (Section 10: only Variant A)._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Label | Audience Description | Summary Text | Published on Site |
|---|---|---|---|---|
| Variant A — Consulting and Advisory | Variant A — Consulting and Advisory | Public. Linked from davidshadle.com, offered as a PDF download. Target length: two pages. | I build the systems that turn strategy into working software. Most advisors stop at the recommendation. I keep going, through the model, the interface, and the handoff, so the thing that gets agreed on is the thing that gets shipped.<br><br>I start with the problem and write it down before anyone proposes a solution. From there I work from a rulebook: the rules of a domain written down once in plain language, with the technical pieces derived from that rather than maintained by hand. It is what lets me deliver complete projects rather than stopping at design and project management.<br><br>Twenty five years in product strategy and design make the systems worth building. Full stack product practitioner. Not just capable of wearing several hats at once, but confident delivering the outcome in each. | true |
| Variant B — Principal and Director Roles | Variant B — Principal and Director Roles | Sent directly for specific roles. Never published online. Conventional reverse-chronological structure for applicant tracking systems and hiring managers. | Product strategy and design leader with twenty five years across enterprise platforms, cloud infrastructure, and early stage companies, including principal roles at Microsoft and Oracle. I define what to build and why, align the people who have to agree, and stay with the work through delivery.<br><br>I also build. Over the last two years I have designed and shipped a production platform end to end and implemented the experience layer across three executive reporting products. Working from a written rulebook rather than hand-maintained specs is what extended me from design and project management into complete delivery. That range means no handoff gap between strategy, design, and engineering.<br><br>Looking for defined ownership at a small to mid sized organization. | false |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Resume List Item** | A resume list item is identified by its name. | — |
| Name | The same as its label. | _Display alias._ |
| Category | A defined attribute. | _'Methods' or 'Technical'._ |
| Label | A defined attribute. | _The item text as it appears on the resume._ |
| Sort Order | A defined attribute. | _Display order within its category._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Category | Label | Sort Order |
|---|---|---|---|
| Problem brief first | Methods | Problem brief first | 1 |
| Rulebook driven delivery | Methods | Rulebook driven delivery | 2 |
| Prototype as spec | Methods | Prototype as spec | 3 |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Education Entry** | An education entry is identified by its name. | — |
| Name | Computed as the institution, followed by “ - ”, followed by the degree. | _Display alias._ |
| Institution | A defined attribute. | _School name._ |
| Degree | A defined attribute. | _Degree earned._ |
| Field of Study | A defined attribute. | _Major/field._ |
| Grad Year | A defined attribute. | _Graduation year._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Institution | Degree | Field of Study | Grad Year |
|---|---|---|---|---|
| University of Oregon - Bachelor of Fine Arts | University of Oregon | Bachelor of Fine Arts | Visual Design | 1994 |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Landing Page** | A landing page is identified by its name. | — |
| Name | The same as its headline. | _Display alias._ |
| Meta Title | A defined attribute. | _Browser title and Open Graph title._ |
| Meta Description | A defined attribute. | _Meta description and Open Graph description._ |
| Eyebrow | A defined attribute. | _Small label above the headline in the hero._ |
| Headline | A defined attribute. | _The page h1._ |
| Lede | A defined attribute. | _Opening paragraph under the headline._ |
| Video URL | A defined attribute. | _Optional YouTube link. When present, the video is shown in the hero between the eyebrow and the headline._ |
| Primary Cta Label | A defined attribute. | _Label of the primary call-to-action button._ |
| Primary Cta Href | A defined attribute. | _Target of the primary call-to-action button (mailto: or path)._ |
| Secondary Cta Label | A defined attribute. | _Label of the optional secondary button._ |
| Secondary Cta Href | A defined attribute. | _Target of the optional secondary button._ |
| Is Published | True when an empty string. | _Whether the page is served. Unpublished pages return 404._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Meta Title | Meta Description | Eyebrow | Headline | Lede | Video URL | Primary Cta Label | Primary Cta Href | Secondary Cta Label | Secondary Cta Href | Is Published |
|---|---|---|---|---|---|---|---|---|---|---|---|
| New interaction concepts, prototyped and tested with your customers. | Idea to Evidence: David Shadle | One product idea, carried to a working prototype your customers have tested, so you decide what to build on evidence. A service for Banyan operating companies. | Idea to Evidence | New interaction concepts, prototyped and tested with your customers. | Idea to Evidence takes one idea for how your product could work and carries it to a working prototype that your customers (or agents) can interact with. You leave with evidence and a decision, not a recommendation. | https://www.youtube.com/watch?v=49NfG8CoGJQ | Let's get started | mailto:david@davidshadle.com?subject=Idea%20to%20Evidence%3A%20Discovery%20conversation | Download the capability statement (PDF) | /downloads/David-Shadle-Idea-to-Evidence-Capability-Statement.pdf | false |
| Designing for People and Agents | Designing for People and Agents: Guild Sessions by David Shadle | Five 40-minute Guild Sessions for Banyan operating companies on how AI agents change forms, reports, help, and the service behind the screen. Each one leaves you something to try the following week. | Guild Sessions | Designing for People and Agents | Software was built for a person at a screen. More and more, the user is an agent acting for that person, with no screen at all, and most analytics cannot see it. Five 40-minute Guild Sessions, each on one place the shift shows up in a product. | — | Ask about the next session | mailto:david@davidshadle.com?subject=Guild%20Sessions%3A%20Designing%20for%20People%20and%20Agents | See the five sessions | #the-five-sessions | false |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Landing Page Section** | A landing page section is identified by its name and is related to a landing page. | — |
| Name | The same as its heading. | _Display alias._ |
| Landing Page | A defined attribute. | _The landing page this section belongs to._ |
| Sort Order | A defined attribute. | _Display order within the page._ |
| Kind | A defined attribute. | _Renderer: prose, list, steps, cards or callout._ |
| Anchor ID | A defined attribute. | _Optional HTML id for the section, for in-page links._ |
| Eyebrow | A defined attribute. | _Small label above the section heading._ |
| Heading | A defined attribute. | _Section heading._ |
| Body Text | A defined attribute. | _Section body copy. Paragraph breaks encoded as \n\n._ |
| Link Label | A defined attribute. | _Optional link text shown under the section._ |
| Link Href | A defined attribute. | _Optional link target. A link to another landing page is shown only while that page is published._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Sort Order | Kind | Anchor ID | Eyebrow | Heading | Body Text | Link Label | Link Href |
|---|---|---|---|---|---|---|---|---|
| AI can now do part of the work your customers do by hand. | 1 | prose | — | Why now | AI can now do part of the work your customers do by hand. | AI can act on a customer's behalf, anticipate a need, and complete a task. Forms, reports, help, and transactions can all work differently. That opens new ways for your product to serve customers, and gives them a reason to renew and buy more.<br><br>Most leadership teams already have ideas about where to start. What is hard to find is the time to learn which idea is worth building before committing to build it. This engagement is built to find that out, in a few focused sessions, with the building and testing done outside your leadership team's calendar. | — | — |
| Five things you take away. | 2 | list | — | What you get | Five things you take away. | — | — | — |
| Choose how far to go. | 3 | cards | ways-to-engage | Ways to engage | Choose how far to go. | The level is chosen in Discovery and can be extended later. | — | — |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Landing Page Item** | A landing page item is identified by its name and is related to a landing page section. | — |
| Name | The same as its heading. | _Display alias._ |
| Landing Page Section | A defined attribute. | _The section this item belongs to._ |
| Sort Order | A defined attribute. | _Display order within the section._ |
| Label | A defined attribute. | _Optional short marker, for example a step number._ |
| Heading | A defined attribute. | _Item heading._ |
| Body Text | A defined attribute. | _Item body copy._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Sort Order | Label | Heading | Body Text |
|---|---|---|---|---|
| A decision on evidence. | 1 | — | A decision on evidence. | Your customers use a working prototype before you commit to building it. |
| New thinking on how your product works. | 2 | — | New thinking on how your product works. | That includes where AI and agents can do part of the work while your customer stays in control. |
| A build-ready handoff. | 3 | — | A build-ready handoff. | Working code, the full rulebook behind it, and an engineering scope your team can build from without starting over. |

_ƒ marks a computed column._

</details>

| Term | Description | Narrative Comment |
|------|-------------|-------------------|
| **Landing Page Item Fact** | A landing page item fact is identified by its name and is related to a landing page item. | — |
| Name | The same as its label. | _Display alias._ |
| Landing Page Item | A defined attribute. | _The item this fact belongs to._ |
| Sort Order | A defined attribute. | _Display order within the item._ |
| Label | A defined attribute. | _Fact label, for example What happens._ |
| Body Text | A defined attribute. | _Fact text. One fact per line when it is a list._ |

<details open>
<summary>Example data</summary>

| Name ƒ | Sort Order | Label | Body Text |
|---|---|---|---|
| Includes | 1 | Includes | Discovery and Audit |
| You take away | 2 | You take away | An outside, evidence-based view of your product and the opportunity worth pursuing. |
| Includes | 1 | Includes | Understand, plus Assessment |

_ƒ marks a computed column._

</details>

## 2 Fact Types

- a **landing page section** references exactly one **landing page**
- a **landing page item** references exactly one **landing page section**
- a **landing page item fact** references exactly one **landing page item**

## 3 Operative Rules

_Operative rules state what the business **obliges**, **prohibits**, or
advises (**should**). Structural rules come from required fields and foreign keys;
semantic rules come from the Constraints table, each keyed on a boolean the rulebook
already computes (cross-referenced as DR-N in the Definitional Rules below)._

### Structural Constraints (from the schema)

- A site setting **must** have a contact email; a site domain; a portfolio company count; a self description line; a positioning statement; a hero headline; a hero subheadline; and a banyan title.
- A currently item **must** have a title; a body text; and a sort order.
- A bio variant **must** have a label; an usage context; a body text; and a sort order.
- A how i work section **must** have a heading; a body text; and a sort order.
- A proof point **must** have a title; a problem text; an action text; an outcome text; and a sort order, and record whether it is featured on work page and whether it is featured in resume selected work.
- A job entry **must** have a company; a start date; and a sort order, and record whether it is current; whether it is include in variant a; whether it is include in variant b; and whether it is a pre2019.
- A resume variant **must** have a label; an audience description; and a summary text, and record whether it is published on site.
- A resume list item **must** have a category; a label; and a sort order.
- An education entry **must** have an institution and a degree.
- A landing page **must** have a meta title; a meta description; an eyebrow; a headline; a lede; a primary cta label; and a primary cta href, and record whether it is published.
- A landing page section **must** reference exactly one landing page.
- A landing page section **must** have a sort order; a kind; and a heading.
- A landing page item **must** reference exactly one landing page section.
- A landing page item **must** have a sort order and a heading.
- A landing page item fact **must** reference exactly one landing page item.
- A landing page item fact **must** have a sort order; a label; and a body text.

## 4 Definitional Rules

_All statements express truth in the business domain; they are neither
procedures nor imperatives. "iff" is avoided in favor of "only if" so a
one-directional necessity is not mistaken for an equivalence. A
**⚠︎ mechanical** chip marks a rule whose deterministic wording is faithful
but clunky — a flag for an optional downstream reword pass, not a defect._

| ID | Declarative rule |
|----|------------------|
| **DR-1 Name** | A site setting's name is the same as its site setting ID. |
| **DR-2 Name** | A currently item's name is the same as its title. |
| **DR-3 Name** | A bio variant's name is the same as its label. |
| **DR-4 Name** | A how i work section's name is the same as its heading. |
| **DR-5 Name** | A proof point's name is the same as its title. |
| **DR-6 Name** | A job entry's name is computed as the company, followed by “ - ”, followed by the job title. |
| **DR-7 Name** | A resume variant's name is the same as its label. |
| **DR-8 Name** | A resume list item's name is the same as its label. |
| **DR-9 Name** | An education entry's name is computed as the institution, followed by “ - ”, followed by the degree. |
| **DR-10 Name** | A landing page's name is the same as its headline. |
| **DR-11 Name** | A landing page section's name is the same as its heading. |
| **DR-12 Name** | A landing page item's name is the same as its heading. |
| **DR-13 Name** | A landing page item fact's name is the same as its label. |

## 5 Traceability to Schema

_The expression column is the rule's definition in RuleSpeak® notation —
the same logic the rulebook stores, written for a business reader._

| Schema element | Kind | Expression |
|----------------|------|------------|
| **SiteSettings.Name** | formula | `SiteSettingId` |
| **CurrentlyItems.Name** | formula | `Title` |
| **BioVariants.Name** | formula | `Label` |
| **HowIWorkSections.Name** | formula | `Heading` |
| **ProofPoints.Name** | formula | `Title` |
| **JobEntries.Name** | formula | `Company & " - " & JobTitle` |
| **ResumeVariants.Name** | formula | `Label` |
| **ResumeListItems.Name** | formula | `Label` |
| **EducationEntries.Name** | formula | `Institution & " - " & Degree` |
| **LandingPages.Name** | formula | `Headline` |
| **LandingPageSections.Name** | formula | `Heading` |
| **LandingPageItems.Name** | formula | `Heading` |
| **LandingPageItemFacts.Name** | formula | `Label` |

---

_This document is rendered in **RuleSpeak®**, the declarative business-rule
notation created by **Ronald G. Ross**, and follows the conventions of
**SBVR** (Semantics of Business Vocabulary and Business Rules). With thanks to
Ronald G. Ross for RuleSpeak® and his foundational work on business rules —
[www.RonRoss.info](https://www.RonRoss.info)._
