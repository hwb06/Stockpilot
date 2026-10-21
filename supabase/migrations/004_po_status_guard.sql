-- Valid transitions: draft -> ordered|cancelled, ordered -> cancelled|received.
-- 'received' is only allowed from inside receive_purchase_order().
create or replace function public.guard_po_status()
returns trigger language plpgsql set search_path = public as $$
begin
  if new.status is distinct from old.status then
    if not (
      (old.status = 'draft'   and new.status in ('ordered', 'cancelled')) or
      (old.status = 'ordered' and new.status in ('cancelled', 'received'))
    ) then
      raise exception 'Invalid status change: % to %', old.status, new.status;
    end if;

    if new.status = 'received'
       and coalesce(current_setting('app.receiving', true), '') <> 'on' then
      raise exception 'Orders can only be received through receive_purchase_order()';
    end if;
  end if;
  return new;
end $$;

drop trigger if exists trg_po_status_guard on public.purchase_orders;
create trigger trg_po_status_guard
  before update on public.purchase_orders
  for each row execute function public.guard_po_status();

-- Same function as before, plus the transaction-local flag that lets it
-- pass the guard above.
create or replace function public.receive_purchase_order(p_po_id uuid)
returns public.purchase_orders
language plpgsql security definer set search_path = public as $$
declare
  v_po    public.purchase_orders;
  v_item  record;
  v_stock integer;
begin
  select * into v_po
    from purchase_orders
   where id = p_po_id and user_id = auth.uid()
   for update;

  if not found then
    raise exception 'Purchase order not found';
  end if;
  if v_po.status <> 'ordered' then
    raise exception 'Only ordered purchase orders can be received (current status: %)', v_po.status;
  end if;

  for v_item in
    select product_id, quantity, unit_cost
      from purchase_order_items where po_id = p_po_id
  loop
    update products
       set stock_qty = stock_qty + v_item.quantity,
           cost_price = v_item.unit_cost
     where id = v_item.product_id and user_id = auth.uid()
     returning stock_qty into v_stock;

    insert into stock_movements
      (user_id, product_id, quantity_change, stock_after, type, reference_id, note)
    values
      (auth.uid(), v_item.product_id, v_item.quantity, v_stock,
       'purchase', p_po_id, 'Received via ' || v_po.po_number);
  end loop;

  perform set_config('app.receiving', 'on', true);  -- valid only for this transaction

  update purchase_orders
     set status = 'received', received_at = now()
   where id = p_po_id
   returning * into v_po;

  return v_po;
end $$;