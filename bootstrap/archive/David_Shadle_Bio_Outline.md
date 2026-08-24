# David Shadle — Bio Source Outline
*Assembled from ~40 Cowork working sessions, June–August 2026. Evidence-based; confidence flags noted.*

---

## 1. Role and positioning

- **Technical Advisor, Banyan Software.** Part of a three-person program team — David Shadle, Jeff Broberg, Ryan Perkowski — that he leads in practice and presents as peers (he directed that all three carry the same title and appear in every From: line and signature block).
- Operates at **portfolio scale**: ~107–111 Operating Companies, 65 cloud-enrolled, 131 companies in the TDD deal pipeline, across eight operating groups (Ascend, Echelon, UK/EU, ANZ, Harbor, Prospera, Mercury, DACH).
- Primary executive stakeholder: **Debra Danielson, Technical Operating Partner**. Also works directly with the CFO, Corp Dev, Banyan IT, and OpCo CEOs/GMs.
- Spans five domains most people would split across five roles: **product management enablement, AI engineering, data platform architecture, portfolio operations reporting, and technology due diligence.**

---

## 2. AI engineering — the rulebook-driven build system *(the through-line)*

This is the technical spine of everything else. Positioning line: *he builds the machine that builds the sites, not just the sites.*

- **The core idea:** a single **rulebook** — one authoritative JSON declaration of a domain — from which the database, API, views, documentation, conformance tests, and (increasingly) the UI are **derived rather than hand-maintained**. His stated principle: *"Consistency comes from derivation rather than discipline."*
- **What the rulebook declares:** tables and their **grain** ("most modeling errors are grain errors"), identity and row-matching behavior, fields and the rules governing each, relationships and cardinality, aggregations, calculated fields, method rules (how a metric may legitimately be compared), deliberately-resolved ambiguities, confidence/uncertainty, permissions, and a change process.
- **Dual purpose, and the second half is the differentiator:** the rulebook is simultaneously a machine-readable schema *and* a plain-language document the business owner can read and sign off on. His test: *"the requester reads it and confirms the definitions and rules match what they meant. If they can't, the model is wrong or the naming is."*
- **The load-bearing rule:** *"The interface performs no business calculation. A chart that computes its own version of a metric is a defect."* Every displayed number binds to a declared field; the app reads assembled `vw_*` views and never joins.
- **The toolchain (EffortlessAPI / SSoTme ERB):** `effortless build` runs versioned transpilers — `airtable-to-rulebook`, `rulebook-to-postgres`, `rulebook-to-rulespeak`, `rulebook-to-explainer`, `minimize-rulebook` — emitting numbered, never-hand-edited SQL (tables, functions, views, RLS policies, seed data) with a sanctioned `0Xb-customize-*` overlay pattern for escapes. Tests are generated too: *"If the rulebook mirrors the code, the tests pass by construction."*
- **Concept-to-delivery pipeline he designed (six stages, S1–S6):** Problem Brief (forbidden from naming a solution) → Experience Design → Rulebook → Scope & Spec (every component bound to a named rulebook field) → Build → Validate & Handoff. Each stage has testable exit criteria and a named approver. *"A stage is done when its artifact exists and its exit criteria are met — not when the conversation feels finished."*
- **Prototype-as-spec:** he builds self-contained, brand-accurate HTML click-throughs in Cowork as the alignment device *before* build commitment — with RBAC demo toolbars, unauthenticated preview modes, and live-data hooks. *"It's faster to argue with a wrong sketch than a blank page."* He is explicit that these are *"design inspiration for developers, not production code."*
- **End state:** *"every future dashboard or widget is a data PR. No code change, no deploy, no engineering ticket"* — and the framework itself becomes a plugin that leads the process.
- **Full-stack fluency, hands-on:** Next.js 16 (App Router), Express/Node ESM, Prisma 7, PostgreSQL 16, Terraform, Docker Compose, GitHub Actions with OIDC (no long-lived credentials), AWS ECS Fargate / ECR / ALB / RDS / S3 / CloudFront / Route53, Auth0-via-corporate-Okta and Magic Link + HS256 JWT sessions, three-tier dev→staging→prod with a schema-fingerprint drift check and a green-gate test suite that must pass before merge.
- **Serious engineering judgment, not just enthusiasm:** he removed an MCP server that had been pointed at production RDS and gitignored the config so it could never be recommitted; he flagged an RLS-enabled-but-zero-policies SOC2 gap to IT; he built staging guardrails that refuse any URL whose database name doesn't end in `_staging`.
- **Applies the philosophy recursively:** his own Claude skill suite is rulebook-generated — `SKILL.md` files are regenerated artifacts, not hand-edited. And skills are earned, not speculated: *"a candidate becomes a skill when the same interaction has been performed at least twice."*
- **Commercial dimension:** leading the vendor licensing conversation with EffortlessAPI, framed sharply — the rulebook JSON is open source, so *"the licensing conversation is really about what we get above it: the transpilers and the pipeline improvements."* He logged vendor-concentration risk and named the fallback rather than assuming portability.

