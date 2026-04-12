'use client';

import Link from 'next/link';
import { FormEvent, useState } from 'react';
import { useRouter } from 'next/navigation';
import { login } from '@/lib/api';
import { setToken, setUserId } from '@/lib/auth';
import { NeoIcon } from '@/components/neo-icon';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const result = await login(email.trim(), password);
      setToken(result.accessToken);
      const userId = result.user?._id || result.user?.id;
      if (userId) {
        setUserId(userId);
      }
      router.replace('/dashboard');
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Giriş başarısız';
      setError(message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="auth-wrap">
      <section className="card auth-card">
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12 }}>
          <NeoIcon symbol="◉" tone="cyan" size="md" />
          <div>
            <h1 className="auth-title">KYRADI</h1>
            <p className="auth-sub" style={{ margin: 0 }}>Web SuperApp&apos;e hoş geldin</p>
          </div>
        </div>

        <p className="auth-sub">Mobil hesabınla giriş yap, rezervasyonlarını ve cüzdanını webden de yönet.</p>

        <form onSubmit={onSubmit}>
          <div className="form-row">
            <label htmlFor="email">E-posta</label>
            <input
              id="email"
              className="input"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="ornek@mail.com"
              autoComplete="email"
              required
            />
          </div>

          <div className="form-row">
            <label htmlFor="password">Şifre</label>
            <input
              id="password"
              className="input"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              autoComplete="current-password"
              required
            />
          </div>

          {error ? (
            <div style={{ color: 'var(--danger)', marginBottom: 12, fontSize: 14 }}>{error}</div>
          ) : null}

          <button className="button primary" type="submit" style={{ width: '100%' }} disabled={loading}>
            {loading ? 'Giriş yapılıyor...' : 'Giriş Yap'}
          </button>
        </form>

        <div style={{ marginTop: 14, textAlign: 'center', color: 'var(--muted)', fontSize: 14 }}>
          Hesabın yok mu?{' '}
          <Link href="/register" style={{ color: 'var(--primary)', fontWeight: 700 }}>
            Kayıt Ol
          </Link>
        </div>
      </section>
    </main>
  );
}
