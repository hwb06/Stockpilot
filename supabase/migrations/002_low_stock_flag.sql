alter table public.products
  add column if not exists is_low_stock boolean
  generated always as (stock_qty <= min_stock) stored;

create index if not exists idx_products_low_stock
  on public.products (user_id) where is_low_stock;