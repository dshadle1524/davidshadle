# 📘 David Shadle Website v4 — RuleSpeak

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
| Currently Text | A defined attribute. | _The undated 'Currently' block on Home (Section 10): 2-3 lines on what David is working on now. Update when something changes, not on a schedule._ |
| Banyan Title | A defined attribute. | _Full Banyan title, used everywhere per Section 6: 'Technical Advisor, Product Strategy and UX'._ |
| **Bio Variant** | A bio variant is identified by its name. | — |
| Name | The same as its label. | _Display alias._ |
| Label | A defined attribute. | _Human label for this bio length/context, e.g. 'Fifty words'._ |
| Usage Context | A defined attribute. | _Where this variant gets used, e.g. 'Directory listings, conference programs, deck footers, introductions.'_ |
| Body Text | A defined attribute. | _The bio copy itself. Paragraph breaks encoded as \n\n._ |
| Sort Order | A defined attribute. | _Display order, shortest to longest._ |
| **How I Work Section** | A how i work section is identified by its name. | — |
| Name | The same as its heading. | _Display alias._ |
| Heading | A defined attribute. | _Section heading as it appears on the page._ |
| Body Text | A defined attribute. | _Full-page body copy for this section. Paragraph breaks encoded as \n\n._ |
| Short Body Text | A defined attribute. | _Condensed ~1-paragraph version, used if How I Work becomes a Home section instead of its own page. Null where the short version drops the section entirely._ |
| Sort Order | A defined attribute. | _Display order on the page._ |
| **Proof Point** | A proof point is identified by its name. | — |
| Name | The same as its title. | _Display alias._ |
| Title | A defined attribute. | _Short title for this proof point._ |
| Problem Text | A defined attribute. | _The problem, as stated in the proof inventory._ |
| Action Text | A defined attribute. | _The action taken._ |
| Outcome Text | A defined attribute. | _The outcome._ |
| Attribution Note | A defined attribute. | _Precise attribution language required when describing this work (e.g. 'advised on and implemented,' not 'owned'). See Content Strategy Section 6._ |
| Register Note | A defined attribute. | _Internal guidance on tone/register for this proof point. Not published copy - for whoever writes site/resume text from this row._ |
| Featured on Work Page | True when an empty string. | _Whether this proof point is one of the 2-3 engagements shown on the Work page (Section 10). First-pass selection - confirm with David before Phase 2._ |
| Featured in Resume Selected Work | True when an empty string. | _Whether this proof point appears in the resume's 'Selected work, 2024 to 2026' block (Variant A)._ |
| Sort Order | A defined attribute. | _Order matching Content Strategy Section 4 numbering._ |
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
| **Resume Variant** | A resume variant is identified by its name. | — |
| Name | The same as its label. | _Display alias._ |
| Label | A defined attribute. | _Variant label._ |
| Audience Description | A defined attribute. | _Who this variant targets and how it is distributed._ |
| Summary Text | A defined attribute. | _The opening capability statement ('What I do' / 'Summary'). Paragraph breaks encoded as \n\n._ |
| Published on Site | True when an empty string. | _Whether this variant is served from the public site (Section 10: only Variant A)._ |
| **Resume List Item** | A resume list item is identified by its name. | — |
| Name | The same as its label. | _Display alias._ |
| Category | A defined attribute. | _'Methods' or 'Technical'._ |
| Label | A defined attribute. | _The item text as it appears on the resume._ |
| Sort Order | A defined attribute. | _Display order within its category._ |
| **Education Entry** | An education entry is identified by its name. | — |
| Name | Computed as the institution, followed by “ - ”, followed by the degree. | _Display alias._ |
| Institution | A defined attribute. | _School name._ |
| Degree | A defined attribute. | _Degree earned._ |
| Field of Study | A defined attribute. | _Major/field._ |
| Grad Year | A defined attribute. | _Graduation year._ |

## 3 Operative Rules

_Operative rules state what the business **obliges**, **prohibits**, or
advises (**should**). Structural rules come from required fields and foreign keys;
semantic rules come from the Constraints table, each keyed on a boolean the rulebook
already computes (cross-referenced as DR-N in the Definitional Rules below)._

### Structural Constraints (from the schema)

- A site setting **must** have a contact email, a site domain, a portfolio company count, a self description line, a positioning statement, and a banyan title.
- A bio variant **must** have a label, an usage context, a body text, and a sort order.
- A how i work section **must** have a heading, a body text, and a sort order.
- A proof point **must** have a title, a problem text, an action text, an outcome text, and a sort order, and record whether it is featured on work page and whether it is featured in resume selected work.
- A job entry **must** have a company, a start date, and a sort order, and record whether it is a current, whether it is include in variant a, whether it is include in variant b, and whether it is a pre2019.
- A resume variant **must** have a label, an audience description, and a summary text, and record whether it is published on site.
- A resume list item **must** have a category, a label, and a sort order.
- An education entry **must** have an institution and a degree.

## 4 Definitional Rules

_All statements express truth in the business domain; they are neither
procedures nor imperatives. "iff" is avoided in favor of "only if" so a
one-directional necessity is not mistaken for an equivalence. A
**⚠︎ mechanical** chip marks a rule whose deterministic wording is faithful
but clunky — a flag for an optional downstream reword pass, not a defect._

| ID | Declarative rule |
|----|------------------|
| **DR-1 Name** | A site setting's name is the same as its site setting ID. |
| **DR-2 Name** | A bio variant's name is the same as its label. |
| **DR-3 Name** | A how i work section's name is the same as its heading. |
| **DR-4 Name** | A proof point's name is the same as its title. |
| **DR-5 Name** | A job entry's name is computed as the company, followed by “ - ”, followed by the job title. |
| **DR-6 Name** | A resume variant's name is the same as its label. |
| **DR-7 Name** | A resume list item's name is the same as its label. |
| **DR-8 Name** | An education entry's name is computed as the institution, followed by “ - ”, followed by the degree. |

## 5 Traceability to Schema

_The expression column is the rule's definition in RuleSpeak notation —
the same logic the rulebook stores, written for a business reader._

| Schema element | Kind | Expression |
|----------------|------|------------|
| **SiteSettings.Name** | formula | `SiteSettingId` |
| **BioVariants.Name** | formula | `Label` |
| **HowIWorkSections.Name** | formula | `Heading` |
| **ProofPoints.Name** | formula | `Title` |
| **JobEntries.Name** | formula | `Company & " - " & JobTitle` |
| **ResumeVariants.Name** | formula | `Label` |
| **ResumeListItems.Name** | formula | `Label` |
| **EducationEntries.Name** | formula | `Institution & " - " & Degree` |

---

_This document is rendered in **RuleSpeak®**, the declarative business-rule
notation created by **Ronald G. Ross**, and follows the conventions of
**SBVR** (Semantics of Business Vocabulary and Business Rules). With thanks to
Ronald G. Ross for RuleSpeak and his foundational work on business rules —
[www.RonRoss.info](https://www.RonRoss.info)._
