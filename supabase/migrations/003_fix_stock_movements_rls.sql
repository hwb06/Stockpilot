-- stock_movements has no INSERT policy on purpose (clients must not be able
-- to forge history). The trusted writers (trigger + RPCs) run as the function
-- owner instead, and enforce ownership themselves with auth.uid().

alter function public.log_initial_stock()
  security definer set search_path = public;

alter function public.receive_purchase_order(uuid)
  security definer set search_path = public;

alter function public.adjust_stock(uuid, integer, text)
  security definer set search_path = public;

-- Definer functions must not be callable by anonymous users.
revoke execute on function public.log_initial_stock() from public, anon, authenticated;
revoke execute on function public.receive_purchase_order(uuid) from public, anon;
revoke execute on function public.adjust_stock(uuid, integer, text) from public, anon;
grant  execute on function public.receive_purchase_order(uuid) to authenticated;
grant  execute on function public.adjust_stock(uuid, integer, text) to authenticated;
