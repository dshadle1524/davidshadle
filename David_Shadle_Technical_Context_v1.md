# Technical Context
**David Shadle · Reference, not published**

What each item on the resume's Technical line is, in plain language, and where it was used. This exists so you can speak to the list without hedging. It is a private reference. Nothing here goes on the site.

**How to use it.** Read each entry and sort it into one of three buckets:

- **A. I built with this.** I made decisions in it, wrote or configured it, debugged it when it broke.
- **B. I directed this.** I decided it should be used and reviewed the result, but someone else's hands were on it.
- **C. It was in the stack.** Present in the project, not something I would want to be questioned about.

Anything landing in C comes off the resume. Anything in B stays only if you can say what you decided and why.

---

## The frontend

### Next.js
**What it is.** The framework the PM Portal's user interface is built in. React underneath, plus page routing, server side rendering, and the build pipeline. It is the current default for production React applications.

**Where it shows up.** The PM Portal front end. Phases, deliverables, the concept library, the maturity assessment, the coach entry point.

**A fair claim.** "The portal front end is Next.js. Content and navigation are data rather than hard coded pages, so the structure comes out of the model instead of being maintained by hand."

**Likely follow up.** "App Router or Pages Router?" You want to know which, because the answer dates the work and signals whether you were hands on.

---

### Node and Express
**What it is.** The API layer. Express is a small server framework running on Node. It sits between the browser and the database and answers requests.

**Where it shows up.** The portal's API. The layer the front end calls to read curriculum content, participant state, and assessment data.

**A fair claim.** "The API is Node and Express. It reads assembled views rather than composing joins in the application, which keeps the business logic in the database where it can be governed."

**Why that detail matters.** It connects directly to your no-calculation-in-the-interface rule. Same principle, one layer down.

---

## The data layer

### PostgreSQL
**What it is.** The database. The system of record.

**Where it shows up.** The portal, roughly fifteen tables spanning curriculum, the maturity model, and participant data. Also the Portfolio Operations rebuild, which moved that dashboard off generated exports onto a live database.

**A fair claim.** "Postgres for both the portal and the Portfolio Operations rebuild. The schema is derived from the rulebook rather than hand maintained, which is what keeps the running product and its specification from drifting apart."

**This is the strongest item on the list.** It is where your method and your build meet, and it is the one you should be most comfortable talking about.

---

### Prisma
**What it is.** The layer between application code and Postgres. You define the shape of your data once, and Prisma generates typed database queries plus the migration files that move a schema from one version to the next.

**Where it shows up.** The portal's data access, and schema migrations across environments.

**A fair claim.** "Prisma sits between the API and Postgres. Because the schema is generated rather than written twice, the code and the database cannot disagree about the shape of the data."

**Note.** Prisma is conceptually close to the rulebook idea. Both are about declaring once and deriving. That is a useful bridge if someone asks how the method shows up in the actual stack.

---

## Infrastructure

### Docker
**What it is.** Packaging. The application and everything it needs to run are bundled into a container, so it behaves the same on your laptop, in staging, and in production.

**A fair claim.** "Everything runs in containers, so the environments are the same rather than similar."

**Why it matters to your story.** "Works on my machine" is a category of failure this removes. That is an easy thing to explain to a non-technical listener.

---

### Terraform
**What it is.** Infrastructure written as files instead of clicked together in a web console. Servers, networks, databases, and permissions are all described in code, version controlled, and applied repeatably.

**A fair claim.** "The infrastructure is described in Terraform, so an environment can be rebuilt from the definition rather than remembered."

**The honest framing if you were not hands on here.** "I set the requirement that environments be reproducible from code. Terraform is how that was done." That is a real and defensible position for an advisor.

---

### GitHub Actions
**What it is.** Automation that runs when code changes. Typically: run the tests, build the container, deploy it if everything passes.

**Where it shows up.** The deployment pipeline across three environments, development, staging, and production, with a test suite that has to pass before a merge goes through.

**A fair claim.** "Deployment is automated through GitHub Actions across three tiers. There is a green gate, so nothing reaches production without the suite passing."

---

### AWS: what each piece actually does

| Service | In one sentence | Where it appears |
|---|---|---|
| **ECS Fargate** | Runs containers without you managing any servers underneath | How the portal actually runs |
| **ECR** | The private registry where built container images are stored | Part of the deployment pipeline |
| **RDS** | Managed PostgreSQL, so backups and patching are handled by AWS | The portal's database |
| **S3** | File storage | Artifacts and static assets |
| **CloudFront** | Content delivery network, serves assets fast and close to the user | Front end delivery |
| **ALB** | Load balancer, routes incoming traffic to the running containers | In front of the application |
| **Route 53** | DNS, maps the domain name to the infrastructure | Domain routing |

