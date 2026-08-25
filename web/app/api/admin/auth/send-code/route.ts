import { NextRequest, NextResponse } from "next/server";
import { sendAdminLoginCode } from "@/lib/admin/magiclink";

export async function POST(req: NextRequest) {
  const { email } = await req.json();
  if (typeof email !== "string" || !email) {
    return NextResponse.json({ error: "email is required" }, { status: 400 });
  }

  try {
    await sendAdminLoginCode(email);
  } catch (err) {
    return NextResponse.json({ error: (err as Error).message }, { status: 502 });
  }

  return NextResponse.json({ ok: true });
}
