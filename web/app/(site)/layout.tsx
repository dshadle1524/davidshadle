import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";
import { getSiteSettings } from "@/lib/content";

export const dynamic = "force-dynamic";

export default async function SiteLayout({ children }: { children: React.ReactNode }) {
  const settings = await getSiteSettings();

  return (
    <>
      <div className="top-bar" />
      <Header />
      <main className="flex-1">{children}</main>
      <Footer email={settings.contact_email} />
    </>
  );
}
