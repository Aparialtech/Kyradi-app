'use client';

import Link from 'next/link';
import { useEffect, useRef, useState } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import { getToken } from '@/lib/auth';

const story = [
  {
    title: 'Sabah',
    text: 'Otele erken geldin, check-in henüz başlamadı.',
    icon: '☀️',
    glow: 'from-amber-300/50 to-orange-500/10',
  },
  {
    title: 'Öğlen',
    text: 'Bavulunla gezmek istemiyorsun, hızın düşüyor.',
    icon: '🧳',
    glow: 'from-indigo-300/50 to-indigo-600/10',
  },
  {
    title: 'Kyradi',
    text: 'Yakındaki noktaya bırakıyorsun, işlem saniyeler sürüyor.',
    icon: '📍',
    glow: 'from-cyan-300/50 to-cyan-700/10',
  },
  {
    title: 'Sonuç',
    text: 'Ellerin boş. Şehir senin.',
    icon: '✨',
    glow: 'from-violet-300/50 to-violet-700/10',
  },
];

const steps = [
  { no: '01', title: 'Konumunu seç', icon: '📍' },
  { no: '02', title: 'Bavulunu bırak', icon: '🧳' },
  { no: '03', title: 'Özgürce keşfet', icon: '🌍' },
];

const benefits = [
  { title: 'Güvenli teslim', icon: '🧳', text: 'Doğrulanmış noktalarda güvenli emanet.' },
  { title: 'Hızlı rezervasyon', icon: '⚡', text: 'Dakikalar içinde yer ayır, QR ile bırak.' },
  { title: 'Her yerde erişim', icon: '📍', text: 'Şehrin merkezinde, turistik noktalara yakın.' },
  { title: 'Kolay ödeme', icon: '💳', text: 'Uygulama içi hızlı ödeme, sade akış.' },
];

const testimonials = [
  {
    name: 'Zeynep',
    text: 'Check-in saatini beklerken tüm günü valizsiz gezdim. Harika rahatlık.',
  },
  {
    name: 'Can',
    text: 'İlk kullanımda bile çok net. Rezervasyon ve teslim akışı çok hızlı.',
  },
  {
    name: 'Mina',
    text: 'Uçuş öncesi yük taşımadan gezmek artık standartım oldu.',
  },
];

function FadeIn({
  children,
  delay = 0,
  y = 24,
}: {
  children: React.ReactNode;
  delay?: number;
  y?: number;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.2 }}
      transition={{ duration: 0.7, delay, ease: 'easeOut' }}
    >
      {children}
    </motion.div>
  );
}

