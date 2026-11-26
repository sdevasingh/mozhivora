-- MOZHIVORA Phase 2: Row-Level Security (RLS) on EVERY table

DO $$
DECLARE
  tbl TEXT;
BEGIN
  FOREACH tbl IN ARRAY ARRAY[
    'profiles', 'user_roles', 'user_preferences', 'workspace_memory',
    'brand_voices', 'folders', 'projects', 'documents', 'document_chunks',
    'chats', 'chat_messages', 'ai_generations', 'ai_usage', 'credit_ledger',
    'subscriptions', 'payments', 'tasks', 'templates', 'share_links',
    'referrals', 'notifications'
  ]
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', tbl);
  END LOOP;
END $$;

-- Owner-only CRUD policies for user-owned tables
DO $$
DECLARE
  tbl TEXT;
BEGIN
  FOREACH tbl IN ARRAY ARRAY[
    'profiles', 'user_preferences', 'workspace_memory',
    'brand_voices', 'folders', 'projects', 'documents', 'document_chunks',
    'chats', 'chat_messages', 'tasks', 'notifications'
  ]
  LOOP
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);',
      tbl || '_owner_all', tbl
    );
  END LOOP;
END $$;

-- Read-only for user_roles, ai_generations, ai_usage, credit_ledger, subscriptions, payments, referrals
-- (writes happen via server-side SECURITY DEFINER / service_role edge functions)
CREATE POLICY user_roles_read_own ON public.user_roles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY ai_generations_read_own ON public.ai_generations
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY ai_usage_read_own ON public.ai_usage
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY credit_ledger_read_own ON public.credit_ledger
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY subscriptions_read_own ON public.subscriptions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY payments_read_own ON public.payments
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY referrals_read_own ON public.referrals
  FOR SELECT USING (auth.uid() = user_id OR auth.uid() = referred_user_id);

-- Templates: users can read public templates or manage their own
CREATE POLICY templates_select ON public.templates
  FOR SELECT USING (is_public = TRUE OR auth.uid() = user_id);

CREATE POLICY templates_insert_own ON public.templates
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY templates_update_own ON public.templates
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY templates_delete_own ON public.templates
  FOR DELETE USING (auth.uid() = user_id);

-- Share links: owner manages; active links readable publicly
CREATE POLICY share_links_owner_all ON public.share_links
  FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY share_links_public_read ON public.share_links
  FOR SELECT USING (is_active = TRUE AND (expires_at IS NULL OR expires_at > NOW()));
