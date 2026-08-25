import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { getTableConfig, getRow, updateRow, deleteRow } from "@/lib/admin/queries";
import { AdminForm } from "@/components/admin/AdminForm";

export default async function AdminTableEditPage({
  params,
}: {
  params: Promise<{ table: string; id: string }>;
}) {
  const { table, id } = await params;
  const config = getTableConfig(table);
  if (!config) notFound();

  const row = await getRow(table, id);
  if (!row) notFound();

  async function update(formData: FormData) {
    "use server";
    await updateRow(table, id, formData);
    redirect(`/admin/${table}`);
  }

  async function remove() {
    "use server";
    await deleteRow(table, id);
    redirect(`/admin/${table}`);
  }

  return (
    <div>
      <Link href={`/admin/${table}`} style={{ display: "inline-block", marginBottom: 16 }}>
        ← Back to {config.label}
      </Link>
      <h1 style={{ fontSize: 24, marginBottom: 24 }}>Edit {config.label.replace(/s$/, "")}</h1>
      <AdminForm fields={config.fields} defaultValues={row} action={update} submitLabel="Save" />
      {config.slugSourceField && (
        <form action={remove} style={{ marginTop: 24 }}>
          <button type="submit" style={{ color: "crimson" }}>
            Delete
          </button>
        </form>
      )}
    </div>
  );
}
