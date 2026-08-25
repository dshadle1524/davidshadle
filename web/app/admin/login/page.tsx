"use client";

import { useState, type CSSProperties } from "react";
import { useRouter } from "next/navigation";

const inputStyle: CSSProperties = {
  display: "block",
  width: "100%",
  padding: 8,
  marginTop: 4,
  border: "1px solid #ccc",
  borderRadius: 4,
  boxSizing: "border-box",
};

const buttonStyle: CSSProperties = {
  padding: "8px 16px",
  border: "1px solid #333",
  borderRadius: 4,
  background: "#f5f5f5",
  cursor: "pointer",
};

export default function AdminLoginPage() {
  const router = useRouter();
  const [step, setStep] = useState<"email" | "code">("email");
  const [email, setEmail] = useState("");
  const [code, setCode] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  async function sendCode(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setBusy(true);
    try {
      const res = await fetch("/api/admin/auth/send-code", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error ?? "Failed to send code");
      setStep("code");
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setBusy(false);
    }
  }

  async function verifyCode(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setBusy(true);
    try {
      const res = await fetch("/api/admin/auth/verify", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, code }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error ?? "Invalid code");
      router.push("/admin");
      router.refresh();
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 360, margin: "80px auto", fontFamily: "sans-serif" }}>
      <h1 style={{ fontSize: 20, marginBottom: 24 }}>Admin login</h1>

      {step === "email" && (
        <form onSubmit={sendCode} style={{ display: "flex", flexDirection: "column", gap: 12 }}>
          <label>
            Email
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              style={inputStyle}
            />
          </label>
          <button type="submit" disabled={busy} style={buttonStyle}>
            {busy ? "Sending…" : "Send code"}
          </button>
        </form>
      )}

      {step === "code" && (
        <form onSubmit={verifyCode} style={{ display: "flex", flexDirection: "column", gap: 12 }}>
          <p style={{ fontSize: 14, color: "#555" }}>Code sent to {email}.</p>
          <label>
            Code
            <input
              type="text"
              value={code}
              onChange={(e) => setCode(e.target.value)}
              required
              style={inputStyle}
            />
          </label>
          <button type="submit" disabled={busy} style={buttonStyle}>
            {busy ? "Verifying…" : "Verify"}
          </button>
        </form>
      )}

      {error && <p style={{ color: "crimson", marginTop: 16 }}>{error}</p>}
    </div>
  );
}
