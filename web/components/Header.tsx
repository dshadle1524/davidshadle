import Link from "next/link";

export function Header() {
  return (
    <header className="site-header">
      <div className="container header-inner">
        <Link href="/" className="logo">
          <span className="david">david</span>
          <span className="shadle">shadle</span>
        </Link>
        <nav className="main-nav">
          <ul>
            <li><Link href="/how-i-work">How I Work</Link></li>
            <li><Link href="/work">Work</Link></li>
            <li><Link href="/resume">Resume</Link></li>
          </ul>
        </nav>
      </div>
    </header>
  );
}
