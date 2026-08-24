import { getHowIWorkSections } from "@/lib/content";

export const metadata = { title: "How I Work — David Shadle" };

export default async function HowIWorkPage() {
  const sections = await getHowIWorkSections();

  return (
    <section className="section">
      <div className="container">
        <div className="section-intro">
          <span className="eyebrow">How I work</span>
          <h1 className="quote" style={{ marginTop: 12 }}>
            How I work, and why. Six things, each with a reason attached.
          </h1>
        </div>
        <div>
          {sections.map((section) => (
            <div key={section.how_i_work_section_id} className="hiw-section">
              <h2 className="hiw-heading">{section.heading}</h2>
              <div className="body-text hiw-body">
                {section.body_text.split("\n\n").map((para, i) => (
                  <p key={i} style={{ marginBottom: 16 }}>{para}</p>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
