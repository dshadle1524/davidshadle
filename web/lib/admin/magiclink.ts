import { importSPKI, jwtVerify } from "jose";

function baseUrl(): string {
  const url = process.env.MAGICLINK_BASE_URL;
  if (!url) throw new Error("MAGICLINK_BASE_URL is not set");
  return url;
}

function tenantId(): string {
  const id = process.env.MAGICLINK_TENANT_ID;
  if (!id) throw new Error("MAGICLINK_TENANT_ID is not set");
  return id;
}

function publicKeyPem(): string {
  const pem = process.env.MAGICLINK_PUBLIC_KEY_PEM;
  if (!pem) throw new Error("MAGICLINK_PUBLIC_KEY_PEM is not set");
  return pem.includes("\\n") ? pem.replace(/\\n/g, "\n") : pem;
}

export async function sendAdminLoginCode(email: string): Promise<void> {
  const res = await fetch(`${baseUrl()}/api/tenants/${tenantId()}/send-code`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email }),
  });
  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`Failed to send login code: ${res.status} ${text}`);
  }
}

export async function verifyAdminLoginCode(email: string, code: string): Promise<string> {
  const res = await fetch(`${baseUrl()}/api/tenants/${tenantId()}/verify-code`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, code }),
  });
  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`Invalid or expired code: ${res.status} ${text}`);
  }
  const data = await res.json();
  const jwt = data.jwt ?? data.token;
  if (!jwt) throw new Error("verify-code response did not include a token");
  return jwt;
}

export async function verifyAdminMagicLinkJwt(token: string): Promise<{ email: string }> {
  const key = await importSPKI(publicKeyPem(), "RS256");
  const { payload } = await jwtVerify(token, key, { clockTolerance: 60 });

  if (payload.tenant_id && payload.tenant_id !== tenantId()) {
    throw new Error("JWT tenant_id does not match the admin tenant");
  }
  const email = typeof payload.email === "string" ? payload.email : undefined;
  if (!email) throw new Error("JWT did not contain an email claim");
  return { email };
}
