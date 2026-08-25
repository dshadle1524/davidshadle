import { adminPool } from "@/lib/admin-db";
import { ADMIN_TABLES, getTableConfig, type AdminTableConfig } from "./schema";

// Table/column identifiers used below are ALWAYS drawn from ADMIN_TABLES
// (trusted, hardcoded config), never from request input — so building SQL
// with them via string interpolation is safe; only VALUES are parameterized.

function requireConfig(table: string): AdminTableConfig {
  const config = getTableConfig(table);
  if (!config) throw new Error(`Unknown admin table: ${table}`);
  return config;
}

function slugify(input: string): string {
  return input
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 60);
}

export async function listRows(table: string): Promise<Record<string, unknown>[]> {
  const config = requireConfig(table);
  const orderBy = config.sortField ? ` ORDER BY ${config.sortField}` : "";
  const { rows } = await adminPool.query(`SELECT * FROM ${config.view}${orderBy}`);
  return rows;
}

export async function getRow(table: string, id: string): Promise<Record<string, unknown> | undefined> {
  const config = requireConfig(table);
  const { rows } = await adminPool.query(
    `SELECT * FROM ${config.view} WHERE ${config.idField} = $1`,
    [id],
  );
  return rows[0];
}

function coerceValue(type: string, raw: FormDataEntryValue | null): unknown {
  if (type === "boolean") return raw === "on" || raw === "true";
  if (raw === null || raw === "") return null;
  if (type === "integer") return parseInt(String(raw), 10);
  // <input type="month"> gives "YYYY-MM"; the column is DATE, so store the 1st of that month.
  if (type === "month") return `${String(raw)}-01`;
  return String(raw);
}

export async function createRow(table: string, formData: FormData): Promise<string> {
  const config = requireConfig(table);
  if (!config.slugSourceField) {
    throw new Error(`${table} does not support creating new rows`);
  }

  const sourceValue = String(formData.get(config.slugSourceField) ?? "").trim();
  if (!sourceValue) {
    throw new Error(`${config.fields.find((f) => f.name === config.slugSourceField)?.label ?? config.slugSourceField} is required`);
  }
  const id = `${slugify(sourceValue)}-${Math.random().toString(36).slice(2, 6)}`;

  const columns = [config.idField];
  const values: unknown[] = [id];
  for (const field of config.fields) {
    columns.push(field.name);
    values.push(coerceValue(field.type, formData.get(field.name)));
  }

  const placeholders = values.map((_, i) => `$${i + 1}`).join(", ");
  await adminPool.query(
    `INSERT INTO ${config.table} (${columns.join(", ")}) VALUES (${placeholders})`,
    values,
  );
  return id;
}

export async function updateRow(table: string, id: string, formData: FormData): Promise<void> {
  const config = requireConfig(table);
  const setClauses: string[] = [];
  const values: unknown[] = [];
  for (const field of config.fields) {
    values.push(coerceValue(field.type, formData.get(field.name)));
    setClauses.push(`${field.name} = $${values.length}`);
  }
  values.push(id);

  await adminPool.query(
    `UPDATE ${config.table} SET ${setClauses.join(", ")} WHERE ${config.idField} = $${values.length}`,
    values,
  );
}

export async function deleteRow(table: string, id: string): Promise<void> {
  const config = requireConfig(table);
  await adminPool.query(`DELETE FROM ${config.table} WHERE ${config.idField} = $1`, [id]);
}

export { ADMIN_TABLES, getTableConfig };
