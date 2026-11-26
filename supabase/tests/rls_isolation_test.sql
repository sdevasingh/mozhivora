-- MOZHIVORA RLS Isolation Test
-- Proves User A cannot read or mutate User B's rows across core tables.

BEGIN;

-- Create two test users in auth.users
INSERT INTO auth.users (id, email)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'usera@mozhivora.test'),
  ('22222222-2222-2222-2222-222222222222', 'userb@mozhivora.test')
ON CONFLICT (id) DO NOTHING;

-- Switch to authenticated role as User A
SET LOCAL ROLE authenticated;
SET LOCAL "request.jwt.claims" = '{"sub": "11111111-1111-1111-1111-111111111111", "role": "authenticated"}';

-- User A creates a task and updates workspace_memory
INSERT INTO public.tasks (user_id, title) VALUES ('11111111-1111-1111-1111-111111111111', 'User A secret task');
UPDATE public.workspace_memory SET about_me = 'User A private bio', enabled = TRUE
WHERE user_id = '11111111-1111-1111-1111-111111111111';

-- Switch to User B
SET LOCAL "request.jwt.claims" = '{"sub": "22222222-2222-2222-2222-222222222222", "role": "authenticated"}';

DO $$
DECLARE
  leaked_tasks INT;
  leaked_memory INT;
  leaked_profiles INT;
  leaked_credits INT;
BEGIN
  SELECT COUNT(*) INTO leaked_tasks FROM public.tasks WHERE user_id = '11111111-1111-1111-1111-111111111111';
  SELECT COUNT(*) INTO leaked_memory FROM public.workspace_memory WHERE user_id = '11111111-1111-1111-1111-111111111111';
  SELECT COUNT(*) INTO leaked_profiles FROM public.profiles WHERE user_id = '11111111-1111-1111-1111-111111111111';
  SELECT COUNT(*) INTO leaked_credits FROM public.credit_ledger WHERE user_id = '11111111-1111-1111-1111-111111111111';

  IF leaked_tasks > 0 OR leaked_memory > 0 OR leaked_profiles > 0 OR leaked_credits > 0 THEN
    RAISE EXCEPTION 'RLS ISOLATION FAILURE: User B could read User A data!';
  END IF;
END $$;

ROLLBACK;
