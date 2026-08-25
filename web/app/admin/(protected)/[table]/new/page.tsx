import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { getTableConfig, createRow } from "@/lib/admin/queries";
import { AdminForm } from "@/components/admin/AdminForm";

export default async function AdminTableNewPage({
  params,
}: {
  params: Promise<{ table: string }>;
}) {
  const { table } = await params;
  const config = getTableConfig(table);
  if (!config || !config.slugSourceField) notFound();

  async function create(formData: FormData) {
    "use server";
    await createRow(table, formData);
    redirect(`/admin/${table}`);
  }

  return (
    <div>
      <Link href={`/admin/${table}`} style={{ display: "inline-block", marginBottom: 16 }}>
        ← Back to {config.label}
      </Link>
      <h1 style={{ fontSize: 24, marginBottom: 24 }}>New {config.label.replace(/s$/, "")}</h1>
      <AdminForm fields={config.fields} defaultValues={{}} action={create} submitLabel="Create" />
    </div>
  );
}
