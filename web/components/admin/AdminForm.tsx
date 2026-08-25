import type { CSSProperties } from "react";
import type { AdminFieldConfig } from "@/lib/admin/schema";
import { ImageUploadField } from "./ImageUploadField";

const inputStyle: CSSProperties = {
  width: "100%",
  padding: 8,
  border: "1px solid #ccc",
  borderRadius: 4,
  boxSizing: "border-box",
};

const buttonStyle: CSSProperties = {
  alignSelf: "flex-start",
  padding: "8px 16px",
  border: "1px solid #333",
  borderRadius: 4,
  background: "#f5f5f5",
  cursor: "pointer",
};

export function AdminForm({
  fields,
  defaultValues,
  action,
  submitLabel,
}: {
  fields: AdminFieldConfig[];
  defaultValues: Record<string, unknown>;
  action: (formData: FormData) => Promise<void>;
  submitLabel: string;
}) {
  return (
    <form action={action} style={{ display: "flex", flexDirection: "column", gap: 16, maxWidth: 640 }}>
      {fields.map((field) => {
        const value = defaultValues[field.name];
        return (
          <div key={field.name}>
            <label style={{ display: "block", marginBottom: 4, fontWeight: 600 }}>
              {field.label}
              {field.required && " *"}
            </label>
            {field.helpText && (
              <p style={{ fontSize: 12, color: "#777", margin: "0 0 4px" }}>{field.helpText}</p>
            )}
            {field.type === "textarea" && (
              <textarea
                name={field.name}
                defaultValue={typeof value === "string" ? value : ""}
                required={field.required}
                rows={5}
                style={{ ...inputStyle, fontFamily: "inherit" }}
              />
            )}
            {field.type === "boolean" && (
              <input type="checkbox" name={field.name} defaultChecked={Boolean(value)} style={{ width: 18, height: 18 }} />
            )}
            {field.type === "image" && (
              <ImageUploadField name={field.name} defaultValue={typeof value === "string" ? value : null} />
            )}
            {field.type === "text" && (
              <input
                type="text"
                name={field.name}
                defaultValue={typeof value === "string" ? value : ""}
                required={field.required}
                style={inputStyle}
              />
            )}
            {field.type === "integer" && (
              <input
                type="number"
                name={field.name}
                defaultValue={typeof value === "number" ? value : ""}
                required={field.required}
                style={inputStyle}
              />
            )}
            {field.type === "date" && (
              <input
                type="date"
                name={field.name}
                defaultValue={value ? String(value).slice(0, 10) : ""}
                required={field.required}
                style={inputStyle}
              />
            )}
            {field.type === "month" && (
              <input
                type="month"
                name={field.name}
                defaultValue={value ? String(value).slice(0, 7) : ""}
                required={field.required}
                style={inputStyle}
              />
            )}
          </div>
        );
      })}
      <button type="submit" style={buttonStyle}>
        {submitLabel}
      </button>
    </form>
  );
}
