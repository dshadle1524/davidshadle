import Link from "next/link";
import { ADMIN_TABLES } from "@/lib/admin/schema";

export default function AdminProtectedLayout({ children }: { children: React.ReactNode }) {
  return (
    <div style={{ display: "flex", minHeight: "100vh", fontFamily: "sans-serif" }}>
      <nav style={{ width: 220, borderRight: "1px solid #ddd", padding: "24px 16px", flexShrink: 0 }}>
        <Link href="/admin" style={{ fontWeight: 700, display: "block", marginBottom: 24 }}>
          Admin
        </Link>
        <ul style={{ listStyle: "none", margin: 0, padding: 0, display: "flex", flexDirection: "column", gap: 8 }}>
          {ADMIN_TABLES.map((t) => (
            <li key={t.table}>
              <Link href={`/admin/${t.table}`}>{t.label}</Link>
            </li>
          ))}
        </ul>
        <form action="/api/admin/auth/logout" method="post" style={{ marginTop: 32 }}>
          <button
            type="submit"
            style={{ padding: "8px 16px", border: "1px solid #333", borderRadius: 4, background: "#f5f5f5", cursor: "pointer" }}
          >
            Log out
          </button>
        </form>
      </nav>
      <main style={{ flex: 1, padding: 32 }}>{children}</main>
    </div>
  );
}
