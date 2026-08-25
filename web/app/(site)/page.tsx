import Link from "next/link";
import { getSiteSettings, getBioVariant, getCurrentlyItems, getHowIWorkSections, getFeaturedWorkProofPoints } from "@/lib/content";

export default async function Home() {
  const [settings, bio, currentlyItems, howIWork, proofPoints] = await Promise.all([
    getSiteSettings(),
    getBioVariant("home-body"),
    getCurrentlyItems(),
    getHowIWorkSections(),
    getFeaturedWorkProofPoints(),
  ]);

  const howIWorkTeaser = howIWork.slice(0, 3);
  const introParas = bio.body_text.split("\n\n");

  return (
    <>
      {/* ---- Hero / Intro ---- */}
      <section className="band">
        <div className="container">
          <div className="hero-col">
            <h1 className="h1-home">{settings.hero_headline}</h1>
            <hr className="accent-rule" />
            <p className="lede">{settings.hero_subheadline}</p>
            <div className="intro-paras">
              {introParas.map((para, i) => (
                <p key={i} className="body-text">{para}</p>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* ---- Currently ---- */}
      {currentlyItems.length > 0 && (
        <section className="band-alt">
          <div className="container">
            <span className="eyebrow">Currently</span>
            <ul className="currently-list">
              {currentlyItems.map((item) => (
                <li key={item.currently_item_id} className="currently-item">
                  <div className="currently-item-head">
                    <span className="currently-dot" />
                    <h3 className="h3">{item.title}</h3>
                  </div>
                  <p className="body-text">{item.body_text}</p>
                </li>
              ))}
            </ul>
          </div>
        </section>
      )}

      {/* ---- How I Work teaser ---- */}
      <section className="band">
        <div className="container">
          <span className="eyebrow">How I work</span>
          <div className="divider-list">
            {howIWorkTeaser.map((section) => (
              <div key={section.how_i_work_section_id} className="hiw-teaser-item">
                <h2 className="h2">{section.heading}</h2>
                <p className="body-text">{section.short_body_text ?? section.body_text}</p>
              </div>
            ))}
          </div>
          <Link href="/how-i-work" className="btn" style={{ marginTop: 48 }}>
            Read How I Work <span className="btn-arrow">&rarr;</span>
          </Link>
        </div>
      </section>

      {/* ---- Work preview ---- */}
      <section className="band-alt">
        <div className="container">
          <span className="eyebrow">Selected work</span>
          <div className="divider-list">
            {proofPoints.map((point) => (
              <div key={point.proof_point_id} className="divider-item">
                <h2 className="h2">{point.title}</h2>
                <p className="body-text">{point.outcome_text}</p>
              </div>
            ))}
          </div>
          <Link href="/work" className="btn" style={{ marginTop: 48 }}>
            See all the work <span className="btn-arrow">&rarr;</span>
          </Link>
        </div>
      </section>
    </>
  );
}
