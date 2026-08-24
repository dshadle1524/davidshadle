import Link from "next/link";
import { getSiteSettings, getBioVariant, getHowIWorkSections, getFeaturedWorkProofPoints } from "@/lib/content";
import { ContactSection } from "@/components/ContactSection";

export default async function Home() {
  const [settings, bio, howIWork, proofPoints] = await Promise.all([
    getSiteSettings(),
    getBioVariant("home-body"),
    getHowIWorkSections(),
    getFeaturedWorkProofPoints(),
  ]);

  const howIWorkTeaser = howIWork.slice(0, 3);

  return (
    <>
      {/* ---- Hero / Intro ---- */}
      <section className="hero">
        <div className="container hero-inner">
          <p className="hero-headline">{settings.hero_headline}</p>
          <p className="hero-subheadline">{settings.hero_subheadline}</p>
        </div>
      </section>

      {/* ---- Bio / thesis ---- */}
      <section className="section">
        <div className="container">
          <div className="section-intro">
            {bio.body_text.split("\n\n").map((para, i) => (
              <p key={i} className="body-text" style={{ marginBottom: 20 }}>{para}</p>
            ))}
          </div>
        </div>
      </section>

      {/* ---- Currently ---- */}
      {settings.currently_text && (
        <section className="section tinted">
          <div className="container">
            <span className="eyebrow">Currently</span>
            <p className="body-text" style={{ marginTop: 12, maxWidth: 720 }}>
              {settings.currently_text}
            </p>
          </div>
        </section>
      )}

      {/* ---- How I Work teaser ---- */}
      <section className="section">
        <div className="container">
          <span className="eyebrow">How I work</span>
          <div style={{ marginTop: 24 }}>
            {howIWorkTeaser.map((section) => (
              <div key={section.how_i_work_section_id} className="hiw-section">
                <h3 className="hiw-heading">{section.heading}</h3>
                <p className="body-text hiw-body">{section.short_body_text ?? section.body_text}</p>
              </div>
            ))}
          </div>
          <Link href="/how-i-work" className="resume-download-link" style={{ marginTop: 24 }}>
            Read the full How I Work page
          </Link>
        </div>
      </section>

      {/* ---- Work preview ---- */}
      <section className="section tinted">
        <div className="container">
          <span className="eyebrow">Selected work</span>
          <div style={{ marginTop: 24 }}>
            {proofPoints.map((point) => (
              <div key={point.proof_point_id} className="proof-card">
                <h3 className="proof-title">{point.title}</h3>
                <p className="body-text">{point.outcome_text}</p>
              </div>
            ))}
          </div>
          <Link href="/work" className="resume-download-link" style={{ marginTop: 24 }}>
            See all the work
          </Link>
        </div>
      </section>

      <ContactSection />
    </>
  );
}
