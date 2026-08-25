"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

interface FooterProps {
  email: string;
}

export function Footer({ email }: FooterProps) {
  const pathname = usePathname();
  const onResume = pathname === "/resume";
  const crossLink = onResume ? { href: "/work", label: "Projects" } : { href: "/resume", label: "Resume" };

  return (
    <>
      <footer className="site-footer">
        <div className="footer-row">
          <div className="footer-left">
            <span className="footer-monogram">ds</span>
            <span className="footer-name">
              david <strong>shadle</strong>
            </span>
            <span className="footer-middot">&middot;</span>
            <span className="footer-tagline">Product strategy, design, and the systems that ship them.</span>
          </div>
          <div className="footer-right">
            <a className="footer-email" href={`mailto:${email}`}>
              {email}
            </a>
            <Link className="footer-crosslink" href={crossLink.href}>
              {crossLink.label}
            </Link>
          </div>
        </div>
      </footer>
      <div className="bottom-bar" />
    </>
  );
}
