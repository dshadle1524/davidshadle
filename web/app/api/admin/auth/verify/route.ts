import { NextRequest, NextResponse } from "next/server";
import { verifyAdminLoginCode, verifyAdminMagicLinkJwt } from "@/lib/admin/magiclink";
import { createSessionToken, SESSION_COOKIE_NAME, SESSION_COOKIE_MAX_AGE } from "@/lib/admin/session";

export async function POST(req: NextRequest) {
  const { email, code } = await req.json();
  if (typeof email !== "string" || typeof code !== "string") {
    return NextResponse.json({ error: "email and code are required" }, { status: 400 });
  }

  let magicLinkJwt: string;
  try {
    magicLinkJwt = await verifyAdminLoginCode(email, code);
  } catch (err) {
    return NextResponse.json({ error: (err as Error).message }, { status: 401 });
  }

  let verifiedEmail: string;
  try {
    ({ email: verifiedEmail } = await verifyAdminMagicLinkJwt(magicLinkJwt));
  } catch (err) {
    return NextResponse.json({ error: (err as Error).message }, { status: 401 });
  }

  const adminEmail = process.env.ADMIN_EMAIL;
  if (!adminEmail || verifiedEmail.toLowerCase() !== adminEmail.toLowerCase()) {
    return NextResponse.json({ error: "This email is not authorized for admin access." }, { status: 403 });
  }

  const sessionToken = await createSessionToken(verifiedEmail);
  const res = NextResponse.json({ ok: true });
  res.cookies.set(SESSION_COOKIE_NAME, sessionToken, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    path: "/",
    maxAge: SESSION_COOKIE_MAX_AGE,
  });
  return res;
}