---

## 3. Dashboards — designed, built, and operated across the portfolio

A portfolio of executive-grade reporting surfaces, most of which he specified, prototyped, and shipped himself or with Jeff.

- **AI PM Workshop dashboards** (`dashboards.banyansoftware.cloud`) — three products for three audiences: **Executive**, **Workshop (Operating Partner / Operating Lead)**, and **Pulse / Participant**. Track maturity assessment, roadmap status, and workshop participation per OpCo. These became the house pattern everything else is built against. He wrote the voice-over script and produced the branded launch video.
- **Portfolio Operations Dashboard** — CFO-facing, five tabs including Commitment Achievement. Scoped directly from CFO feedback (click-throughs, sum totals, cumulative YTD, resolving a $286k/mo vs $3.4M reporting conflict). He is leading its migration off a Python generator onto a proper Next.js 16 / Prisma 7 / Postgres app with a real staging tier — and authored the execution plan, the draft schema, and the handoff brief for Jeff.
- **Cloud / FinOps Dashboard** — portfolio-wide cloud spend. Commitment Achievement tab (AWS PPA and Azure MACC terms, pace-to-commit vs. expected drawdown, renegotiation-opportunity and under-commit-risk zones, YTD savings bank with per-month OpCo drilldown) plus a Review & Audit tab he scoped from scratch. His framing of why it exists: *"savings recommendations have a shelf life; without regular reviews, buying discipline erodes and realized savings start to decay."* 111 OpCos, 65 cloud-enrolled, 19 current reviews, 26 aging, 29 overdue or never.
- **Technology Due Diligence (TDD) Command Center** — for the M&A diligence function, 131 companies. He wrote a 34-page creative brief deliberately framed as a *problem* document — *"no screens, no architecture, no charts"* — and in the process found that staging and production were serving two entirely different dashboards, that the data source was never committed so builds weren't reproducible, and that the aging clock field was referenced zero times.
- **Time management / hours reporting** — timesheet hours extract feeding the TDD surface; the v1 hours dashboard that was silently running in production is part of the same estate.
- **Dashboard Framework** (the meta-project) — commissioned by Debra as a reusable way to stand up new dashboards. He reframed the pitch around timing (*"more dashboards are arriving, and a framework built alongside a real dashboard encodes what worked rather than what someone guessed"*), chose the TDD Command Center as the pilot **because it's a hard test**, and insisted the framework be **additive to Banyan IT's existing CI/CD** rather than a competing path.

---

## 4. The AI PM Workshop — from training program to execution engagement

- Inherited a year-old, module-based training curriculum (M0–M5, decks, labs, quizzes, custom GPTs) and **redesigned it into an execution engagement.** The thesis, in his words: *"This is not a training program. It is an execution engagement"* — *"you don't take the program and then go build your roadmap. You build your roadmap in the program."*
- **Four Key Deliverables** every OpCo leaves with: a CEO-signed **Articulated Strategy Document** pressure-tested against competitive reality and AI disruption; a **Strategic Product Roadmap** (RICE-scored, capacity-constrained, traceable to customer evidence); a **Customer Roadmap** in customer language, QBR-ready; and an **Initiative Lifecycle / Roadmap Ledger** that traces ground truth → strategy → evidence → opportunity → roadmap.
- **Eight to nine phases**, ~17–22 facilitated hours over 6–8 weeks, with CEO time deliberately capped at 3–4 hours. Two modes — **Fully Facilitated** and **On-Demand** — with equal standing: *"same portal, same tools, same standard. Only the level of facilitator involvement changes."*
- **Architectural choices he personally drove:** killed the module sequence in favor of a **26-concept PM library** surfaced in context at the phase where it's needed; removed hard gates and Operating Partner rubric checkpoints in favor of facilitator-judgment "readiness signals"; combined phases; made the deliverables page the OpCo's single source of truth with last-upload-wins semantics and visible uploader and timestamp.
- His summary line for OpCo leadership: *"This is not a course to complete. It is a working engagement that produces guidance that is practical, defensible, and actionable — built by your PM, owned by your leadership, and ready to use the day the program closes."*

