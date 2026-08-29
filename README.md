# JERSEY GOLD — FOOTBALL STORE

Catálogo premium responsivo em Next.js + TypeScript + Tailwind CSS + Supabase.

## O que está incluído
- Home: Header, Hero, Categorias, Catálogo, Informações, WhatsApp e Footer.
- Categorias, produtos, tamanhos e estoque por tamanho dinâmicos.
- Busca, filtros e ordenação.
- Página individual do produto com compra via WhatsApp.
- `/admin` protegido por Supabase Auth + role `admin` em `app_metadata`.
- CRUD administrativo para produtos, categorias, tamanhos e configurações.
- Upload de imagens de produtos no Supabase Storage.
- RLS para leitura pública e CRUD administrativo.
- Placeholders próprios e identificados para demonstração; nenhuma foto real de clube foi incluída.

## Configuração rápida
1. Crie um projeto no Supabase.
2. Abra **SQL Editor → New query**, cole `supabase/schema.sql` e clique **Run**.
3. Em **Authentication → Users → Add user**, crie o primeiro usuário administrador com e-mail e senha.
4. No SQL Editor, execute: `select public.make_admin('SEU_EMAIL');`
5. Em **Storage**, confirme o bucket público `product-images` criado pelo SQL.
6. Copie `.env.example` para `.env.local` e preencha a URL e a anon key em **Project Settings → API**.
7. Rode `npm install` e `npm run dev`.
8. Acesse `http://localhost:3000/admin`.

## Deploy
Na Vercel, importe o repositório GitHub e cadastre as mesmas duas variáveis de ambiente antes do deploy:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Observação sobre imagens
Os produtos de demonstração usam apenas `/public/demo/jersey-placeholder.svg`, explicitamente marcado como demonstração. Substitua por imagens próprias/licenciadas no painel administrativo.
