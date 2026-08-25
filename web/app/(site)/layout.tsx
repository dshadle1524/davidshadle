import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";
import { getSiteSettings } from "@/lib/content";

export default async function SiteLayout({ children }: { children: React.ReactNode }) {
  const settings = await getSiteSettings();
  const [taglineLead, ...taglineRestParts] = settings.self_description_line.split(". ");
  const taglineRest = taglineRestParts.length
    ? ` ${taglineRestParts.join(". ")}`
    : "";

  return (
    <>
      <div className="top-bar" />
      <Header taglineLead={`${taglineLead}.`} taglineRest={taglineRest} email={settings.contact_email} />
      <main className="flex-1">{children}</main>
      <Footer email={settings.contact_email} />
    </>
  );
}
