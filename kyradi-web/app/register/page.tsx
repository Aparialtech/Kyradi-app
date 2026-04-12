'use client';

import Link from 'next/link';
import { FormEvent, useMemo, useState } from 'react';
import { register, resendEmailVerifyCode, verifyEmailCode } from '@/lib/api';
import { NeoIcon } from '@/components/neo-icon';

type RegisterStage = 'register' | 'verify' | 'done';

export default function RegisterPage() {
  const [stage, setStage] = useState<RegisterStage>('register');
  const [name, setName] = useState('');
  const [surname, setSurname] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [phone, setPhone] = useState('');
  const [nationalId, setNationalId] = useState('');
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [debugCode, setDebugCode] = useState<string | null>(null);

  const canSubmitRegister = useMemo(() => {
    return name.trim().length > 0 && surname.trim().length > 0 && email.trim().length > 0 && password.length >= 6;
  }, [name, surname, email, password]);

  const onRegister = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!canSubmitRegister) return;
    setLoading(true);
    setError(null);
    setMessage(null);
    setDebugCode(null);
    try {
      const result = await register({
        name: name.trim(),
        surname: surname.trim(),
        email: email.trim(),
        password,
        phone: phone.trim() || undefined,
        nationalId: nationalId.trim() || undefined,
      });
      const codeHint =
        result && typeof result === 'object' && typeof (result as Record<string, unknown>).code === 'string'
          ? ((result as Record<string, unknown>).code as string)
          : null;
      setDebugCode(codeHint);
      setMessage('Kayıt başarılı. E-posta doğrulama kodunu gir.');
      setStage('verify');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Kayıt başarısız');
    } finally {
      setLoading(false);
    }
  };

  const onVerify = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true);
    setError(null);
    setMessage(null);
    try {
      await verifyEmailCode(email.trim(), code.trim());
      setStage('done');
      setMessage('Hesap doğrulandı. Giriş yapabilirsin.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Doğrulama başarısız');
    } finally {
      setLoading(false);
    }
  };

  const onResend = async () => {
    setLoading(true);
    setError(null);
    setMessage(null);
    try {
      const result = await resendEmailVerifyCode(email.trim());
      const codeHint =
        result && typeof result === 'object' && typeof (result as Record<string, unknown>).code === 'string'
          ? ((result as Record<string, unknown>).code as string)
          : null;
      setDebugCode(codeHint);
      setMessage('Doğrulama kodu yeniden gönderildi.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Kod gönderilemedi');
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="auth-wrap">
      <section className="card auth-card">
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
          <NeoIcon symbol="✦" tone="pink" size="md" />
          <div>
            <h1 className="auth-title">Kayıt Ol</h1>
            <p className="auth-sub" style={{ margin: 0 }}>Mobil ve web aynı hesapla çalışır.</p>
          </div>
        </div>

        {stage === 'register' ? (
          <form onSubmit={onRegister}>
            <div className="grid cols-2" style={{ gap: 12 }}>
              <div className="form-row">
                <label htmlFor="name">Ad</label>
                <input
                  id="name"
                  className="input"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  required
                />
              </div>
              <div className="form-row">
                <label htmlFor="surname">Soyad</label>
                <input
                  id="surname"
                  className="input"
                  value={surname}
                  onChange={(e) => setSurname(e.target.value)}
                  required
                />
              </div>
            </div>

            <div className="form-row">
              <label htmlFor="email">E-posta</label>
              <input
                id="email"
                className="input"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
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
                required
                minLength={6}
              />
            </div>

            <div className="form-row">
              <label htmlFor="phone">Telefon (opsiyonel)</label>
              <input
                id="phone"
                className="input"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
              />
            </div>

            <div className="form-row">
              <label htmlFor="nationalId">TC Kimlik No (opsiyonel)</label>
              <input
                id="nationalId"
                className="input"
                value={nationalId}
                onChange={(e) => setNationalId(e.target.value)}
              />
            </div>

            <button className="button primary" type="submit" style={{ width: '100%' }} disabled={loading || !canSubmitRegister}>
              {loading ? 'Kayıt oluşturuluyor...' : 'Kayıt Ol'}
            </button>
          </form>
        ) : null}

        {stage === 'verify' ? (
          <form onSubmit={onVerify}>
            <div className="form-row">
              <label>E-posta</label>
              <input className="input" value={email} disabled />
            </div>
            <div className="form-row">
              <label htmlFor="code">Doğrulama Kodu</label>
              <input
                id="code"
                className="input"
                value={code}
                onChange={(e) => setCode(e.target.value)}
                required
                placeholder="6 haneli kod"
              />
            </div>
            <button className="button primary" type="submit" style={{ width: '100%' }} disabled={loading}>
              {loading ? 'Doğrulanıyor...' : 'Kodu Doğrula'}
            </button>
            <button
              className="button secondary"
              type="button"
              style={{ width: '100%', marginTop: 10 }}
              onClick={onResend}
              disabled={loading}
            >
              Kodu Yeniden Gönder
            </button>
          </form>
        ) : null}

        {stage === 'done' ? (
          <div className="card" style={{ padding: 14, background: 'var(--surface-soft)', borderColor: 'var(--border)' }}>
            Hesabın hazır. Giriş sayfasına geç.
          </div>
        ) : null}

        {message ? (
          <div style={{ color: 'var(--primary)', marginTop: 12, fontSize: 14 }}>{message}</div>
        ) : null}
        {error ? (
          <div style={{ color: 'var(--danger)', marginTop: 12, fontSize: 14 }}>{error}</div>
        ) : null}
        {debugCode ? (
          <div style={{ marginTop: 8, fontSize: 12, color: 'var(--muted)' }}>Geliştirici kodu: {debugCode}</div>
        ) : null}

        <div style={{ marginTop: 14, textAlign: 'center', color: 'var(--muted)', fontSize: 14 }}>
          Zaten hesabın var mı?{' '}
          <Link href="/login" style={{ color: 'var(--primary)', fontWeight: 700 }}>
            Giriş Yap
          </Link>
        </div>
      </section>
    </main>
  );
}
