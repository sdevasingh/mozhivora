-- MOZHIVORA Phase 3: Atomic Credit Reservation, Commit & Refund RPCs

CREATE OR REPLACE FUNCTION public.reserve_credits(
  p_user_id UUID,
  p_amount INT,
  p_reason TEXT,
  p_reference_id UUID DEFAULT gen_random_uuid()
)
RETURNS TABLE(reserved BOOLEAN, balance_after INT, ledger_id UUID)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_current INT;
  v_new INT;
  v_ledger_id UUID;
BEGIN
  IF p_amount <= 0 THEN
    RAISE EXCEPTION 'Credit reservation amount must be positive';
  END IF;

  -- Serialize reservations per user via advisory transaction lock
  PERFORM pg_advisory_xact_lock(hashtext(p_user_id::text));

  SELECT COALESCE(
    (SELECT cl.balance_after
     FROM public.credit_ledger cl
     WHERE cl.user_id = p_user_id
     ORDER BY cl.created_at DESC
     LIMIT 1),
    0
  ) INTO v_current;

  IF v_current < p_amount THEN
    RETURN QUERY SELECT FALSE, v_current, NULL::UUID;
    RETURN;
  END IF;

  v_new := v_current - p_amount;

  INSERT INTO public.credit_ledger (user_id, delta, balance_after, reason, reference_id)
  VALUES (p_user_id, -p_amount, v_new, p_reason, p_reference_id)
  RETURNING id INTO v_ledger_id;

  RETURN QUERY SELECT TRUE, v_new, v_ledger_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.refund_credits(
  p_user_id UUID,
  p_amount INT,
  p_reason TEXT,
  p_reference_id UUID
)
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_current INT;
  v_new INT;
BEGIN
  IF p_amount <= 0 THEN
    RAISE EXCEPTION 'Refund amount must be positive';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtext(p_user_id::text));

  SELECT COALESCE(
    (SELECT cl.balance_after
     FROM public.credit_ledger cl
     WHERE cl.user_id = p_user_id
     ORDER BY cl.created_at DESC
     LIMIT 1),
    0
  ) INTO v_current;

  v_new := v_current + p_amount;

  INSERT INTO public.credit_ledger (user_id, delta, balance_after, reason, reference_id)
  VALUES (p_user_id, p_amount, v_new, p_reason, p_reference_id);

  RETURN v_new;
END;
$$;
