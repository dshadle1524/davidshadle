import {
  getSiteSettings,
  getResumeVariant,
  getJobEntriesForVariantA,
  getResumeListItems,
  getEducationEntries,
  getSelectedWorkProofPoints,
} from "@/lib/content";
import { groupJobEntriesForVariantA } from "@/lib/jobs";
import { formatDateRange } from "@/lib/format";

export const metadata = { title: "Resume — David Shadle" };

export default async function ResumePage() {
  const [settings, variant, jobEntries, listItems, education, selectedWork] = await Promise.all([
    getSiteSettings(),
    getResumeVariant("variant-a"),
    getJobEntriesForVariantA(),
    getResumeListItems(),
    getEducationEntries(),
    getSelectedWorkProofPoints(),
  ]);

  const displayJobs = groupJobEntriesForVariantA(jobEntries);
  const methods = listItems.filter((i) => i.category === "Methods");
  const technical = listItems.filter((i) => i.category === "Technical");
  const summaryParas = variant.summary_text.split("\n\n");

  return (
    <>
      <section className="band">
        <div className="container">
          <span className="eyebrow">Resume</span>
          <div className="resume-hero-row">
            <div className="resume-hero-left">
              <h1 className="h1-inner">Product strategy, UX and information architecture, AI development.</h1>
              <hr className="accent-rule" />
              <p className="contact-line">
                {[settings.contact_email, settings.contact_phone, settings.site_domain]
                  .filter(Boolean)
                  .map((part, i) => (
                    <span key={i}>
                      {i > 0 && <span className="sep">&middot;</span>}
                      {part}
                    </span>
                  ))}
              </p>
            </div>
            <a className="btn" href="#">
              Download as PDF <span className="btn-arrow">&darr;</span>
            </a>
          </div>
        </div>
      </section>

      <section className="band-alt">
        <div className="container">
          <span className="eyebrow">What I do</span>
          <div className="what-i-do">
            {summaryParas.map((para, i) =>
              i === 0 ? (
                <p key={i} className="what-i-do-lead">{para}</p>
              ) : (
                <p key={i} className="body-text">{para}</p>
              ),
            )}
          </div>
        </div>
      </section>

      <section className="band">
        <div className="container">
          <span className="eyebrow">Selected work, 2024 to 2026</span>
          <div className="divider-list selected-work-list">
            {selectedWork.map((point) => (
              <div key={point.proof_point_id} className="divider-item">
                <h2 className="h2">{point.title}</h2>
                <p className="body-text">
                  {point.problem_text} {point.action_text} {point.outcome_text}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="band-alt">
        <div className="container">
          <span className="eyebrow">Experience</span>
          <div className="experience-list">
            {displayJobs.map((job) => (
              <div key={job.key} className="experience-row">
                <div className="experience-left">
                  <p className="experience-company">{job.company}</p>
                  {job.jobTitle && <p className="experience-role">{job.jobTitle}</p>}
                  <p className="experience-dates">{formatDateRange(job.startDate, job.endDate)}</p>
                </div>
                <div className="experience-right">
                  {job.summaryText && <p className="body-text">{job.summaryText}</p>}
                  {job.compressedLine && <p className="compressed-line">{job.compressedLine}</p>}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="band">
        <div className="container">
          <div className="resume-columns">
            <div className="resume-column">
              <span className="eyebrow">Methods</span>
              <p>{methods.map((item) => item.label).join(" · ")}</p>
            </div>
            <div className="resume-column">
              <span className="eyebrow">Technical</span>
              <p>{technical.map((item) => item.label).join(" · ")}</p>
            </div>
            <div className="resume-column">
              <span className="eyebrow">Education</span>
              <p>
                {education
                  .map((ed) =>
                    [ed.institution, [ed.degree, ed.field_of_study].filter(Boolean).join(", "), ed.grad_year]
                      .filter(Boolean)
                      .join(" · "),
                  )
                  .join(" · ")}
              </p>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
