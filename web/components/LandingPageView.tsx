import {
  splitParagraphs,
  type LandingPage,
  type LandingPageItem,
  type LandingPageSection,
} from "@/lib/content";

function youtubeEmbedUrl(url: string | null): string | null {
  if (!url) return null;
  const match = url.match(
    /(?:youtube\.com\/(?:watch\?(?:.*&)?v=|embed\/|shorts\/)|youtu\.be\/)([\w-]{11})/,
  );
  return match ? `https://www.youtube-nocookie.com/embed/${match[1]}` : null;
}

const VIDEO_FILE = /\.(mp4|webm|mov)(\?.*)?$/i;

function Facts({ item }: { item: LandingPageItem }) {
  if (item.facts.length === 0) return null;
  return (
    <dl className="lp-facts">
      {item.facts.map((fact) => {
        const lines = fact.body_text.split(/\r?\n/).map((l) => l.trim()).filter(Boolean);
        return (
          <div key={fact.landing_page_item_fact_id} className="lp-fact">
            <dt className="lp-fact-label">{fact.label}</dt>
            <dd className="lp-fact-body">
              {lines.length > 1 ? (
                <ul className="lp-fact-list">
                  {lines.map((line, i) => (
                    <li key={i}>{line}</li>
                  ))}
                </ul>
              ) : (
                lines[0]
              )}
            </dd>
          </div>
        );
      })}
    </dl>
  );
}

function Paragraphs({ text }: { text: string | null }) {
  if (!text) return null;
  return (
    <>
      {splitParagraphs(text).map((para, i) => (
        <p key={i} className="body-text">
          {para}
        </p>
      ))}
    </>
  );
}

function SectionBody({
  section,
  page,
}: {
  section: LandingPageSection;
  page: LandingPage;
}) {
  switch (section.kind) {
    case "steps":
      return (
        <ol className="stage-list lp-steps">
            {section.items.map((item) => (
              <li key={item.landing_page_item_id} className="stage-item">
                <span className="stage-marker" aria-hidden="true">
                  {item.label}
                </span>
                <div className="lp-item">
                  <h3 className="lp-item-heading">{item.heading}</h3>
                  <Paragraphs text={item.body_text} />
                  <Facts item={item} />
                </div>
              </li>
            ))}
        </ol>
      );
    case "cards":
      return (
        <ul className="lp-cards">
          {section.items.map((item) => (
            <li key={item.landing_page_item_id} className="lp-card">
              <h3 className="lp-item-heading">{item.heading}</h3>
              <Paragraphs text={item.body_text} />
              <Facts item={item} />
            </li>
          ))}
        </ul>
      );
    case "list":
      return (
        <ul className="lp-list">
          {section.items.map((item) => (
            <li key={item.landing_page_item_id} className="lp-list-item">
              {item.body_text ? (
                <>
                  <h3 className="lp-item-heading">{item.heading}</h3>
                  <Paragraphs text={item.body_text} />
                </>
              ) : (
                <p className="body-text">{item.heading}</p>
              )}
              <Facts item={item} />
            </li>
          ))}
        </ul>
      );
    case "callout":
      return (
        <div className="lp-callout-actions">
          <a href={page.primary_cta_href} className="btn">
            {page.primary_cta_label} <span className="btn-arrow" aria-hidden="true">&rarr;</span>
          </a>
        </div>
      );
    default:
      return null;
  }
}

export function LandingPageView({ page }: { page: LandingPage }) {
  const videoSrc = youtubeEmbedUrl(page.video_url);
  return (
    <>
      <section className="band">
        <div className="container">
          <div className="hero-col">
            <span className="eyebrow">{page.eyebrow}</span>
            {videoSrc ? (
              <div className="lp-video">
                <iframe
                  src={videoSrc}
                  title={`${page.eyebrow} video`}
                  loading="lazy"
                  allow="accelerometer; encrypted-media; gyroscope; picture-in-picture; fullscreen"
                  allowFullScreen
                />
              </div>
            ) : (
              page.video_url &&
              VIDEO_FILE.test(page.video_url) && (
                <div className="lp-video">
                  <video
                    src={page.video_url}
                    controls
                    playsInline
                    preload="metadata"
                    aria-label={`${page.eyebrow} video`}
                  />
                </div>
              )
            )}
            <h1 className="h1-inner">{page.headline}</h1>
            <hr className="accent-rule" />
            <p className="lede-inner">{page.lede}</p>
            <div className="lp-hero-actions">
              {page.secondary_cta_label && page.secondary_cta_href && (
                <a href={page.secondary_cta_href} className="lp-secondary-link">
                  {page.secondary_cta_label}
                </a>
              )}
            </div>
          </div>
        </div>
      </section>

      {page.sections.map((section, i) => (
        <section
          key={section.landing_page_section_id}
          id={section.anchor_id ?? undefined}
          className={`${i % 2 === 0 ? "band-alt" : "band"} lp-section`}
        >
          <div className="container">
            {section.eyebrow && <span className="eyebrow">{section.eyebrow}</span>}
            {section.kind === "callout" ? (
              <div className="ai-fits">
                <h2 className="h2">{section.heading}</h2>
                <Paragraphs text={section.body_text} />
                <SectionBody section={section} page={page} />
              </div>
            ) : (
              <>
                <h2 className="h2 lp-section-heading">{section.heading}</h2>
                {section.kind === "prose" ? (
                  <div className="lp-prose">
                    <Paragraphs text={section.body_text} />
                  </div>
                ) : (
                  <>
                    {section.body_text && (
                      <div className="lp-prose lp-section-intro">
                        <Paragraphs text={section.body_text} />
                      </div>
                    )}
                    <SectionBody section={section} page={page} />
                  </>
                )}
              </>
            )}
          </div>
        </section>
      ))}
    </>
  );
}
