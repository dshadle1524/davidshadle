import type { Metadata } from "next";
import { Roboto_Slab, Raleway } from "next/font/google";
import "./globals.css";

const robotoSlab = Roboto_Slab({
  subsets: ["latin"],
  weight: ["400", "500", "700"],
  variable: "--font-slab",
  display: "swap",
});

const raleway = Raleway({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-raleway",
  display: "swap",
});

export const metadata: Metadata = {
  title: "David Shadle",
  description: "Product strategy, design, and the systems that ship them.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html
      lang="en"
      data-scroll-behavior="smooth"
      className={`h-full ${robotoSlab.variable} ${raleway.variable}`}
    >
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
