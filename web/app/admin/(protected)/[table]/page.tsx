import Link from "next/link";
import { notFound } from "next/navigation";
import { getTableConfig, listRows } from "@/lib/admin/queries";

export default async function AdminTableListPage({
  params,
}: {
  params: Promise<{ table: string }>;
}) {
  const { table } = await params;
  const config = getTableConfig(table);
  if (!config) notFound();

  const rows = await listRows(table);

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
        <h1 style={{ fontSize: 24 }}>{config.label}</h1>
        {config.slugSourceField && <Link href={`/admin/${table}/new`}>+ New</Link>}
      </div>

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr>
            {config.listColumns.map((col) => (
              <th key={col} style={{ textAlign: "left", borderBottom: "1px solid #ddd", padding: "8px 4px" }}>
                {col}
              </th>
            ))}
            <th style={{ borderBottom: "1px solid #ddd", padding: "8px 4px" }} />
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const id = String(row[config.idField]);
            return (
              <tr key={id}>
                {config.listColumns.map((col) => (
                  <td key={col} style={{ borderBottom: "1px solid #eee", padding: "8px 4px" }}>
                    {String(row[col] ?? "")}
                  </td>
                ))}
                <td style={{ borderBottom: "1px solid #eee", padding: "8px 4px" }}>
                  <Link href={`/admin/${table}/${encodeURIComponent(id)}`}>Edit</Link>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
