import { getFeaturedWorkProofPoints } from "@/lib/content";
import { ContactSection } from "@/components/ContactSection";

export const metadata = { title: "Work — David Shadle" };

export default async function WorkPage() {
  const proofPoints = await getFeaturedWorkProofPoints();

  return (
    <>
      <section className="section">
        <div className="container">
          <div className="section-intro">
            <span className="eyebrow">Work</span>
            <h1 className="quote" style={{ marginTop: 12 }}>
              A few engagements, written as problem, action, outcome.
            </h1>
          </div>
          <div>
            {proofPoints.map((point) => (
              <div key={point.proof_point_id} className="proof-card two-col">
                <div className="placeholder-image">Screenshot pending permission</div>
                <div>
                  <h2 className="proof-title">{point.title}</h2>
                  <div className="proof-block">
                    <span className="proof-label">Problem</span>
                    <p className="body-text">{point.problem_text}</p>
                  </div>
                  <div className="proof-block">
                    <span className="proof-label">Action</span>
                    <p className="body-text">{point.action_text}</p>
                  </div>
                  <div className="proof-block">
                    <span className="proof-label">Outcome</span>
                    <p className="body-text">{point.outcome_text}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <ContactSection />
    </>
  );
}
