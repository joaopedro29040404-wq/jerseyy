'use client';

import { FormEvent, useState } from 'react';
import { createClient } from '@/lib/supabase-browser';
import { useRouter } from 'next/navigation';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (loading) return;

    setError('');
    setLoading(true);

    try {
      const supabase = createClient();
      const { error: signInError } = await supabase.auth.signInWithPassword({
        email: email.trim(),
        password,
      });

      if (signInError) {
        setError(signInError.message);
        return;
      }

      // Garante que o JWT atualize o app_metadata após a promoção para admin.
      await supabase.auth.refreshSession();
      router.replace('/admin');
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Não foi possível entrar. Verifique a configuração do Supabase.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-[#050505] p-5">
      <form onSubmit={submit} className="w-full max-w-md rounded-2xl border border-white/10 bg-white/[.03] p-7">
        <div className="gold text-xs font-bold tracking-[.3em]">JERSEY GOLD</div>
        <h1 className="mt-2 text-3xl font-black">Acesso administrativo</h1>

        <input
          required
          type="email"
          autoComplete="email"
          placeholder="E-mail"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="mt-8 w-full rounded border border-white/10 bg-black px-4 py-3"
        />

        <input
          required
          type="password"
          autoComplete="current-password"
          placeholder="Senha"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="mt-3 w-full rounded border border-white/10 bg-black px-4 py-3"
        />

        <button
          type="submit"
          disabled={loading}
          className="mt-5 w-full bg-gold px-4 py-3 font-black text-black disabled:cursor-not-allowed disabled:opacity-60"
        >
          {loading ? 'ENTRANDO...' : 'ENTRAR'}
        </button>

        {error && <p className="mt-4 text-sm text-red-400">{error}</p>}
      </form>
    </main>
  );
}
