# MOZHIVORA Supabase Setup Guide

## 1. Local Development
1. Install the Supabase CLI (`npm install -g supabase` or `scoop install supabase`).
2. Start local Supabase:
   ```bash
   supabase start
   ```
3. Apply migrations & seed starter templates:
   ```bash
   supabase db reset
   ```
4. Run the RLS isolation test:
   ```bash
   psql "$SUPABASE_DB_URL" -f supabase/tests/rls_isolation_test.sql
   ```

## 2. Production / Staging
1. Link your Supabase project:
   ```bash
   supabase link --project-ref <your-project-ref>
   ```
2. Push migrations:
   ```bash
   supabase db push
   ```
3. Deploy Edge Functions & set server-side secrets (never in client):
   ```bash
   supabase secrets set GEMINI_API_KEY=<your-gemini-api-key>
   supabase functions deploy ai-gateway
   ```
4. Pass your public client config to Flutter via `--dart-define` (never hardcode keys):
   ```bash
   flutter run -d chrome \
     --dart-define=SUPABASE_URL=https://<project>.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
   ```
