export interface AdminFieldConfig {
  name: string;
  label: string;
  type: "text" | "textarea" | "boolean" | "integer" | "date" | "month" | "image";
  required?: boolean;
  helpText?: string;
}

export interface AdminTableConfig {
  table: string;
  view: string;
  label: string;
  idField: string;
  /** Field whose value seeds a generated slug ID on create. Omit to disable "New". */
  slugSourceField?: string;
  sortField?: string;
  listColumns: string[];
  fields: AdminFieldConfig[];
}

export const ADMIN_TABLES: AdminTableConfig[] = [
  {
    table: "site_settings",
    view: "vw_site_settings",
    label: "Site Settings",
    idField: "site_setting_id",
    listColumns: ["site_domain", "contact_email"],
    fields: [
      { name: "contact_email", label: "Contact Email", type: "text", required: true },
      { name: "contact_phone", label: "Contact Phone", type: "text" },
      { name: "site_domain", label: "Site Domain", type: "text", required: true },
      { name: "portfolio_company_count", label: "Portfolio Company Count", type: "text", required: true },
      { name: "self_description_line", label: "Self Description Line", type: "textarea", required: true },
      { name: "positioning_statement", label: "Positioning Statement", type: "textarea", required: true },
      { name: "hero_headline", label: "Hero Headline", type: "textarea", required: true },
      { name: "hero_subheadline", label: "Hero Subheadline", type: "textarea", required: true },
      { name: "banyan_title", label: "Banyan Title", type: "text", required: true },
    ],
  },
  {
    table: "currently_items",
    view: "vw_currently_items",
    label: "Currently",
    idField: "currently_item_id",
    slugSourceField: "title",
    sortField: "sort_order",
    listColumns: ["title", "sort_order"],
    fields: [
      { name: "title", label: "Title", type: "text", required: true },
      { name: "body_text", label: "Body Text", type: "textarea", required: true },
      { name: "sort_order", label: "Sort Order", type: "integer", required: true },
    ],
  },
  {
    table: "bio_variants",
    view: "vw_bio_variants",
    label: "Bio Variants",
    idField: "bio_variant_id",
    slugSourceField: "label",
    sortField: "sort_order",
    listColumns: ["label", "usage_context"],
    fields: [
      { name: "label", label: "Label", type: "text", required: true },
      { name: "usage_context", label: "Usage Context", type: "textarea", required: true },
      { name: "body_text", label: "Body Text", type: "textarea", required: true, helpText: "Paragraph breaks are two newlines." },
      { name: "sort_order", label: "Sort Order", type: "integer", required: true },
    ],
  },
  {
    table: "how_i_work_sections",
    view: "vw_how_i_work_sections",
    label: "How I Work",
    idField: "how_i_work_section_id",
    slugSourceField: "heading",
    sortField: "sort_order",
    listColumns: ["heading", "sort_order"],
    fields: [
      { name: "heading", label: "Heading", type: "text", required: true },
      { name: "body_text", label: "Body Text", type: "textarea", required: true, helpText: "Paragraph breaks are two newlines." },
      { name: "short_body_text", label: "Short Body Text", type: "textarea" },
      { name: "sort_order", label: "Sort Order", type: "integer", required: true },
    ],
  },
  {
    table: "proof_points",
    view: "vw_proof_points",
    label: "Projects",
    idField: "proof_point_id",
    slugSourceField: "title",
    sortField: "sort_order",
    listColumns: ["title", "client_or_category", "status_label", "featured_on_work_page"],
    fields: [
      { name: "title", label: "Title", type: "text", required: true },
      { name: "problem_text", label: "Problem", type: "textarea", required: true },
      { name: "action_text", label: "Action", type: "textarea", required: true },
      { name: "outcome_text", label: "Outcome", type: "textarea", required: true },
      { name: "attribution_note", label: "Attribution Note", type: "text" },
      { name: "register_note", label: "Register Note", type: "textarea", helpText: "Internal guidance only — not published copy." },
      { name: "client_or_category", label: "Client / Category", type: "text" },
      { name: "status_label", label: "Status Label", type: "text" },
      { name: "featured_on_work_page", label: "Featured on Work Page", type: "boolean" },
      { name: "featured_in_resume_selected_work", label: "Featured in Resume", type: "boolean" },
      { name: "image_url", label: "Image", type: "image" },
      { name: "sort_order", label: "Sort Order", type: "integer", required: true },
    ],
  },
  {
    table: "job_entries",
    view: "vw_job_entries",
    label: "Job Entries",
    idField: "job_entries_id",
    slugSourceField: "company",
    sortField: "sort_order",
    listColumns: ["company", "job_title", "start_date", "end_date"],
    fields: [
      { name: "job_entry_id", label: "Slug ID", type: "text", required: true, helpText: "Stable identity, e.g. 'banyan-2023'." },
      { name: "company", label: "Company", type: "text", required: true },
      { name: "job_title", label: "Job Title", type: "text" },
      { name: "start_date", label: "Start Date", type: "month", required: true },
      { name: "end_date", label: "End Date", type: "month" },
      { name: "is_current", label: "Is Current", type: "boolean" },
      { name: "display_group_key", label: "Display Group Key", type: "text" },
      { name: "summary_text_variant_a", label: "Summary (Variant A)", type: "textarea" },
      { name: "summary_text_variant_b", label: "Summary (Variant B)", type: "textarea" },
      { name: "compressed_line", label: "Compressed Line", type: "text" },
      { name: "include_in_variant_a", label: "Include in Variant A", type: "boolean" },
      { name: "include_in_variant_b", label: "Include in Variant B", type: "boolean" },
      { name: "is_pre2019", label: "Is Pre-2019", type: "boolean" },
      { name: "sort_order", label: "Sort Order", type: "integer", required: true },
    ],
  },
  {
    table: "resume_variants",
    view: "vw_resume_variants",
    label: "Resume Variants",
    idField: "resume_variant_id",
    slugSourceField: "label",
    listColumns: ["label", "published_on_site"],
    fields: [
      { name: "label", label: "Label", type: "text", required: true },
      { name: "audience_description", label: "Audience Description", type: "textarea", required: true },
      { name: "summary_text", label: "Summary Text", type: "textarea", required: true, helpText: "Paragraph breaks are two newlines." },
      { name: "published_on_site", label: "Published on Site", type: "boolean" },
    ],
  },
  {
    table: "resume_list_items",
    view: "vw_resume_list_items",
    label: "Resume List Items",
    idField: "resume_list_item_id",
    slugSourceField: "label",
    sortField: "sort_order",
    listColumns: ["category", "label", "sort_order"],
    fields: [
      { name: "category", label: "Category", type: "text", required: true, helpText: "'Methods' or 'Technical'." },
      { name: "label", label: "Label", type: "text", required: true },
      { name: "sort_order", label: "Sort Order", type: "integer", required: true },
    ],
  },
  {
    table: "education_entries",
    view: "vw_education_entries",
    label: "Education",
    idField: "education_entries_id",
    slugSourceField: "institution",
    listColumns: ["institution", "degree"],
    fields: [
      { name: "education_entry_id", label: "Slug ID", type: "text", required: true },
      { name: "institution", label: "Institution", type: "text", required: true },
      { name: "degree", label: "Degree", type: "text", required: true },
      { name: "field_of_study", label: "Field of Study", type: "text" },
      { name: "grad_year", label: "Grad Year", type: "integer" },
    ],
  },
];

export function getTableConfig(table: string): AdminTableConfig | undefined {
  return ADMIN_TABLES.find((t) => t.table === table);
}
