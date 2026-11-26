// MOZHIVORA Phase 4: embed-document Edge Function
// Chunks document pages, generates Gemini embeddings, and stores in document_chunks.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.47.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface EmbedRequest {
  documentId: string;
  pages: Array<{ pageNumber: number; text: string }>;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const geminiApiKey = Deno.env.get("GEMINI_API_KEY") ?? "";

  if (!geminiApiKey) {
    return new Response(
      JSON.stringify({ error: "Missing GEMINI_API_KEY on server." }),
      { status: 503, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  const userClient = createClient(
    supabaseUrl,
    Deno.env.get("SUPABASE_ANON_KEY") ?? serviceRoleKey,
    { global: { headers: { Authorization: authHeader } } },
  );
  const adminClient = createClient(supabaseUrl, serviceRoleKey);

  const { data: userData, error: authErr } = await userClient.auth.getUser();
  if (authErr || !userData.user) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), {
      status: 401,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  const body = (await req.json()) as EmbedRequest;
  if (!body.documentId || !Array.isArray(body.pages) || body.pages.length === 0) {
    return new Response(JSON.stringify({ error: "Invalid document pages." }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  let inserted = 0;
  for (const page of body.pages) {
    const clean = page.text.trim();
    if (!clean) continue;

    const embRes = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent?key=${geminiApiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          content: { parts: [{ text: clean.slice(0, 8000) }] },
        }),
      },
    );

    if (!embRes.ok) continue;
    const embJson = await embRes.json();
    const values = embJson?.embedding?.values;
    if (!Array.isArray(values)) continue;

    await adminClient.from("document_chunks").insert({
      user_id: userData.user.id,
      document_id: body.documentId,
      page_number: page.pageNumber,
      chunk_index: inserted,
      content: clean.slice(0, 4000),
      embedding: values,
    });
    inserted += 1;
  }

  await adminClient
    .from("documents")
    .update({ status: "indexed", page_count: body.pages.length })
    .eq("id", body.documentId)
    .eq("user_id", userData.user.id);

  return new Response(JSON.stringify({ indexedChunks: inserted }), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
});
