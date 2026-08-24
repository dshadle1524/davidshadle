import { getSiteSettings } from "@/lib/content";

// Per Content Strategy Section 10: a section, not a page. Repeated at
// the bottom of Home and Work.
export async function ContactSection() {
  const settings = await getSiteSettings();

  return (
    <section className="contact-section" id="contact">
      <div className="container">
        <span className="eyebrow">Get in touch</span>
        <h2 className="quote" style={{ marginTop: 12, marginBottom: 20 }}>
          Reach out directly, no form to fill out.
        </h2>
        <a className="contact-email" href={`mailto:${settings.contact_email}`}>
          {settings.contact_email}
        </a>
        {settings.contact_phone && (
          <p className="body-text" style={{ marginTop: 8 }}>{settings.contact_phone}</p>
        )}
      </div>
    </section>
  );
}
