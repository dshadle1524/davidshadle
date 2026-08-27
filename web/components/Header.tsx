"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const NAV_ITEMS = [
  { href: "/how-i-work", label: "How I work" },
  { href: "/work", label: "Projects" },
  { href: "/resume", label: "Resume" },
];

export function Header() {
  const pathname = usePathname();

  return (
    <header className="site-header">
      <div className="container header-row">
        <Link href="/" className="wordmark">
          david <strong>shadle</strong>
        </Link>

        <nav className="main-nav" aria-label="Primary">
          <ul>
            {NAV_ITEMS.map((item) => {
              const isActive = pathname === item.href;
              return (
                <li key={item.href} className={isActive ? "is-active" : undefined}>
                  <Link href={item.href}>{item.label}</Link>
                </li>
              );
            })}
          </ul>
        </nav>
      </div>
      <div className="container">
        <hr className="header-rule" />
      </div>
    </header>
  );
}
