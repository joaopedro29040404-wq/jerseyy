import { createServerClient } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';
export async function middleware(request: NextRequest) {
  let response = NextResponse.next({ request: { headers: request.headers } });
  const supabase = createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!, { cookies: { getAll:()=>request.cookies.getAll(), setAll(cs){ cs.forEach(({name,value,options})=>{ request.cookies.set(name,value); response.cookies.set(name,value,options); }); } } });
  const { data:{ user } } = await supabase.auth.getUser();
  if (request.nextUrl.pathname === '/admin/login') return response;
  if (!user) return NextResponse.redirect(new URL('/admin/login', request.url));
  if (user.app_metadata?.role !== 'admin') return NextResponse.redirect(new URL('/admin/login', request.url));
  return response;
}
export const config = { matcher: ['/admin/:path*'] };
