-- ---------- 1. TABLES -------------------------------------------------

create table public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text,
  avatar_url  text,
  created_at  timestamptz not null default now()
);

create table public.categories (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name        text not null,
  created_at  timestamptz not null default now(),
  unique (user_id, name)
);

create table public.products (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null default auth.uid() references auth.users(id) on delete cascade,
  category_id  uuid references public.categories(id) on delete set null,
  name         text not null,
  sku          text not null,
  description  text,
  price        numeric(12,2) not null default 0 check (price >= 0),
  cost_price   numeric(12,2) not null default 0 check (cost_price >= 0),
  stock_qty    integer not null default 0 check (stock_qty >= 0),
  min_stock    integer not null default 5 check (min_stock >= 0),
  image_url    text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  unique (user_id, sku)
);

create table public.suppliers (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name        text not null,
  email       text,
  phone       text,
  address     text,
  created_at  timestamptz not null default now()
);

create sequence public.po_number_seq start 1;

create table public.purchase_orders (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null default auth.uid() references auth.users(id) on delete cascade,
  supplier_id   uuid not null references public.suppliers(id) on delete restrict,
  po_number     text not null unique
                default ('PO-' || lpad(nextval('public.po_number_seq')::text, 5, '0')),
  status        text not null default 'draft'
                check (status in ('draft','ordered','received','cancelled')),
  total_amount  numeric(14,2) not null default 0,
  notes         text,
  order_date    timestamptz not null default now(),
  received_at   timestamptz,
  created_at    timestamptz not null default now()
);

create table public.purchase_order_items (
  id          uuid primary key default gen_random_uuid(),
  po_id       uuid not null references public.purchase_orders(id) on delete cascade,
  product_id  uuid not null references public.products(id) on delete restrict,
  quantity    integer not null check (quantity > 0),
  unit_cost   numeric(12,2) not null check (unit_cost >= 0),
  line_total  numeric(14,2) generated always as (quantity * unit_cost) stored
);

create table public.stock_movements (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null default auth.uid() references auth.users(id) on delete cascade,
  product_id       uuid not null references public.products(id) on delete cascade,
  quantity_change  integer not null check (quantity_change <> 0),
  stock_after      integer not null,
  type             text not null check (type in ('initial','purchase','adjustment')),
  reference_id     uuid,           -- e.g. purchase_orders.id
  note             text,
  created_at       timestamptz not null default now()
);

-- ---------- 2. INDEXES ------------------------------------------------

create index idx_products_user_name   on public.products (user_id, name);
create index idx_products_category    on public.products (category_id);
create index idx_suppliers_user_name  on public.suppliers (user_id, name);
create index idx_po_user_status       on public.purchase_orders (user_id, status);
create index idx_po_supplier          on public.purchase_orders (supplier_id);
create index idx_poi_po               on public.purchase_order_items (po_id);
create index idx_poi_product          on public.purchase_order_items (product_id);
create index idx_movements_product    on public.stock_movements (product_id, created_at desc);
create index idx_movements_user_date  on public.stock_movements (user_id, created_at desc);

-- ---------- 3. TRIGGERS -----------------------------------------------

-- 3a. auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data ->> 'full_name');
  return new;
end $$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 3b. updated_at maintenance
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

create trigger trg_products_updated_at
  before update on public.products
  for each row execute function public.set_updated_at();

-- 3c. log opening stock when a product is created with stock > 0
create or replace function public.log_initial_stock()
returns trigger language plpgsql as $$
begin
  if new.stock_qty > 0 then
    insert into public.stock_movements
      (user_id, product_id, quantity_change, stock_after, type, note)
    values
      (new.user_id, new.id, new.stock_qty, new.stock_qty, 'initial', 'Opening stock');
  end if;
  return new;
end $$;

create trigger trg_products_initial_stock
  after insert on public.products
  for each row execute function public.log_initial_stock();

-- ---------- 4. ROW LEVEL SECURITY -------------------------------------

alter table public.profiles              enable row level security;
alter table public.categories            enable row level security;
alter table public.products              enable row level security;
alter table public.suppliers             enable row level security;
alter table public.purchase_orders       enable row level security;
alter table public.purchase_order_items  enable row level security;
alter table public.stock_movements       enable row level security;

-- profiles: own row only
create policy "profiles_select_own" on public.profiles
  for select using (id = auth.uid());
create policy "profiles_update_own" on public.profiles
  for update using (id = auth.uid()) with check (id = auth.uid());

-- user-owned tables: full CRUD on own rows
create policy "categories_own" on public.categories
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "products_own" on public.products
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "suppliers_own" on public.suppliers
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "purchase_orders_own" on public.purchase_orders
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- movements: read-only from client; written only by triggers/RPC
create policy "movements_select_own" on public.stock_movements
  for select using (user_id = auth.uid());

-- PO items: access derived from the parent PO
create policy "po_items_own" on public.purchase_order_items
  for all
  using (exists (select 1 from public.purchase_orders po
                 where po.id = po_id and po.user_id = auth.uid()))
  with check (exists (select 1 from public.purchase_orders po
                      where po.id = po_id and po.user_id = auth.uid()));

