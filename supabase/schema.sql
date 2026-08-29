create extension if not exists pgcrypto;

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  image_url text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.sizes (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  team text not null,
  season text not null,
  category_id uuid not null references public.categories(id) on delete restrict,
  price numeric(12,2) not null check (price >= 0),
  description text not null default '',
  images jsonb not null default '[]'::jsonb,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.product_sizes (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  size_id uuid not null references public.sizes(id) on delete restrict,
  active boolean not null default true,
  unique(product_id,size_id)
);
create table if not exists public.product_size_stock (
  id uuid primary key default gen_random_uuid(),
  product_size_id uuid not null unique references public.product_sizes(id) on delete cascade,
  stock integer not null default 0 check (stock >= 0)
);
create table if not exists public.settings (
  key text primary key,
  value text not null default ''
);

alter table public.categories enable row level security;
alter table public.sizes enable row level security;
alter table public.products enable row level security;
alter table public.product_sizes enable row level security;
alter table public.product_size_stock enable row level security;
alter table public.settings enable row level security;

create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$
  select coalesce((auth.jwt()->'app_metadata'->>'role')='admin',false);
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to anon, authenticated;

create policy "public read active categories" on public.categories for select to anon, authenticated using (active = true or public.is_admin());
create policy "admin categories insert" on public.categories for insert to authenticated with check (public.is_admin());
create policy "admin categories update" on public.categories for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin categories delete" on public.categories for delete to authenticated using (public.is_admin());

create policy "public read active sizes" on public.sizes for select to anon, authenticated using (active = true or public.is_admin());
create policy "admin sizes insert" on public.sizes for insert to authenticated with check (public.is_admin());
create policy "admin sizes update" on public.sizes for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin sizes delete" on public.sizes for delete to authenticated using (public.is_admin());

create policy "public read active products" on public.products for select to anon, authenticated using (active = true or public.is_admin());
create policy "admin products insert" on public.products for insert to authenticated with check (public.is_admin());
create policy "admin products update" on public.products for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin products delete" on public.products for delete to authenticated using (public.is_admin());

create policy "public read active product sizes" on public.product_sizes for select to anon, authenticated using (active = true or public.is_admin());
create policy "admin product sizes insert" on public.product_sizes for insert to authenticated with check (public.is_admin());
create policy "admin product sizes update" on public.product_sizes for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin product sizes delete" on public.product_sizes for delete to authenticated using (public.is_admin());

create policy "public read stock" on public.product_size_stock for select to anon, authenticated using (true);
create policy "admin stock insert" on public.product_size_stock for insert to authenticated with check (public.is_admin());
create policy "admin stock update" on public.product_size_stock for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin stock delete" on public.product_size_stock for delete to authenticated using (public.is_admin());

create policy "public read settings" on public.settings for select to anon, authenticated using (true);
create policy "admin settings insert" on public.settings for insert to authenticated with check (public.is_admin());
create policy "admin settings update" on public.settings for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin settings delete" on public.settings for delete to authenticated using (public.is_admin());

insert into public.settings(key,value) values
('store_name','JERSEY GOLD'),('logo_url',''),('whatsapp',''),('instagram','')
on conflict(key) do nothing;

insert into public.categories(name,image_url) values
('Clubes','/demo/category-placeholder.svg'),('Seleções','/demo/category-placeholder.svg'),('Retrô','/demo/category-placeholder.svg')
on conflict(name) do nothing;
insert into public.sizes(name) values ('PP'),('P'),('M'),('G'),('GG'),('XG') on conflict(name) do nothing;

insert into public.products(name,team,season,category_id,price,description,images)
select 'Corinthians','Corinthians','2026',(select id from public.categories where name='Clubes'),219.90,'Produto de demonstração. A imagem é um placeholder claramente identificado.','["/demo/jersey-placeholder.svg"]'::jsonb
where not exists(select 1 from public.products where name='Corinthians');
insert into public.products(name,team,season,category_id,price,description,images)
select 'Brasil','Brasil','2026',(select id from public.categories where name='Seleções'),229.90,'Produto de demonstração. A imagem é um placeholder claramente identificado.','["/demo/jersey-placeholder.svg"]'::jsonb
where not exists(select 1 from public.products where name='Brasil');
insert into public.products(name,team,season,category_id,price,description,images)
select 'Real Madrid','Real Madrid','2026',(select id from public.categories where name='Clubes'),249.90,'Produto de demonstração. A imagem é um placeholder claramente identificado.','["/demo/jersey-placeholder.svg"]'::jsonb
where not exists(select 1 from public.products where name='Real Madrid');
insert into public.products(name,team,season,category_id,price,description,images)
select 'Barcelona','Barcelona','2026',(select id from public.categories where name='Clubes'),249.90,'Produto de demonstração. A imagem é um placeholder claramente identificado.','["/demo/jersey-placeholder.svg"]'::jsonb
where not exists(select 1 from public.products where name='Barcelona');
insert into public.products(name,team,season,category_id,price,description,images)
select 'Argentina','Argentina','2026',(select id from public.categories where name='Seleções'),229.90,'Produto de demonstração. A imagem é um placeholder claramente identificado.','["/demo/jersey-placeholder.svg"]'::jsonb
where not exists(select 1 from public.products where name='Argentina');
insert into public.products(name,team,season,category_id,price,description,images)
select 'Milan Retrô','Milan','Retrô',(select id from public.categories where name='Retrô'),239.90,'Produto de demonstração. A imagem é um placeholder claramente identificado.','["/demo/jersey-placeholder.svg"]'::jsonb
where not exists(select 1 from public.products where name='Milan Retrô');

insert into public.product_sizes(product_id,size_id)
select p.id,s.id from public.products p cross join public.sizes s
where not exists(select 1 from public.product_sizes ps where ps.product_id=p.id and ps.size_id=s.id);
insert into public.product_size_stock(product_size_id,stock)
select ps.id, case when s.name='P' then 2 when s.name='M' then 5 when s.name='G' then 8 when s.name='GG' then 0 else 1 end
from public.product_sizes ps join public.sizes s on s.id=ps.size_id
where not exists(select 1 from public.product_size_stock x where x.product_size_id=ps.id);

insert into storage.buckets(id,name,public) values('product-images','product-images',true) on conflict(id) do nothing;
create policy "public product images read" on storage.objects for select to public using (bucket_id='product-images');
create policy "admin product images insert" on storage.objects for insert to authenticated with check (bucket_id='product-images' and public.is_admin());
create policy "admin product images update" on storage.objects for update to authenticated using (bucket_id='product-images' and public.is_admin()) with check (bucket_id='product-images' and public.is_admin());
create policy "admin product images delete" on storage.objects for delete to authenticated using (bucket_id='product-images' and public.is_admin());

create or replace function public.make_admin(user_email text) returns void language plpgsql security definer set search_path=public,auth as $$
begin
  update auth.users set raw_app_meta_data = coalesce(raw_app_meta_data,'{}'::jsonb) || '{"role":"admin"}'::jsonb where lower(email)=lower(user_email);
end; $$;
revoke all on function public.make_admin(text) from public, anon, authenticated;
