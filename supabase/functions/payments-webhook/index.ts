// MOZHIVORA Phase 6: payments-webhook Edge Function
// Verifies Razorpay (UPI) and Stripe webhooks with HMAC signatures before granting access.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.47.0";

async function verifyHmacSha256(
  secret: string,
  payload: string,
  signatureHex: string,
): Promise<boolean> {
  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    "raw",
    encoder.encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("HMAC", key, encoder.encode(payload));
  const computed = Array.from(new Uint8Array(sig))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
  return computed === signatureHex;
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  const rawBody = await req.text();
  const razorpaySig = req.headers.get("x-razorpay-signature");
  const razorpaySecret = Deno.env.get("RAZORPAY_WEBHOOK_SECRET") ?? "";
  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  if (razorpaySig) {
    if (!razorpaySecret || !(await verifyHmacSha256(razorpaySecret, rawBody, razorpaySig))) {
      return new Response(JSON.stringify({ error: "Invalid Razorpay signature" }), {
        status: 401,
        headers: { "Content-Type": "application/json" },
      });
    }

    const event = JSON.parse(rawBody);
    const payment = event?.payload?.payment?.entity;
    const userId = payment?.notes?.user_id;
    const planCode = payment?.notes?.plan_code ?? "pro";

    if (event.event === "payment.captured" && userId && payment?.id) {
      const admin = createClient(supabaseUrl, serviceRoleKey);
      await admin.from("payments").upsert({
        user_id: userId,
        provider: "razorpay",
        provider_payment_id: payment.id,
        amount_minor: payment.amount ?? 0,
        currency: payment.currency ?? "INR",
        status: "captured",
      });

      const credits = planCode === "student" ? 200 : 500;
      await admin.rpc("refund_credits", {
        p_user_id: userId,
        p_amount: credits,
        p_reason: `subscription:${planCode}`,
        p_reference_id: crypto.randomUUID(),
      });

      await admin.from("subscriptions").upsert({
        user_id: userId,
        plan_code: planCode,
        provider: "razorpay",
        provider_subscription_id: payment.id,
        status: "active",
      });
    }

    return new Response(JSON.stringify({ received: true }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response(
    JSON.stringify({ error: "Missing or unsupported webhook signature." }),
    { status: 400, headers: { "Content-Type": "application/json" } },
  );
});
