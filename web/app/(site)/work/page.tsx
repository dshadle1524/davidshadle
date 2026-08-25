import { getSelectedWorkProofPoints } from "@/lib/content";

export const metadata = { title: "Projects — David Shadle" };

export default async function WorkPage() {
  const proofPoints = await getSelectedWorkProofPoints();

  return (
    <>
      <section className="band">
        <div className="container">
          <div className="hero-col">
            <span className="eyebrow">Projects</span>
            <h1 className="h1-inner">Selected work, 2024 to 2026.</h1>
            <hr className="accent-rule" />
            <p className="lede-inner">A few engagements, written as problem, action, outcome.</p>
          </div>
        </div>
      </section>

      <section className="band-alt">
        <div className="container">
          <div className="projects-list">
            {proofPoints.map((point) => (
              <div key={point.proof_point_id} className="project-item">
                <div className="project-item-text">
                  {(point.client_or_category || point.status_label) && (
                    <div className="project-meta">
                      {point.client_or_category && (
                        <span className="project-meta-client">{point.client_or_category}</span>
                      )}
                      {point.status_label && (
                        <span className="project-meta-status">{point.status_label}</span>
                      )}
                    </div>
                  )}
                  <h2 className="h2">{point.title}</h2>
                  <p className="body-text">
                    {point.problem_text} {point.action_text} {point.outcome_text}
                  </p>
                </div>
                {point.image_url ? (
                  <img src={point.image_url} alt={point.title} className="project-screenshot" />
                ) : (
                  <div className="project-screenshot-slot">
                    <p className="project-screenshot-label">Screenshot pending</p>
                    <p className="project-screenshot-note">Portal and dashboard captures go here once permission clears.</p>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>
    </>
  );
}
