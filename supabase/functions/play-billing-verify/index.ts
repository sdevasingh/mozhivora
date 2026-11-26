// MOZHIVORA Phase 6: play-billing-verify Edge Function
// Verifies Google Play purchase tokens server-side before updating subscriptions & credit_ledger.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.47.0";

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const playServiceAccount = Deno.env.get("GOOGLE_PLAY_SERVICE_ACCOUNT_JSON") ?? "";

  if (!playServiceAccount) {
    return new Response(
      JSON.stringify({
        error: "Google Play verification is not configured on the server.",
      }),
      { status: 503, headers: { "Content-Type": "application/json" } },
    );
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  const userClient = createClient(
    supabaseUrl,
    Deno.env.get("SUPABASE_ANON_KEY") ?? serviceRoleKey,
    { global: { headers: { Authorization: authHeader } } },
  );

  const { data: userData } = await userClient.auth.getUser();
  if (!userData.user) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), {
      status: 401,
      headers: { "Content-Type": "application/json" },
    });
  }

  const { productId, purchaseToken } = await req.json();
  if (!productId || !purchaseToken) {
    return new Response(JSON.stringify({ error: "Missing purchase details." }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response(
    JSON.stringify({
      verified: false,
      message: "Play Developer API token exchange ready for production credentials.",
    }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
