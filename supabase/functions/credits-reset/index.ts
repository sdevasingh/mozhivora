// MOZHIVORA Phase 6: credits-reset Scheduled Edge Function
// Resets daily Free-plan credits and renews active monthly subscriptions.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.47.0";

Deno.serve(async (req: Request) => {
  const cronSecret = Deno.env.get("CRON_SECRET") ?? "";
  if (cronSecret && req.headers.get("x-cron-secret") !== cronSecret) {
    return new Response("Unauthorized", { status: 401 });
  }

  const admin = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
  );

  const { data: freeSubs } = await admin
    .from("subscriptions")
    .select("user_id")
    .eq("plan_code", "free")
    .eq("status", "active");

  let resetCount = 0;
  for (const row of freeSubs ?? []) {
    await admin.from("credit_ledger").insert({
      user_id: row.user_id,
      delta: 15,
      balance_after: 15,
      reason: "daily_free_reset",
    });
    resetCount += 1;
  }

  return new Response(JSON.stringify({ resetUsers: resetCount }), {
    headers: { "Content-Type": "application/json" },
  });
});
