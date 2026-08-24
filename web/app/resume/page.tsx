import {
  getSiteSettings,
  getResumeVariant,
  getJobEntriesForVariantA,
  getResumeListItems,
  getEducationEntries,
  getFeaturedWorkProofPoints,
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
    getFeaturedWorkProofPoints(),
  ]);

  const displayJobs = groupJobEntriesForVariantA(jobEntries);
  const methods = listItems.filter((i) => i.category === "Methods");
  const technical = listItems.filter((i) => i.category === "Technical");

  return (
    <section className="resume-section">
      <div className="container resume-content">
        <header className="resume-header">
          <h1 className="name-title">David Shadle</h1>
          <p className="tagline">Product Strategy · UX and Information Architecture · AI Development</p>
          <p className="contact-line">
            {settings.contact_email}
            {settings.contact_phone ? ` · ${settings.contact_phone}` : ""} · {settings.site_domain}
          </p>
        </header>

        <div className="resume-block">
          <h2 className="section-heading">What I do</h2>
          {variant.summary_text.split("\n\n").map((para, i) => (
            <p key={i} className="body-text" style={{ marginBottom: 16 }}>{para}</p>
          ))}
        </div>

        <div className="resume-block">
          <h2 className="section-heading">Selected work, 2024 to 2026</h2>
          {selectedWork.map((point) => (
            <div key={point.proof_point_id} className="experience-item">
              <p className="experience-title">{point.title}</p>
              <p className="body-text">{point.problem_text} {point.action_text} {point.outcome_text}</p>
            </div>
          ))}
        </div>

        <div className="resume-block">
          <h2 className="section-heading">Experience</h2>
          {displayJobs.map((job) => (
            <div key={job.key} className="experience-item">
              <p className="experience-title">{job.company}</p>
              {job.jobTitle && <p className="experience-role">{job.jobTitle}</p>}
              <p className="experience-dates">{formatDateRange(job.startDate, job.endDate)}</p>
              {job.summaryText && <p className="body-text">{job.summaryText}</p>}
              {job.compressedLine && <p className="compressed-line">{job.compressedLine}</p>}
            </div>
          ))}
        </div>

        <div className="resume-block methods-technical-grid">
          <div>
            <h2 className="section-heading">Methods</h2>
            <ul className="resume-list" style={{ marginTop: 16 }}>
              {methods.map((item) => (
                <li key={item.resume_list_item_id}>{item.label}</li>
              ))}
            </ul>
          </div>
          <div>
            <h2 className="section-heading">Technical</h2>
            <ul className="resume-list" style={{ marginTop: 16 }}>
              {technical.map((item) => (
                <li key={item.resume_list_item_id}>{item.label}</li>
              ))}
            </ul>
          </div>
        </div>

        <div className="resume-block">
          <h2 className="section-heading">Education</h2>
          {education.map((ed) => (
            <p key={ed.education_entry_id} className="body-text">
              {ed.institution} · {ed.degree}
              {ed.field_of_study ? `, ${ed.field_of_study}` : ""}
              {ed.grad_year ? ` · ${ed.grad_year}` : ""}
            </p>
          ))}
        </div>
      </div>
    </section>
  );
}
