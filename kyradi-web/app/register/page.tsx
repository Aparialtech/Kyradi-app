'use client';

import Link from 'next/link';
import { FormEvent, useMemo, useRef, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ArrowRight, CheckCircle2, Eye, EyeOff, Mail, Lock, User, Phone, ShieldCheck, MapPin, Zap } from 'lucide-react';
import { register, resendEmailVerifyCode, verifyEmailCode } from '@/lib/api';

type Stage = 'register' | 'verify' | 'done';

const EASE = [0.22, 1, 0.36, 1] as [number, number, number, number];

const fadeUp = (delay = 0) => ({
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  transition: { duration: 0.5, delay, ease: EASE },
});

const STAGES: { key: Stage; label: string; num: number }[] = [
  { key: 'register', label: 'Hesap Bilgileri', num: 1 },
  { key: 'verify', label: 'E-posta Doğrula', num: 2 },
  { key: 'done', label: 'Tamamlandı', num: 3 },
];

/* ─── OTP Input ─── */
function OtpInput({ value, onChange }: { value: string; onChange: (v: string) => void }) {
  const refs = useRef<(HTMLInputElement | null)[]>([]);
  const digits = value.padEnd(6, '').split('').slice(0, 6);

  const handleChange = (i: number, v: string) => {
    const clean = v.replace(/\D/g, '').slice(-1);
    const next = digits.map((d, idx) => (idx === i ? clean : d)).join('');
    onChange(next);
    if (clean && i < 5) refs.current[i + 1]?.focus();
  };

  const handleKey = (i: number, e: React.KeyboardEvent) => {
    if (e.key === 'Backspace' && !digits[i] && i > 0) refs.current[i - 1]?.focus();
  };

  const handlePaste = (e: React.ClipboardEvent) => {
    e.preventDefault();
    const pasted = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, 6);
    onChange(pasted.padEnd(6, ''));
    refs.current[Math.min(pasted.length, 5)]?.focus();
  };

  return (
    <div className="flex gap-2 justify-center">
      {digits.map((d, i) => (
        <input
          key={i}
          ref={el => { refs.current[i] = el; }}
          type="text"
          inputMode="numeric"
          maxLength={1}
          value={d}
          onChange={e => handleChange(i, e.target.value)}
          onKeyDown={e => handleKey(i, e)}
          onPaste={i === 0 ? handlePaste : undefined}
          className="h-14 w-12 rounded-2xl border-2 text-center text-xl font-black text-slate-900 outline-none transition-all"
          style={{
            borderColor: d ? '#6366f1' : '#e2e8f0',
            background: d ? '#eef2ff' : '#f8fafc',
            boxShadow: d ? '0 0 0 4px rgba(99,102,241,0.12)' : 'none',
          }}
        />
      ))}
    </div>
  );
}

/* ─── Field ─── */
function Field({ label, id, icon: Icon, children }: { label: string; id?: string; icon: React.ComponentType<{ className?: string }>; children: React.ReactNode }) {
  return (
    <div className="space-y-1.5">
      <label htmlFor={id} className="block text-[11px] font-black tracking-widest uppercase text-slate-500">{label}</label>
      <div className="relative">
        <Icon className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none" />
        {children}
      </div>
    </div>
  );
}

