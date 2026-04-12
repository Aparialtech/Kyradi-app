'use client';

import Link from 'next/link';
import { FormEvent, useState } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { Eye, EyeOff, ArrowRight, ShieldCheck, MapPin, Zap, Mail, Lock } from 'lucide-react';
import { login } from '@/lib/api';
import { setToken, setUserId } from '@/lib/auth';

const EASE = [0.22, 1, 0.36, 1] as [number, number, number, number];

const fadeUp = (delay = 0) => ({
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  transition: { duration: 0.5, delay, ease: EASE },
});

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const result = await login(email.trim(), password);
      setToken(result.accessToken);
      const userId = result.user?._id || result.user?.id;
      if (userId) setUserId(userId);
      router.replace('/dashboard');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Giriş başarısız');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex" style={{ fontFamily: "'SF Pro Display','SF Pro Text',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif" }}>

      {/* ── LEFT BRAND PANEL ── */}
      <div className="hidden lg:flex lg:w-[45%] relative flex-col justify-between p-12 overflow-hidden"
        style={{ background: 'linear-gradient(145deg, #0f0c29 0%, #1a1040 40%, #0c1e3c 100%)' }}>

        {/* Gradient orbs */}
        <div className="pointer-events-none absolute inset-0 overflow-hidden">
          <div className="absolute -top-32 -left-32 h-[500px] w-[500px] rounded-full opacity-20"
            style={{ background: 'radial-gradient(circle, #6366f1, transparent 70%)' }} />
          <div className="absolute -bottom-32 -right-32 h-[400px] w-[400px] rounded-full opacity-15"
            style={{ background: 'radial-gradient(circle, #ec4899, transparent 70%)' }} />
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 h-[300px] w-[300px] rounded-full opacity-10"
            style={{ background: 'radial-gradient(circle, #06b6d4, transparent 70%)' }} />
        </div>
        {/* Dot grid */}
        <div className="pointer-events-none absolute inset-0 opacity-[0.06]">
          <svg width="100%" height="100%">
            <defs>
              <pattern id="dots" width="28" height="28" patternUnits="userSpaceOnUse">
                <circle cx="2" cy="2" r="1.5" fill="white" />
              </pattern>
            </defs>
            <rect width="100%" height="100%" fill="url(#dots)" />
          </svg>
        </div>

        {/* Logo */}
        <motion.div {...fadeUp(0.1)} className="relative z-10 flex items-center gap-3">
          <img src="/logo-white.svg" alt="Kyradi" className="h-10 w-10 flex-shrink-0" />
          <div>
            <p className="text-[14px] font-black tracking-[0.22em] text-white">KYRADI</p>
            <p className="text-[11px] font-medium tracking-wide" style={{ color: 'rgba(255,255,255,0.45)' }}>SuperApp</p>
          </div>
        </motion.div>

        {/* Center content */}
        <div className="relative z-10 space-y-8">
          <motion.div {...fadeUp(0.2)}>
            <h2 className="text-[2.6rem] font-black tracking-[-0.04em] leading-tight text-white">
              Bavulunu bırak,{' '}
              <span className="bg-clip-text text-transparent" style={{ backgroundImage: 'linear-gradient(135deg, #a78bfa, #ec4899, #38bdf8)' }}>
                şehri keşfet.
              </span>
            </h2>
            <p className="mt-4 text-[15px] leading-relaxed" style={{ color: 'rgba(255,255,255,0.55)' }}>
              Yakındaki güvenli teslim noktasını bul, bavulunu bırak ve anın tadını çıkar.
            </p>
          </motion.div>

          {/* Feature list */}
          <motion.div {...fadeUp(0.3)} className="space-y-4">
            {[
              { icon: ShieldCheck, text: 'Sertifikalı güvenli teslim noktaları', color: '#10b981' },
              { icon: Zap, text: '30 saniyede hızlı rezervasyon', color: '#f59e0b' },
              { icon: MapPin, text: 'Şehrin her köşesinde erişim', color: '#ec4899' },
            ].map(({ icon: Icon, text, color }, i) => (
              <motion.div key={text} {...fadeUp(0.35 + i * 0.07)} className="flex items-center gap-3">
                <div className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-xl"
                  style={{ background: `${color}22`, border: `1px solid ${color}44` }}>
                  <Icon className="h-4 w-4" style={{ color }} />
                </div>
                <p className="text-[13px] font-medium" style={{ color: 'rgba(255,255,255,0.7)' }}>{text}</p>
              </motion.div>
            ))}
          </motion.div>

          {/* Floating stat card */}
          <motion.div {...fadeUp(0.5)}
            className="rounded-2xl border p-5"
            style={{ background: 'rgba(255,255,255,0.05)', borderColor: 'rgba(255,255,255,0.1)', backdropFilter: 'blur(12px)' }}>
            <div className="flex items-center gap-4">
              <div className="flex -space-x-2">
                {['#f43f5e', '#f59e0b', '#6366f1', '#10b981'].map((c, i) => (
                  <div key={i} className="h-8 w-8 rounded-full border-2 flex-shrink-0"
                    style={{ background: c, borderColor: 'rgba(255,255,255,0.2)' }} />
                ))}
              </div>
              <div>
                <p className="text-sm font-black text-white">1000+ gezgin</p>
                <p className="text-[11px]" style={{ color: 'rgba(255,255,255,0.5)' }}>güvenle kullanıyor</p>
              </div>
            </div>
          </motion.div>
        </div>

        {/* Bottom footer */}
        <motion.div {...fadeUp(0.55)} className="relative z-10">
          <p className="text-[11px]" style={{ color: 'rgba(255,255,255,0.3)' }}>© 2025 Kyradi • Tüm hakları saklıdır</p>
        </motion.div>
      </div>

      {/* ── RIGHT FORM PANEL ── */}
      <div className="flex flex-1 items-center justify-center p-6 bg-white lg:p-16">
        <div className="w-full max-w-[420px]">

          {/* Mobile logo */}
          <motion.div {...fadeUp(0)} className="lg:hidden flex items-center gap-3 mb-10">
            <img src="/app-icon.svg" alt="Kyradi" className="h-9 w-9 flex-shrink-0" style={{ borderRadius: 9 }} />
            <p className="text-[13px] font-black tracking-[0.22em] text-slate-900">KYRADI</p>
          </motion.div>

          {/* Heading */}
          <motion.div {...fadeUp(0.05)} className="mb-8">
            <h1 className="text-[2rem] font-black tracking-[-0.04em] text-slate-900">Tekrar hoş geldin 👋</h1>
            <p className="mt-2 text-[14px] text-slate-500 leading-relaxed">
              Mobil hesabınla giriş yap, rezervasyonlarını webden de yönet.
            </p>
          </motion.div>

          {/* Form */}
          <motion.form {...fadeUp(0.1)} onSubmit={onSubmit} className="space-y-4">

            {/* Email field */}
            <div className="space-y-1.5">
              <label className="block text-[12px] font-bold tracking-wide text-slate-600 uppercase">E-posta</label>
              <div className="relative">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none" />
                <input
                  type="email"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  placeholder="ornek@mail.com"
                  autoComplete="email"
                  required
                  className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-4 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100"
                />
              </div>
            </div>

            {/* Password field */}
            <div className="space-y-1.5">
              <label className="block text-[12px] font-bold tracking-wide text-slate-600 uppercase">Şifre</label>
              <div className="relative">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none" />
                <input
                  type={showPass ? 'text' : 'password'}
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  placeholder="••••••••"
                  autoComplete="current-password"
                  required
                  className="w-full rounded-2xl border border-slate-200 bg-slate-50 py-3.5 pl-11 pr-12 text-[14px] font-medium text-slate-900 placeholder-slate-400 outline-none transition-all focus:border-indigo-400 focus:bg-white focus:ring-4 focus:ring-indigo-100"
                />
                <button
                  type="button"
                  onClick={() => setShowPass(p => !p)}
                  className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors"
                >
                  {showPass ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
            </div>

            {/* Error */}
            {error && (
              <motion.div
                initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }}
                className="flex items-start gap-2.5 rounded-2xl border border-red-100 bg-red-50 px-4 py-3"
              >
                <div className="mt-0.5 h-4 w-4 flex-shrink-0 rounded-full bg-red-500 flex items-center justify-center">
                  <span className="text-[8px] font-black text-white">!</span>
                </div>
                <p className="text-[13px] font-medium text-red-600">{error}</p>
              </motion.div>
            )}

            {/* Submit */}
            <motion.button
              type="submit"
              disabled={loading}
              whileHover={{ scale: 1.01, y: -1 }}
              whileTap={{ scale: 0.99 }}
              className="relative w-full overflow-hidden rounded-2xl py-3.5 text-[15px] font-black text-white shadow-[0_12px_32px_rgba(99,102,241,0.4)] hover:shadow-[0_16px_40px_rgba(99,102,241,0.5)] disabled:opacity-70 disabled:cursor-not-allowed transition-shadow"
              style={{ background: loading ? '#6366f1' : 'linear-gradient(135deg, #6366f1, #8b5cf6, #7c3aed)' }}
            >
              <span className="flex items-center justify-center gap-2">
                {loading ? (
                  <>
                    <svg className="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="3"/>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"/>
                    </svg>
                    Giriş yapılıyor...
                  </>
                ) : (
                  <>Giriş Yap <ArrowRight className="h-4 w-4" /></>
                )}
              </span>
            </motion.button>
          </motion.form>

          {/* Divider */}
          <motion.div {...fadeUp(0.2)} className="my-6 flex items-center gap-4">
            <div className="flex-1 h-px bg-slate-100" />
            <p className="text-[11px] font-semibold text-slate-400 uppercase tracking-wide">veya</p>
            <div className="flex-1 h-px bg-slate-100" />
          </motion.div>

          {/* Register link */}
          <motion.div {...fadeUp(0.25)} className="text-center">
            <p className="text-[14px] text-slate-500">
              Hesabın yok mu?{' '}
              <Link href="/register" className="font-black text-indigo-600 hover:text-indigo-700 transition-colors underline underline-offset-2">
                Hemen Kayıt Ol
              </Link>
            </p>
          </motion.div>

          {/* Trust badges */}
          <motion.div {...fadeUp(0.3)} className="mt-8 flex items-center justify-center gap-5">
            {[
              { icon: ShieldCheck, label: 'Güvenli', color: '#10b981' },
              { icon: Zap, label: 'Hızlı', color: '#f59e0b' },
              { icon: MapPin, label: '7/24', color: '#6366f1' },
            ].map(({ icon: Icon, label, color }) => (
              <div key={label} className="flex items-center gap-1.5 text-[11px] font-semibold text-slate-400">
                <Icon className="h-3.5 w-3.5" style={{ color }} />
                {label}
              </div>
            ))}
          </motion.div>
        </div>
      </div>
    </div>
  );
}
