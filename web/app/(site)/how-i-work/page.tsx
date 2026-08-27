import Link from "next/link";
import { getHowIWorkSections, splitParagraphs } from "@/lib/content";

export const metadata = { title: "How I Work — David Shadle" };

const STAGE_LINE = /^(\d+)\.\s+([^.]+\.)\s*(.*)$/;

function renderParagraph(para: string, key: number) {
  const lines = para.split("\n");
  if (lines.length > 1 && lines.every((line) => STAGE_LINE.test(line))) {
    return (
      <ol key={key} className="stage-list">
        {lines.map((line) => {
          const match = line.match(STAGE_LINE)!;
          const [, number, name, rest] = match;
          return (
            <li key={number} className="stage-item">
              <span className="stage-marker">{number}</span>
              <span className="body-text">
                <span className="stage-name">{name}</span> {rest}
              </span>
            </li>
          );
        })}
      </ol>
    );
  }
  return (
    <p key={key} className="body-text">
      {para}
    </p>
  );
}

export default async function HowIWorkPage() {
  const sections = await getHowIWorkSections();
  const principles = sections.filter((s) => s.heading !== "Where AI fits");
  const aiFits = sections.find((s) => s.heading === "Where AI fits");
  const aiFitsParas = aiFits ? splitParagraphs(aiFits.body_text) : [];

  return (
    <>
      <section className="band">
        <div className="container">
          <div className="hero-col">
            <span className="eyebrow">How I work</span>
            <h1 className="h1-inner">How I work, and why. Six things, each with a reason attached.</h1>
            <hr className="accent-rule" />
          </div>
        </div>
      </section>

      <section className="band-alt">
        <div className="container">
          <div className="principle-list">
            {principles.map((section, i) => (
              <div key={section.how_i_work_section_id} className="principle-item">
                <span className="principle-number">{String(i + 1).padStart(2, "0")}</span>
                <div className="principle-body">
                  <h2 className="h2">{section.heading}</h2>
                  {splitParagraphs(section.body_text).map((para, j) =>
                    renderParagraph(para, j),
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {aiFits && (
        <section className="band">
          <div className="container">
            <span className="eyebrow">Where AI fits</span>
            <div className="ai-fits">
              {aiFitsParas.map((para, i) =>
                i === 0 ? (
                  <p key={i} className="ai-fits-lead">{para}</p>
                ) : (
                  <p key={i} className="body-text">{para}</p>
                ),
              )}
            </div>
            <Link href="/work" className="btn" style={{ marginTop: 48 }}>
              See the work this produced <span className="btn-arrow">&rarr;</span>
            </Link>
          </div>
        </section>
      )}
    </>
  );
}