-- ---------- 5. RPC FUNCTIONS (business logic, atomic) -----------------
-- All are SECURITY INVOKER, so RLS still applies to every statement.

-- 5a. Create a PO + its items in ONE transaction.
-- p_items example: [{"product_id":"...","quantity":10,"unit_cost":25.5}]
create or replace function public.create_purchase_order(
  p_supplier_id uuid,
  p_items       jsonb,
  p_notes       text default null,
  p_status      text default 'draft'
) returns public.purchase_orders
language plpgsql security invoker set search_path = public as $$
declare
  v_po    public.purchase_orders;
  v_item  jsonb;
begin
  if p_status not in ('draft','ordered') then
    raise exception 'A new purchase order must be draft or ordered';
  end if;
  if p_items is null or jsonb_array_length(p_items) = 0 then
    raise exception 'A purchase order needs at least one item';
  end if;

  insert into purchase_orders (supplier_id, notes, status)
  values (p_supplier_id, p_notes, p_status)
  returning * into v_po;

  for v_item in select * from jsonb_array_elements(p_items) loop
    insert into purchase_order_items (po_id, product_id, quantity, unit_cost)
    values (
      v_po.id,
      (v_item ->> 'product_id')::uuid,
      (v_item ->> 'quantity')::int,
      (v_item ->> 'unit_cost')::numeric
    );
  end loop;

  update purchase_orders
     set total_amount = (select coalesce(sum(line_total), 0)
                           from purchase_order_items where po_id = v_po.id)
   where id = v_po.id
   returning * into v_po;

  return v_po;
end $$;

-- 5b. Receive a PO: stock up + movement log + status, all atomic.
create or replace function public.receive_purchase_order(p_po_id uuid)
returns public.purchase_orders
language plpgsql security invoker set search_path = public as $$
declare
  v_po    public.purchase_orders;
  v_item  record;
  v_stock integer;
begin
  -- Row lock: two devices clicking "Receive" cannot double-apply stock.
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

  update purchase_orders
     set status = 'received', received_at = now()
   where id = p_po_id
   returning * into v_po;

  return v_po;
end $$;

-- 5c. Manual stock adjustment (+/-) with a reason.
create or replace function public.adjust_stock(
  p_product_id uuid,
  p_change     integer,
  p_note       text default null
) returns public.products
language plpgsql security invoker set search_path = public as $$
declare
  v_product public.products;
begin
  if p_change = 0 then
    raise exception 'Adjustment cannot be zero';
  end if;

  update products
     set stock_qty = stock_qty + p_change
   where id = p_product_id and user_id = auth.uid()
   returning * into v_product;

  if not found then
    raise exception 'Product not found';
  end if;
  -- CHECK (stock_qty >= 0) rejects adjustments that would go negative.

  insert into stock_movements
    (user_id, product_id, quantity_change, stock_after, type, note)
  values
    (auth.uid(), p_product_id, p_change, v_product.stock_qty,
     'adjustment', coalesce(p_note, 'Manual adjustment'));

  return v_product;
end $$;

-- 5d. Dashboard numbers in one round trip.
create or replace function public.get_dashboard_stats()
returns jsonb
language sql stable security invoker set search_path = public as $$
  select jsonb_build_object(
    'total_products',   (select count(*) from products where user_id = auth.uid()),
    'total_suppliers',  (select count(*) from suppliers where user_id = auth.uid()),
    'stock_value',      (select coalesce(sum(stock_qty * cost_price), 0)
                           from products where user_id = auth.uid()),
    'low_stock_count',  (select count(*) from products
                          where user_id = auth.uid() and stock_qty <= min_stock),
    'pending_pos',      (select count(*) from purchase_orders
                          where user_id = auth.uid() and status in ('draft','ordered')),
    'purchases_last_7_days', (
      select coalesce(jsonb_agg(jsonb_build_object('day', d.day, 'total', d.total)
                                order by d.day), '[]'::jsonb)
      from (
        select g.day::date as day,
               coalesce(sum(po.total_amount), 0) as total
          from generate_series(current_date - 6, current_date, interval '1 day') as g(day)
          left join purchase_orders po
                 on po.user_id = auth.uid()
                and po.status <> 'cancelled'
                and po.order_date::date = g.day::date
         group by g.day
      ) d
    )
  );
$$;

-- ---------- 6. STORAGE (product images) -------------------------------

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

-- Files live under "<user_id>/<file>", so users can only touch their own folder.
create policy "product_images_public_read" on storage.objects
  for select using (bucket_id = 'product-images');

create policy "product_images_insert_own" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'product-images'
              and (storage.foldername(name))[1] = auth.uid()::text);

create policy "product_images_update_own" on storage.objects
  for update to authenticated
  using (bucket_id = 'product-images'
         and (storage.foldername(name))[1] = auth.uid()::text);

create policy "product_images_delete_own" on storage.objects
  for delete to authenticated
  using (bucket_id = 'product-images'
         and (storage.foldername(name))[1] = auth.uid()::text);

-- ---------- 7. REALTIME -----------------------------------------------

alter publication supabase_realtime add table
  public.products,
  public.suppliers,
  public.purchase_orders,
  public.stock_movements;