**A fair claim.** "It runs on AWS. Containers on Fargate behind a load balancer, managed Postgres on RDS, assets through S3 and CloudFront."

**If pressed on depth.** "I made the architecture decisions and I can navigate it. I would not call myself an infrastructure engineer." That answer costs you nothing and protects everything else on the page.

---

### OIDC authentication
**What it is.** OpenID Connect, the standard behind "sign in with" flows. It lets an application delegate identity to a provider rather than storing passwords itself.

**Where it shows up.** Two paths. Corporate single sign on through Auth0 backed by Okta for internal users. Magic link with signed session tokens for participants who are outside the corporate directory.

**A fair claim.** "Two authentication paths. Corporate single sign on for internal users, magic link for operating company participants who are not in the corporate directory."

**Why this is worth keeping.** It is a design decision, not just a technology choice. You had two populations with different access realities and you solved for both. That is the kind of thing that reads as product judgment rather than resume padding.

---

### EffortlessAPI
**What it is.** The toolchain you use to build and manage rulebooks. The rulebook is a single declaration of a domain, and EffortlessAPI runs the transpilers that turn that declaration into the database schema, the API, the views, the documentation, and the conformance tests.

**Where it shows up.** The PM Portal and the rulebook driven work generally. It is the mechanism behind "derived rather than maintained by hand."

**A fair claim.** "I use EffortlessAPI to build and manage the rulebooks. The rulebook is the source, and the database, API, and tests are generated from it rather than written separately."

**Likely follow up, and it is a good one.** "What is EffortlessAPI?" Most readers will not know it. That is fine and arguably useful, because the answer is the most interesting thing on the line. The short version: it is a toolchain for declaring a domain once and generating the technical layers from that declaration. The rulebook format itself is open source. What the vendor provides above it is the transpilers and the pipeline.

**Keep the answer short.** Two sentences, then move to what it let you deliver. The method stays high level, per the standing rule.

**One thing to be ready for.** A technically sharp reader may ask about vendor dependency. You have a real answer: the rulebook itself is open source, so the exposure is to the tooling above it rather than to the model. That is a considered position, not a gap.

---

### Agent and skill development
**What it is.** Building purpose scoped agents and reusable skills.

**Where it shows up.** Your own practice, and the medical technology engagement.

**A fair claim.** Already covered in the bio and Selected Work. On the technical line it should stay a single phrase.

---

## The part worth leading with

If someone tests this section, the most persuasive material is not the list. It is the judgment.

- **Environment discipline.** Three tiers, development through staging to production, with a check that catches schema drift between them and a test suite that gates merges.
- **Credential hygiene.** Deployment authenticates through OIDC rather than long lived stored keys.
- **A production safety incident, handled.** A tool had been configured to point at the production database. You removed it and made the configuration impossible to recommit.
- **Guardrails you designed.** Staging refuses to run against any database whose name does not mark it as staging.
- **A security gap you escalated.** Row level security was switched on with no policies actually defined, which is a compliance problem. You flagged it to IT rather than routing around it.

**Why this is the better ground.** A list of technology names invites a depth test you may not want. A story about catching a tool pointed at production is a judgment claim, and judgment is what an advisor is hired for. If the conversation goes technical, steer here.

---

## My recommendation on the resume line

The current line is comprehensive, which is exactly the risk. Consider cutting it to what you would discuss unprompted, and letting the Selected Work entries carry the rest.

**Adopted version:**

> PostgreSQL · Next.js · Node · Prisma · Docker · AWS · CI/CD with automated testing · OIDC authentication · EffortlessAPI for rulebook driven builds · Agent and skill development

That drops Terraform, GitHub Actions by name, and the AWS service enumeration, and adds EffortlessAPI. It reads as someone stating what they work with rather than someone listing everything present in a project. Shorter lists read as more confident, and there is less surface to test.

**A different option, if you want the range visible without the exposure:**

> Full stack: React and Next.js front end, Node API, PostgreSQL, containerized and deployed to AWS. Comfortable making architecture decisions and building against them.

That last sentence is doing real work. It states the level of engagement honestly and preempts the depth question instead of waiting for it.

---

## What I need from you

Sort every item into A, B, or C. Anything in C comes off. Anything in B needs a sentence about what you decided.

Two specific ones I would ask about first, because they are the most likely to be tested and the least likely to be yours end to end: **Terraform** and the **AWS service list**.
