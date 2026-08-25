"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const NAV_ITEMS = [
  { href: "/how-i-work", label: "How I work" },
  { href: "/work", label: "Projects" },
  { href: "/resume", label: "Resume" },
];

interface HeaderProps {
  taglineLead: string;
  taglineRest: string;
  email: string;
}

export function Header({ taglineLead, taglineRest, email }: HeaderProps) {
  const pathname = usePathname();

  return (
    <header className="site-header">
      <div className="container header-row">
        <Link href="/" className="wordmark">
          david <strong>shadle</strong>
        </Link>

        <div className="header-right">
          <nav className="main-nav" aria-label="Primary">
            <ul>
              {NAV_ITEMS.map((item) => {
                const isActive = pathname === item.href;
                return (
                  <li key={item.href} className={isActive ? "is-active" : undefined}>
                    <span className="nav-dot" />
                    <Link href={item.href}>{item.label}</Link>
                  </li>
                );
              })}
            </ul>
          </nav>

          <div className="header-aside">
            <p className="header-tagline">
              <strong>{taglineLead}</strong>
              {taglineRest}
            </p>
            <a className="header-email" href={`mailto:${email}`}>
              {email}
            </a>
          </div>
        </div>
      </div>
      <div className="container">
        <hr className="header-rule" />
      </div>
    </header>
  );
}
