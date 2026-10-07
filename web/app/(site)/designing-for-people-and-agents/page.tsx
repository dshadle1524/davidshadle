import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getLandingPage } from "@/lib/content";
import { LandingPageView } from "@/components/LandingPageView";

const SLUG = "designing-for-people-and-agents";

export async function generateMetadata(): Promise<Metadata> {
  const page = await getLandingPage(SLUG);
  if (!page) return {};
  return {
    title: page.meta_title,
    description: page.meta_description,
    robots: { index: true },
    openGraph: {
      title: page.meta_title,
      description: page.meta_description,
      type: "website",
    },
  };
}

export default async function DesigningForPeopleAndAgentsPage() {
  const page = await getLandingPage(SLUG);
  if (!page) notFound();
  return <LandingPageView page={page} />;
}
