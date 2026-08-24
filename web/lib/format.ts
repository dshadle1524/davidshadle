const MONTHS = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
];

export function formatMonthYear(date: Date): string {
  return `${MONTHS[date.getUTCMonth()]} ${date.getUTCFullYear()}`;
}

export function formatDateRange(start: Date, end: Date | null): string {
  const startLabel = formatMonthYear(start);
  const endLabel = end ? formatMonthYear(end) : "Present";
  return `${startLabel} – ${endLabel}`;
}