---

## 5. PM Portal — design, development, maintenance

- Conceived, designed, and built **`portal.pm.banyansoftware.cloud`** as the home for the program: phases, key deliverables, document templates, the concept library, the maturity assessment, and Miles Stone — serving OpCo PMs, Operating Partners, Delivery Coordinators, and Program Leads.
- **Rulebook-driven by design.** In his own words: *"the platform will be rulebook driven, have a Postgres DB for content and engagement data that will feed the dashboards."* Content, navigation, and concepts are data, not code — *"the rulebook is HEAD. The build does the rest."* Drift between the portal and the design mockup is *"impossible by construction."*
- Seven-layer architecture he specified end to end: personas → Okta OIDC auth → frontend (course delivery, Miles AI coach, assessment & dashboards) → API → PostgreSQL 16 (15 tables across curriculum, maturity model, and participant data) → content and artifact layer on Google Drive → Docker/Terraform/GitHub Actions/ECR infrastructure.
- **Design and UX ownership, hands-on.** Enforces the Banyan system rigorously (Moss Green #395542, Sky Blue #9BCBEB, Charcoal for text — never pure black; Libre Franklin / Source Sans Pro), and reviews his own prototypes with unsparing specificity: card spacing, sidebar ordering, contrast on green, "make the slide element taller," and calling out logic errors like a panel showing the phase it already sits in.
- **Copy discipline:** *"too much text… brief, friendly, conversational without being verbose,"* then *"make them more concise, it is too much reading — the goal is to get them to jump into the phase activity."* Insists on a **through-line** across pages so users feel momentum: *you have X, now build Y.*
- Caught and corrected a subtle but consequential data-model distinction himself: Banyan-owned read-only content library paths vs. auto-created per-participant Drive folders — and was emphatic that course content must never be copied into a participant's drive.
- **Broader vision:** the **unified OpCo Portal** — *"a single location for OpCos to get resources, support, learning opportunities and engagement."* Approach: *"more assembly than new creation"* — consolidate three existing Banyan sites without losing context, *"presented in an intuitive way that does not overwhelm."* Shipped as V1→V2→V3 prototypes into GitHub.

---

## 6. Agentic tooling — scaling one expert across 100+ OpCos

- Built and maintains a layered AI system so that PM expertise is available on demand at every OpCo. His framing: *"an expert PM coach can't sit inside every operating company, so Miles scales that coaching across the whole portfolio, one-on-one and on demand."*
- **Miles Stone** — a standalone AI product-management coach (v0.23 → v1.2 → v1.9.6) with six skills, persistent learner state, a provenance ledger separating learner work from AI work from cited sources, and a non-negotiable **AI Defensibility Gate** (tier ladder → moat anchor → 18-month replication test → verdict; *"do not soften the verdict into validation"*). Deliberately architected as its own layer: *"Miles is not embedded in the PM OpCo Plugin, it is a standalone plugin that calls into it."*
- **Banyan PM Studio / OpCo PM plugin** — 40+ growing to **53 skills** spanning the full PM lifecycle: strategy, discovery, planning, release, validation, an 11-step market research framework, and a Memory Bank bridge for engineering handoff.
- **Banyan Roadmap Maturity Assessor** — his 7-dimension, 5-level maturity model (now v6.1, at least six iterations deep) with automatic caps and gates: tooling cap, KPI evidence gap, prioritization gate, no-dedicated-PM ceilings, and a rule that Level 4+ requires *operational* AI, *"not intent, not experiment-only."* Conservative by design: *"if evidence is weak, vague, or unverifiable, lean toward the lower score."* Produces a 14-section CEO-ready branded PDF plus a Learning Journey JSON that feeds Miles.
- **Also built:** an exec dashboard skill tracking the OpCo assessment/workshop pipeline, an Innovation Pod multi-cycle Delphi ideation engine, deck curators, brand/voice/design skills, and a market-scan and news-digest pipeline.
- **He ran the portal itself through his own workshop process** — the PM for the platform that teaches PM.

---

## 7. Leadership, stakeholder management, and OpCo engagement

- **Leads the program team** (Shadle, Broberg, Perkowski) — delegates build work with written briefing docs, sets working norms rather than just assigning tasks (proposing a local-preview habit because production has no staging tier), and manages first-contact sequencing deliberately: *"I have not shared any of the content with Jeff yet. My intention is to share progress and open questions."*
- **Gives credit reflexively and structurally.** Insisted the redesign read as a team collaboration, flattened titles so no one read as principal-and-assistants, and went back to add a teammate to the From: line because the signature block wasn't visible enough.
- **Tailors ruthlessly by audience.** Executives get brief, fact-focused, tightly structured material with the open questions visible. OpCo leadership gets value in their own currency — a record *"for your Operating Partner, your board, and your future self."* OpCo PMs get plain, momentum-building copy and a self-serve URL instead of his email address, because at 100+ OpCos he designs himself out of the bottleneck.
- **Convenes and facilitates directly:** PM Office Hours with targeted working tracks (Strategic Alignment, RICE Prioritization, Product Strategy, Monetization, Data-Driven Decisions); 1:1 roadmap maturity interviews with OpCo leads run as a structured, evidence-validated protocol; QBR-ready deliverable support; facilitated multi-week engagements with OpCo CEOs and PMs.
- **Change management without casualties.** Reframed a full program pivot as continuity rather than repudiation — *"the goal hasn't changed; what's changed is how we get there"* — and explicitly directed that the tone *"be complementary of the existing effort and not to poop on it."* Cut hard diagnostic evidence from one proposal because *"leading with it turns a framework proposal into a critique of work Debra is close to."*
- **Cross-functional diplomacy with no positional authority.** To infrastructure peers: *"We want to make sure what we're building plugs into that work, not around it"* — conceding territory before asking for anything.
- **Invites correction and treats it as the point:** *"If step 2 tells me the problem statement is materially wrong, that's the brief working, not failing."* / *"Your markup is the answer key."*
- **Communication craft is codified, not accidental.** He maintains a written voice standard — one-line anchor opening, no throat-clearing, lists for 3+ items, no em-dashes, banned filler ("circling back," "just wanted to," "per my last email"), always closes with a numbered next step and named owners. He cut a 1,120-word draft to 574, then rewrote it again when the *argument* was wrong rather than the prose.
- **Capability-building, not just delivery:** a document "bill of materials" (template + how-to + worked example) for every deliverable; portal gating so PMs finish rather than drift; standards stated concretely enough to be measured against; and portfolio-wide instrumentation so capability change is visible over time, not anecdotal.

---

## 8. Working philosophy — the lines that characterize him

- **Real work over training theater.** Participants *"leave with the work done, not concepts learned."*
- **Defensibility over novelty.** Everything faces the same test: does it survive an 18-month replication test, does it have a moat, is it *"defensible and actionable"*?
- **Model before interface.** Declare it once, derive everything else. *"One-offs are failures."*
- **Discovered, not theorized.** *"Every element of this process must be earned by real dashboard work. If a step wasn't needed to build a real dashboard, it doesn't belong here yet."*
- **Problems before solutions.** *"Designing against an unagreed problem is the most expensive mistake available in this process, and it is the easiest one to make because solutions are more interesting to discuss than problems."*
- **Log the confusion, not just the conclusion.** *"Retroactive logs remember conclusions and forget the confusion, and the confusion is the useful part."*
- **Ship the sketch.** Prototypes and strawmen exist to be knocked down, and open questions belong in the room, not hidden.

---

## Gaps to fill from your own knowledge

Nothing in the working record supports these — supply them yourself rather than letting a draft invent them:

- Tenure, start date at Banyan, and prior career / education
- Whether "Technical Advisor" is the full formal title and whether you formally lead the three-person team or are first among peers
- Named direct reports, if any (evidence shows program leadership and delegation, not people management)
- Any external speaking, publications, or credentials
- Current status of the pilot cohort and how many OpCos have completed the engagement to date