export default function HomePage() {
  const [hasSession, setHasSession] = useState(false);
  const heroRef = useRef<HTMLDivElement | null>(null);
  const { scrollYProgress } = useScroll({
    target: heroRef,
    offset: ['start start', 'end start'],
  });
  const parallaxY = useTransform(scrollYProgress, [0, 1], [0, 90]);
  const phoneRotate = useTransform(scrollYProgress, [0, 1], [-6, 6]);

  useEffect(() => {
    setHasSession(Boolean(getToken()));
  }, []);

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-[#0B0F1A] text-white">
      <motion.div
        aria-hidden
        className="pointer-events-none absolute inset-0 opacity-90"
        animate={{
          background: [
            'radial-gradient(50rem 50rem at 10% 20%, rgba(99,102,241,0.30), transparent 60%), radial-gradient(42rem 42rem at 90% 12%, rgba(34,211,238,0.22), transparent 62%)',
            'radial-gradient(56rem 56rem at 20% 30%, rgba(99,102,241,0.24), transparent 62%), radial-gradient(46rem 46rem at 80% 18%, rgba(34,211,238,0.24), transparent 65%)',
            'radial-gradient(50rem 50rem at 10% 20%, rgba(99,102,241,0.30), transparent 60%), radial-gradient(42rem 42rem at 90% 12%, rgba(34,211,238,0.22), transparent 62%)',
          ],
        }}
        transition={{ duration: 18, repeat: Infinity, ease: 'linear' }}
      />
      <div className="pointer-events-none absolute inset-0 bg-[url('/landing/map-grid.svg')] bg-center bg-no-repeat opacity-10" />

      <header className="relative z-20 mx-auto flex w-full max-w-7xl items-center justify-between px-5 py-5 md:px-8">
        <div className="flex items-center gap-3">
          <motion.div
            className="h-10 w-10 rounded-2xl bg-gradient-to-br from-[#22D3EE] via-[#6366F1] to-fuchsia-500 shadow-[0_0_30px_rgba(99,102,241,.45)]"
            animate={{ y: [0, -5, 0] }}
            transition={{ duration: 3, repeat: Infinity, ease: 'easeInOut' }}
          />
          <div>
            <p className="text-sm font-semibold tracking-[0.2em] text-white/90">KYRADI</p>
            <p className="text-xs text-white/50">SuperApp</p>
          </div>
        </div>

        <nav className="hidden items-center gap-7 text-sm text-white/70 md:flex">
          <a href="#story" className="hover:text-white">Deneyim</a>
          <a href="#works" className="hover:text-white">Nasıl Çalışır</a>
          <a href="#benefits" className="hover:text-white">Avantajlar</a>
        </nav>

        <div className="flex items-center gap-2">
          {hasSession ? (
            <Link href="/dashboard" className="rounded-xl border border-white/20 bg-white/10 px-4 py-2 text-sm font-medium backdrop-blur">
              Panele Git
            </Link>
          ) : (
            <>
              <Link href="/login" className="rounded-xl border border-white/20 bg-white/10 px-4 py-2 text-sm font-medium backdrop-blur">
                Giriş Yap
              </Link>
              <Link href="/register" className="rounded-xl bg-gradient-to-r from-[#6366F1] to-[#22D3EE] px-4 py-2 text-sm font-semibold text-[#07131e] shadow-[0_0_30px_rgba(34,211,238,.35)]">
                Kayıt Ol
              </Link>
            </>
          )}
        </div>
      </header>

      <section ref={heroRef} className="relative z-10 mx-auto flex min-h-[88vh] w-full max-w-7xl flex-col justify-center px-5 pb-14 pt-6 md:px-8">
        <div className="grid items-center gap-10 lg:grid-cols-2">
          <motion.div style={{ y: parallaxY }}>
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8 }}
              className="mb-5 inline-flex rounded-full border border-white/20 bg-white/10 px-4 py-2 text-xs font-semibold text-white/80 backdrop-blur"
            >
              Seyahatin en hafif hali
            </motion.div>
            <motion.h1
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.9, delay: 0.1 }}
              className="max-w-2xl text-5xl font-semibold leading-tight tracking-[-0.03em] md:text-7xl"
            >
              Bavulunu bırak.
              <br />
              <span className="bg-gradient-to-r from-white via-cyan-200 to-indigo-300 bg-clip-text text-transparent">Şehri keşfet.</span>
            </motion.h1>
            <motion.p
              initial={{ opacity: 0, y: 24 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.2 }}
              className="mt-6 max-w-xl text-lg text-white/70"
            >
              Ağır yüklerden kurtul, anın tadını çıkar. Yakındaki noktayı bul, bavulunu bırak, şehri özgürce yaşa.
            </motion.p>
            <motion.div
              initial={{ opacity: 0, y: 24 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.3 }}
              className="mt-8 flex flex-wrap gap-3"
            >
              <a href="#works" className="group rounded-2xl bg-gradient-to-r from-[#6366F1] to-[#22D3EE] px-6 py-3 font-semibold text-[#07131e] shadow-[0_0_30px_rgba(34,211,238,.35)] transition hover:scale-[1.02]">
                Uygulamayı Keşfet
              </a>
              <a href="#story" className="rounded-2xl border border-white/20 bg-white/10 px-6 py-3 font-semibold text-white backdrop-blur transition hover:bg-white/15">
                Nasıl Çalışır?
              </a>
            </motion.div>
          </motion.div>

          <motion.div style={{ rotate: phoneRotate }} className="relative mx-auto w-full max-w-[420px]">
            <motion.div
              className="absolute -left-10 top-14 h-32 w-32 rounded-full bg-cyan-400/30 blur-3xl"
              animate={{ y: [0, -20, 0] }}
              transition={{ duration: 5, repeat: Infinity, ease: 'easeInOut' }}
            />
            <motion.div
              className="absolute -right-8 -top-5 h-28 w-28 rounded-full bg-indigo-400/35 blur-3xl"
              animate={{ y: [0, 24, 0] }}
              transition={{ duration: 6, repeat: Infinity, ease: 'easeInOut' }}
            />
            <div className="relative overflow-hidden rounded-[2.4rem] border border-white/20 bg-white/5 p-3 shadow-[0_25px_70px_rgba(0,0,0,.45)] backdrop-blur-xl">
              <div className="rounded-[2rem] border border-white/10 bg-[#0f1728] p-4">
                <div className="mb-4 h-8 w-28 rounded-full bg-white/10" />
                <div className="space-y-3">
                  <div className="rounded-2xl border border-cyan-300/20 bg-gradient-to-r from-cyan-400/20 to-indigo-500/20 p-4">
                    <p className="text-xs text-cyan-100/80">Aktif rezervasyon</p>
                    <p className="mt-1 text-lg font-semibold">Beşiktaş KYRADI</p>
                    <p className="text-sm text-white/60">Teslime: 2s 14dk</p>
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div className="rounded-xl border border-white/10 bg-white/5 p-3">
                      <p className="text-xs text-white/50">QR</p>
                      <p className="mt-1 text-sm font-medium">Hazır</p>
                    </div>
                    <div className="rounded-xl border border-white/10 bg-white/5 p-3">
                      <p className="text-xs text-white/50">Durum</p>
                      <p className="mt-1 text-sm font-medium">Müsait</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </section>

      <section id="story" className="relative z-10 mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <FadeIn>
          <h2 className="text-4xl font-semibold tracking-[-0.02em] md:text-5xl">Bir gününü hayal et</h2>
          <p className="mt-3 max-w-2xl text-white/60">Kyradi, seyahat gününü yük taşımaktan deneyim yaşamaya çevirir.</p>
        </FadeIn>
        <div className="mt-10 grid gap-4 md:grid-cols-2">
          {story.map((item, index) => (
            <FadeIn key={item.title} delay={index * 0.08}>
              <motion.article
                whileHover={{ y: -4 }}
                className={`rounded-3xl border border-white/10 bg-gradient-to-br ${item.glow} bg-[#111a2d]/80 p-6 backdrop-blur`}
              >
                <div className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-white/10 text-2xl">
                  {item.icon}
                </div>
                <h3 className="text-2xl font-semibold">{item.title}</h3>
                <p className="mt-2 text-white/65">{item.text}</p>
              </motion.article>
            </FadeIn>
          ))}
        </div>
      </section>

      <section id="works" className="relative z-10 mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <FadeIn>
          <h2 className="text-4xl font-semibold tracking-[-0.02em] md:text-5xl">Nasıl çalışır?</h2>
        </FadeIn>
        <div className="mt-10 grid gap-4 md:grid-cols-3">
          {steps.map((step, i) => (
            <FadeIn key={step.no} delay={i * 0.08}>
              <motion.div whileHover={{ scale: 1.02 }} className="rounded-3xl border border-white/10 bg-white/[0.06] p-6 backdrop-blur">
                <div className="flex items-center justify-between">
                  <span className="text-2xl">{step.icon}</span>
                  <span className="text-sm font-semibold text-cyan-300">{step.no}</span>
                </div>
                <p className="mt-4 text-2xl font-semibold">{step.title}</p>
              </motion.div>
            </FadeIn>
          ))}
        </div>
      </section>

      <section id="benefits" className="relative z-10 mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <FadeIn>
          <h2 className="text-4xl font-semibold tracking-[-0.02em] md:text-5xl">Sana ne kazandırır?</h2>
        </FadeIn>
        <div className="mt-10 grid gap-4 md:grid-cols-2">
          {benefits.map((item, i) => (
            <FadeIn key={item.title} delay={i * 0.07}>
              <motion.article
                whileHover={{ y: -4 }}
                className="group rounded-3xl border border-white/10 bg-white/[0.05] p-6 backdrop-blur transition"
              >
                <div className="inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-[#6366F1]/60 to-[#22D3EE]/50 text-2xl shadow-[0_0_24px_rgba(34,211,238,.25)]">
                  {item.icon}
                </div>
                <h3 className="mt-4 text-2xl font-semibold">{item.title}</h3>
                <p className="mt-2 text-white/65">{item.text}</p>
              </motion.article>
            </FadeIn>
          ))}
        </div>
      </section>

      <section className="relative z-10 mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <FadeIn>
          <div className="rounded-[2rem] border border-white/10 bg-gradient-to-br from-white/[0.08] to-white/[0.03] p-8 backdrop-blur">
            <p className="text-sm font-semibold text-cyan-300">1000+ gezgin kullanıyor</p>
            <h2 className="mt-3 text-4xl font-semibold tracking-[-0.02em] md:text-5xl">Seyahat gününü hafifletiyor.</h2>
            <div className="mt-8 grid gap-4 md:grid-cols-3">
              {testimonials.map((item, i) => (
                <FadeIn key={item.name} delay={0.08 + i * 0.08}>
                  <article className="rounded-2xl border border-white/10 bg-[#111a2b]/70 p-5">
                    <p className="text-white/70">{item.text}</p>
                    <p className="mt-4 text-sm font-semibold text-white/90">{item.name}</p>
                  </article>
                </FadeIn>
              ))}
            </div>
          </div>
        </FadeIn>
      </section>

      <section className="relative z-10 mx-auto w-full max-w-7xl px-5 pb-24 pt-8 md:px-8">
        <FadeIn>
          <div className="rounded-[2rem] border border-cyan-300/20 bg-gradient-to-r from-[#111a2d] via-[#131f38] to-[#0f1b2f] p-8 text-center shadow-[0_0_70px_rgba(99,102,241,.18)]">
            <h2 className="text-4xl font-semibold tracking-[-0.02em] md:text-6xl">Hazır mısın özgür gezmeye?</h2>
            <p className="mx-auto mt-4 max-w-2xl text-white/65">
              Bavulunu bırak, zamanını geri kazan. Şehri gerçekten yaşa.
            </p>
            <div className="mt-8">
              <Link
                href={hasSession ? '/dashboard' : '/register'}
                className="inline-flex rounded-2xl bg-gradient-to-r from-[#6366F1] to-[#22D3EE] px-8 py-4 text-lg font-semibold text-[#06111c] shadow-[0_0_30px_rgba(34,211,238,.35)] transition hover:scale-[1.02]"
              >
                Şimdi Başla
              </Link>
            </div>
          </div>
        </FadeIn>
      </section>
    </main>
  );
}
