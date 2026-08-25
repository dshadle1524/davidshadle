export const metadata = { title: "Admin — David Shadle" };

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  return <div style={{ fontFamily: "sans-serif" }}>{children}</div>;
}