export default function RegisterPage() {
  const [stage, setStage] = useState<Stage>('register');
  const [name, setName] = useState('');
  const [surname, setSurname] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPass, setShowPass] = useState(false);
  const [phone, setPhone] = useState('');
  const [nationalId, setNationalId] = useState('');
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [debugCode, setDebugCode] = useState<string | null>(null);
  const [resendCountdown, setResendCountdown] = useState(0);

  const canSubmit = useMemo(() =>
    name.trim().length > 0 && surname.trim().length > 0 && email.trim().length > 0 && password.length >= 6,
    [name, surname, email, password]
  );

  const startResendTimer = () => {
    setResendCountdown(60);
    const iv = setInterval(() => {
      setResendCountdown(p => { if (p <= 1) { clearInterval(iv); return 0; } return p - 1; });
    }, 1000);
  };

  const onRegister = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!canSubmit) return;
    setLoading(true);
    setError(null);
    try {
      const result = await register({ name: name.trim(), surname: surname.trim(), email: email.trim(), password, phone: phone.trim() || undefined, nationalId: nationalId.trim() || undefined });
      const codeHint = result && typeof result === 'object' && typeof (result as Record<string, unknown>).code === 'string'
        ? ((result as Record<string, unknown>).code as string) : null;
      setDebugCode(codeHint);
      setStage('verify');
      startResendTimer();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Kayıt başarısız');
    } finally {
      setLoading(false);
    }
  };

  const onVerify = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await verifyEmailCode(email.trim(), code.trim());
      setStage('done');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Doğrulama başarısız');
    } finally {
      setLoading(false);
    }
  };

  const onResend = async () => {
    setLoading(true);
    setError(null);
    try {
      const result = await resendEmailVerifyCode(email.trim());
      const codeHint = result && typeof result === 'object' && typeof (result as Record<string, unknown>).code === 'string'
        ? ((result as Record<string, unknown>).code as string) : null;
      setDebugCode(codeHint);
      startResendTimer();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Kod gönderilemedi');
    } finally {
      setLoading(false);
    }
  };

  const activeStep = STAGES.findIndex(s => s.key === stage);

  return (
    <div className="min-h-screen flex" style={{ fontFamily: "'SF Pro Display','SF Pro Text',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif" }}>

      {/* ── LEFT BRAND PANEL ── */}
      <div className="hidden lg:flex lg:w-[42%] relative flex-col justify-between p-12 overflow-hidden"
        style={{ background: 'linear-gradient(145deg, #0f0c29 0%, #1a1040 40%, #0c1e3c 100%)' }}>
        {/* Orbs */}
        <div className="pointer-events-none absolute inset-0 overflow-hidden">
          <div className="absolute -top-32 -right-32 h-[500px] w-[500px] rounded-full opacity-20" style={{ background: 'radial-gradient(circle, #8b5cf6, transparent 70%)' }} />
          <div className="absolute -bottom-32 -left-32 h-[400px] w-[400px] rounded-full opacity-15" style={{ background: 'radial-gradient(circle, #06b6d4, transparent 70%)' }} />
        </div>
        {/* Dot grid */}
        <div className="pointer-events-none absolute inset-0 opacity-[0.06]">
          <svg width="100%" height="100%"><defs><pattern id="dots2" width="28" height="28" patternUnits="userSpaceOnUse"><circle cx="2" cy="2" r="1.5" fill="white"/></pattern></defs><rect width="100%" height="100%" fill="url(#dots2)"/></svg>
        </div>

        {/* Logo */}
        <motion.div {...fadeUp(0.1)} className="relative z-10 flex items-center gap-3">
          <div className="h-10 w-10 rounded-xl shadow-[0_8px_24px_rgba(99,102,241,0.5)]"
            style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6, #06b6d4)' }} />
          <div>
            <p className="text-[14px] font-black tracking-[0.22em] text-white">KYRADI</p>
            <p className="text-[11px] font-medium tracking-wide" style={{ color: 'rgba(255,255,255,0.45)' }}>SuperApp</p>
          </div>
        </motion.div>

        {/* Center */}
        <div className="relative z-10 space-y-8">
          <motion.div {...fadeUp(0.2)}>
            <h2 className="text-[2.4rem] font-black tracking-[-0.04em] leading-tight text-white">
              Hesabını oluştur,{' '}
              <span className="bg-clip-text text-transparent" style={{ backgroundImage: 'linear-gradient(135deg, #a78bfa, #38bdf8)' }}>
                özgürlüğü keşfet.
              </span>
            </h2>
            <p className="mt-4 text-[14px] leading-relaxed" style={{ color: 'rgba(255,255,255,0.55)' }}>
              Mobil ve web aynı hesapla çalışır. Tek kayıt, her yerde erişim.
            </p>
          </motion.div>

          {/* Steps preview */}
          <motion.div {...fadeUp(0.3)} className="space-y-3">
            {[
              { icon: User, text: 'Hesap bilgilerini gir', color: '#8b5cf6' },
              { icon: Mail, text: 'E-postanı doğrula', color: '#06b6d4' },
              { icon: CheckCircle2, text: 'Hazır! Keşfetmeye başla', color: '#10b981' },
            ].map(({ icon: Icon, text, color }, i) => (
              <motion.div key={text} {...fadeUp(0.35 + i * 0.06)} className="flex items-center gap-3">
                <div className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-xl"
                  style={{ background: `${color}22`, border: `1px solid ${color}44` }}>
                  <Icon className="h-4 w-4" style={{ color }} />
                </div>
                <p className="text-[13px] font-medium" style={{ color: 'rgba(255,255,255,0.7)' }}>{text}</p>
              </motion.div>
            ))}
          </motion.div>

          {/* Trust card */}
          <motion.div {...fadeUp(0.5)} className="rounded-2xl border p-4"
            style={{ background: 'rgba(255,255,255,0.05)', borderColor: 'rgba(255,255,255,0.1)', backdropFilter: 'blur(12px)' }}>
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl flex-shrink-0"
                style={{ background: 'linear-gradient(135deg, #10b981, #059669)' }}>
                <ShieldCheck className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-[13px] font-black text-white">Güvenli & Şifreli</p>
                <p className="text-[11px]" style={{ color: 'rgba(255,255,255,0.5)' }}>Verileriniz SSL ile korunur</p>
              </div>
            </div>
          </motion.div>
        </div>

        <motion.div {...fadeUp(0.55)} className="relative z-10">
          <p className="text-[11px]" style={{ color: 'rgba(255,255,255,0.3)' }}>© 2025 Kyradi • Tüm hakları saklıdır</p>
        </motion.div>
      </div>

      {/* ── RIGHT FORM PANEL ── */}
      <div className="flex flex-1 items-start justify-center overflow-y-auto bg-white p-6 lg:p-16">
        <div className="w-full max-w-[480px] py-8">

          {/* Mobile logo */}
          <motion.div {...fadeUp(0)} className="lg:hidden flex items-center gap-3 mb-10">
            <div className="h-9 w-9 rounded-xl shadow-[0_8px_20px_rgba(99,102,241,0.4)]"
              style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }} />
            <p className="text-[13px] font-black tracking-[0.22em] text-slate-900">KYRADI</p>
          </motion.div>

          {/* Progress stepper */}
          <motion.div {...fadeUp(0.05)} className="mb-8">
            <div className="flex items-center gap-0">
              {STAGES.map((s, i) => {
                const isActive = s.key === stage;
                const isDone = activeStep > i;
                return (
                  <div key={s.key} className="flex items-center flex-1 last:flex-none">
                    <div className="flex flex-col items-center gap-1.5">
                      <div className={`flex h-8 w-8 items-center justify-center rounded-full text-[11px] font-black transition-all duration-500`}
                        style={{
                          background: isDone ? 'linear-gradient(135deg, #10b981, #059669)' : isActive ? 'linear-gradient(135deg, #6366f1, #8b5cf6)' : '#f1f5f9',
                          color: isDone || isActive ? 'white' : '#94a3b8',
                          boxShadow: isActive ? '0 4px 16px rgba(99,102,241,0.4)' : 'none',
                        }}>
                        {isDone ? <CheckCircle2 className="h-4 w-4" /> : s.num}
                      </div>
                      <p className="text-[9px] font-bold tracking-wide uppercase whitespace-nowrap"
                        style={{ color: isActive ? '#6366f1' : isDone ? '#10b981' : '#94a3b8' }}>
                        {s.label}
                      </p>
                    </div>
                    {i < STAGES.length - 1 && (
                      <div className="flex-1 h-px mx-2 mb-5 transition-all duration-500"
                        style={{ background: isDone ? 'linear-gradient(90deg, #10b981, #6366f1)' : '#e2e8f0' }} />
                    )}
                  </div>
                );
              })}
            </div>
          </motion.div>

          {/* Stage content */}
          <AnimatePresence mode="wait">

            {/* ── STAGE 1: Register ── */}
            {stage === 'register' && (
              <motion.div key="register"
                initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
                transition={{ duration: 0.4, ease: EASE }}>

                <div className="mb-8">
                  <h1 className="text-[2rem] font-black tracking-[-0.04em] text-slate-900">Hesap oluştur ✨</h1>
                  <p className="mt-2 text-[14px] text-slate-500">Birkaç saniye içinde KYRADI&apos;ya katıl.</p>
                </div>

                <form onSubmit={onRegister} className="space-y-4">
                  {/* Name row */}
                  <div className="grid grid-cols-2 gap-3">
                    <Field label="Ad" id="name" icon={User}>
                      <input id="name" value={name} onChange={e => setName(e.target.value)} required placeholder="Adın"
                        className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-4 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100" />
                    </Field>
                    <Field label="Soyad" id="surname" icon={User}>
                      <input id="surname" value={surname} onChange={e => setSurname(e.target.value)} required placeholder="Soyadın"
                        className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-4 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100" />
                    </Field>
                  </div>

                  {/* Email */}
                  <Field label="E-posta" id="email" icon={Mail}>
                    <input id="email" type="email" value={email} onChange={e => setEmail(e.target.value)} required placeholder="ornek@mail.com" autoComplete="email"
                      className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-4 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100" />
                  </Field>

                  {/* Password */}
                  <Field label="Şifre" id="password" icon={Lock}>
                    <input id="password" type={showPass ? 'text' : 'password'} value={password} onChange={e => setPassword(e.target.value)} required minLength={6} placeholder="En az 6 karakter" autoComplete="new-password"
                      className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-12 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100" />
                    <button type="button" onClick={() => setShowPass(p => !p)} className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors">
                      {showPass ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </button>
                  </Field>

                  {/* Password strength */}
                  {password.length > 0 && (
                    <div className="space-y-1.5">
                      <div className="flex gap-1">
                        {[1, 2, 3, 4].map(i => (
                          <div key={i} className="h-1 flex-1 rounded-full transition-all duration-300"
                            style={{ background: password.length >= i * 2 ? (password.length >= 8 ? '#10b981' : password.length >= 6 ? '#f59e0b' : '#ef4444') : '#e2e8f0' }} />
                        ))}
                      </div>
                      <p className="text-[11px] font-semibold" style={{ color: password.length >= 8 ? '#10b981' : password.length >= 6 ? '#f59e0b' : '#ef4444' }}>
                        {password.length >= 8 ? 'Güçlü şifre ✓' : password.length >= 6 ? 'Orta güçlü' : 'Zayıf şifre'}
                      </p>
                    </div>
                  )}

                  {/* Optional fields */}
                  <div className="grid grid-cols-2 gap-3">
                    <Field label="Telefon (ops.)" id="phone" icon={Phone}>
                      <input id="phone" value={phone} onChange={e => setPhone(e.target.value)} placeholder="+90 5xx"
                        className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-4 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100" />
                    </Field>
                    <Field label="TC Kimlik (ops.)" id="nationalId" icon={ShieldCheck}>
                      <input id="nationalId" value={nationalId} onChange={e => setNationalId(e.target.value)} placeholder="11 hane"
                        className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-4 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100" />
                    </Field>
                  </div>

                  {/* Error */}
                  {error && (
                    <motion.div initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }}
                      className="flex items-start gap-2.5 rounded-2xl border border-red-100 bg-red-50 px-4 py-3">
                      <div className="mt-0.5 h-4 w-4 flex-shrink-0 rounded-full bg-red-500 flex items-center justify-center">
                        <span className="text-[8px] font-black text-white">!</span>
                      </div>
                      <p className="text-[13px] font-medium text-red-600">{error}</p>
                    </motion.div>
                  )}

                  {/* Submit */}
                  <motion.button type="submit" disabled={loading || !canSubmit}
                    whileHover={canSubmit ? { scale: 1.01, y: -1 } : {}}
                    whileTap={canSubmit ? { scale: 0.99 } : {}}
                    className="w-full rounded-2xl py-3.5 text-[15px] font-black text-white shadow-[0_12px_32px_rgba(99,102,241,0.4)] disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                    style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6, #7c3aed)' }}>
                    <span className="flex items-center justify-center gap-2">
                      {loading ? (
                        <><svg className="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="3"/><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"/></svg>Kayıt oluşturuluyor...</>
                      ) : (
                        <>Devam Et <ArrowRight className="h-4 w-4" /></>
                      )}
                    </span>
                  </motion.button>
                </form>
              </motion.div>
            )}

            {/* ── STAGE 2: Verify ── */}
            {stage === 'verify' && (
              <motion.div key="verify"
                initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
                transition={{ duration: 0.4, ease: EASE }}>

                <div className="mb-8">
                  <div className="mb-4 flex h-14 w-14 items-center justify-center rounded-2xl"
                    style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)', boxShadow: '0 8px 24px rgba(99,102,241,0.35)' }}>
                    <Mail className="h-6 w-6 text-white" />
                  </div>
                  <h1 className="text-[2rem] font-black tracking-[-0.04em] text-slate-900">E-postanı doğrula 📬</h1>
                  <p className="mt-2 text-[14px] text-slate-500 leading-relaxed">
                    <span className="font-bold text-slate-700">{email}</span> adresine 6 haneli doğrulama kodu gönderdik.
                  </p>
                </div>

                <form onSubmit={onVerify} className="space-y-6">
                  <div className="space-y-3">
                    <label className="block text-[11px] font-black tracking-widest uppercase text-slate-500 text-center">Doğrulama Kodu</label>
                    <OtpInput value={code} onChange={setCode} />
                    {debugCode && (
                      <div className="rounded-xl border border-amber-200 bg-amber-50 px-3 py-2 text-center">
                        <p className="text-[11px] font-bold text-amber-700">Geliştirici kodu: <span className="font-black text-amber-900">{debugCode}</span></p>
                      </div>
                    )}
                  </div>

                  {error && (
                    <motion.div initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }}
                      className="flex items-start gap-2.5 rounded-2xl border border-red-100 bg-red-50 px-4 py-3">
                      <div className="mt-0.5 h-4 w-4 flex-shrink-0 rounded-full bg-red-500 flex items-center justify-center">
                        <span className="text-[8px] font-black text-white">!</span>
                      </div>
                      <p className="text-[13px] font-medium text-red-600">{error}</p>
                    </motion.div>
                  )}

                  <motion.button type="submit" disabled={loading || code.replace(/\s/g,'').length < 6}
                    whileHover={{ scale: 1.01, y: -1 }} whileTap={{ scale: 0.99 }}
                    className="w-full rounded-2xl py-3.5 text-[15px] font-black text-white shadow-[0_12px_32px_rgba(99,102,241,0.4)] disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                    style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}>
                    <span className="flex items-center justify-center gap-2">
                      {loading ? (
                        <><svg className="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="3"/><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"/></svg>Doğrulanıyor...</>
                      ) : (
                        <>Kodu Doğrula <ArrowRight className="h-4 w-4" /></>
                      )}
                    </span>
                  </motion.button>

                  <div className="text-center">
                    {resendCountdown > 0 ? (
                      <p className="text-[13px] text-slate-400">Kodu tekrar gönder ({resendCountdown}s)</p>
                    ) : (
                      <button type="button" onClick={onResend} disabled={loading}
                        className="text-[13px] font-bold text-indigo-600 hover:text-indigo-700 transition-colors underline underline-offset-2 disabled:opacity-50">
                        Kodu yeniden gönder
                      </button>
                    )}
                  </div>
                </form>
              </motion.div>
            )}

            {/* ── STAGE 3: Done ── */}
            {stage === 'done' && (
              <motion.div key="done"
                initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }}
                transition={{ duration: 0.5, ease: EASE }}
                className="text-center py-8">

                {/* Success animation */}
                <motion.div
                  initial={{ scale: 0 }} animate={{ scale: 1 }}
                  transition={{ type: 'spring', stiffness: 200, damping: 15, delay: 0.1 }}
                  className="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-full shadow-[0_16px_40px_rgba(16,185,129,0.4)]"
                  style={{ background: 'linear-gradient(135deg, #10b981, #059669)' }}>
                  <CheckCircle2 className="h-10 w-10 text-white" />
                </motion.div>

                <motion.div {...fadeUp(0.3)}>
                  <h2 className="text-[2rem] font-black tracking-[-0.04em] text-slate-900">Hesabın hazır! 🎉</h2>
                  <p className="mt-3 text-[15px] leading-relaxed text-slate-500 max-w-sm mx-auto">
                    Hesabın başarıyla doğrulandı. Giriş yaparak rezervasyonlarını yönetmeye başlayabilirsin.
                  </p>
                </motion.div>

                <motion.div {...fadeUp(0.4)} className="mt-8 space-y-3">
                  <Link href="/login"
                    className="flex items-center justify-center gap-2 rounded-2xl py-4 text-[15px] font-black text-white shadow-[0_12px_32px_rgba(99,102,241,0.4)] hover:shadow-[0_16px_40px_rgba(99,102,241,0.5)] hover:-translate-y-0.5 transition-all"
                    style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}>
                    Giriş Yap <ArrowRight className="h-4 w-4" />
                  </Link>
                </motion.div>

                <motion.div {...fadeUp(0.5)} className="mt-8 grid grid-cols-3 gap-3">
                  {[
                    { icon: ShieldCheck, label: 'Güvenli', color: '#10b981' },
                    { icon: MapPin, label: 'Yakın nokta', color: '#6366f1' },
                    { icon: Zap, label: 'Hızlı', color: '#f59e0b' },
                  ].map(({ icon: Icon, label, color }) => (
                    <div key={label} className="rounded-2xl border border-slate-100 bg-slate-50 p-3 text-center">
                      <Icon className="h-5 w-5 mx-auto mb-1.5" style={{ color }} />
                      <p className="text-[11px] font-bold text-slate-600">{label}</p>
                    </div>
                  ))}
                </motion.div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Login link */}
          {stage !== 'done' && (
            <motion.div {...fadeUp(0.35)} className="mt-8 text-center">
              <div className="h-px bg-slate-100 mb-6" />
              <p className="text-[14px] text-slate-500">
                Zaten hesabın var mı?{' '}
                <Link href="/login" className="font-black text-indigo-600 hover:text-indigo-700 transition-colors underline underline-offset-2">
                  Giriş Yap
                </Link>
              </p>
            </motion.div>
          )}
        </div>
      </div>
    </div>
  );
}
