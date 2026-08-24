import type { JobEntry } from "./content";

export interface DisplayJobEntry {
  key: string;
  company: string;
  jobTitle: string | null;
  startDate: Date;
  endDate: Date | null;
  isCurrent: boolean;
  summaryText: string | null;
  compressedLine: string | null;
  sortOrder: number;
}

/**
 * Variant A collapses rows sharing display_group_key into one entry
 * (e.g. the two Power Automate roles), using the min start / max end
 * of the group and whichever row carries non-null summary text.
 */
export function groupJobEntriesForVariantA(entries: JobEntry[]): DisplayJobEntry[] {
  const groups = new Map<string, JobEntry[]>();
  const order: string[] = [];

  for (const entry of entries) {
    const key = entry.display_group_key ?? entry.job_entry_id;
    if (!groups.has(key)) {
      groups.set(key, []);
      order.push(key);
    }
    groups.get(key)!.push(entry);
  }

  return order.map((key) => {
    const rows = groups.get(key)!;
    const starts = rows.map((r) => r.start_date.getTime());
    const ends = rows.map((r) => (r.end_date ? r.end_date.getTime() : null));
    const isCurrent = rows.some((r) => r.is_current);
    const summaryRow = rows.find((r) => r.summary_text_variant_a);

    return {
      key,
      company: rows[0].company,
      jobTitle: rows[0].job_title,
      startDate: new Date(Math.min(...starts)),
      endDate: isCurrent || ends.some((e) => e === null) ? null : new Date(Math.max(...(ends as number[]))),
      isCurrent,
      summaryText: summaryRow?.summary_text_variant_a ?? null,
      compressedLine: rows[0].compressed_line,
      sortOrder: Math.min(...rows.map((r) => r.sort_order)),
    };
  });
}
