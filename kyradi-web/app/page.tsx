'use client';

import Link from 'next/link';
import { useEffect, useMemo, useRef, useState } from 'react';
import { motion } from 'framer-motion';
import {
  ArrowRight,
  CheckCircle2,
  Clock3,
  CreditCard,
  MapPin,
  Navigation,
  Search,
  ShieldCheck,
  Sparkles,
  Smartphone,
  Star,
  Zap,
  Users,
  Lock,
} from 'lucide-react';
import { getToken } from '@/lib/auth';

/* ─────────────────────────── DATA ─────────────────────────── */

const heroSlides = [
  { city: 'İstanbul', title: 'Taksim KYRADI Noktası', subtitle: 'Rezervasyon onaylandı • Teslime hazır', badge: '3 dk uzaklıkta', color: 'from-orange-100 to-rose-50' },
  { city: 'Paris', title: 'Louvre KYRADI Noktası', subtitle: 'Hızlı giriş açık • QR hazır', badge: '5 dk uzaklıkta', color: 'from-violet-100 to-purple-50' },
  { city: 'Londra', title: 'Soho KYRADI Noktası', subtitle: 'Güvenli teslim • Müsait', badge: '4 dk uzaklıkta', color: 'from-sky-100 to-cyan-50' },
];

const steps = [
  { num: '01', icon: Search, title: 'Konumunu seç', text: 'Bulunduğun konuma göre en yakın güvenli teslim noktalarını anında haritada gör.', color: 'bg-indigo-50 text-indigo-600 border-indigo-100' },
  { num: '02', icon: Navigation, title: 'Noktanı bul', text: 'Müsait ve güvenli teslim noktasını seç, saniyeler içinde rezervasyonunu oluştur.', color: 'bg-violet-50 text-violet-600 border-violet-100' },
  { num: '03', icon: CheckCircle2, title: 'Bavulunu bırak ve gez', text: 'QR kodunla bavulunu bırak, günün geri kalanını yük olmadan özgürce geçir.', color: 'bg-emerald-50 text-emerald-600 border-emerald-100' },
];

const story = [
  { num: '1', emoji: '🏨', title: 'Otele erken geldin', text: 'Check-in saatin henüz başlamadı. Sırt çantanla valizin omuzlarında bekliyor. Şehir keşfedilmeyi bekliyor ama sen hareket edemiyorsun.', bg: 'from-orange-50 to-peach-50', accent: '#f97316' },
  { num: '2', emoji: '😓', title: 'Bavulunla gezmek istemiyorsun', text: 'Müzeler, cafeler ve sokaklar seni çağırıyor. Ama ağır valiz her adımı yorucu kılıyor. Bu böyle olmak zorunda değil.', bg: 'from-rose-50 to-pink-50', accent: '#e11d48' },
  { num: '3', emoji: '📍', title: 'Kyradi ile yakın noktayı buluyorsun', text: 'Telefonunu aç, birkaç dokunuşla sana en yakın güvenli teslim noktasına rezervasyon oluştur. 3 dakikadan az sürer.', bg: 'from-indigo-50 to-violet-50', accent: '#6366f1' },
  { num: '4', emoji: '🌟', title: 'Eller boş, gün senin', text: 'Bavulunu güvenle bıraktın. Şimdi şehri gerçekten yaşamaya hazırsın. Hafif adımlar, dolu anlar.', bg: 'from-emerald-50 to-teal-50', accent: '#10b981' },
];

const features = [
  { icon: ShieldCheck, title: 'Güvenli teslim', text: 'Sertifikalı noktalarda tam güvence ile bavulunun korunması.', color: 'bg-emerald-50 text-emerald-600', border: 'border-emerald-100' },
  { icon: Zap, title: 'Hızlı rezervasyon', text: '30 saniyede rezervasyon oluştur, anında onayla.', color: 'bg-yellow-50 text-yellow-600', border: 'border-yellow-100' },
  { icon: MapPin, title: 'Yakındaki noktalar', text: 'Konumuna göre en yakın güvenli teslim noktalarını bul.', color: 'bg-rose-50 text-rose-600', border: 'border-rose-100' },
  { icon: CreditCard, title: 'Kolay ödeme', text: 'Kart, dijital cüzdan veya daha fazla ödeme seçeneği.', color: 'bg-blue-50 text-blue-600', border: 'border-blue-100' },
  { icon: Sparkles, title: 'Basit deneyim', text: 'Sezgisel arayüz ile her yaştan kullanıcı için tasarlandı.', color: 'bg-purple-50 text-purple-600', border: 'border-purple-100' },
  { icon: Smartphone, title: 'Anlık erişim', text: 'QR kod ile saniyeler içinde teslim ve geri alma.', color: 'bg-indigo-50 text-indigo-600', border: 'border-indigo-100' },
];

const testimonials = [
  { name: 'Elif Y.', role: 'Backpacker', text: 'İstanbul turumda valiz taşımadan tüm günümü rahatça geçirdim. Kesinlikle hayat kurtarıcı!', rating: 5, avatar: 'E' },
  { name: 'Can A.', role: 'İş Seyahati', text: 'Arayüz çok temiz ve hızlı. Rezervasyon akışı mükemmel. Her seyahatimde kullanıyorum.', rating: 5, avatar: 'C' },
  { name: 'Mina K.', role: 'Turist', text: 'Uçuş öncesi saatlerde şehri gezmek isteyenler için gerçekten vazgeçilmez bir uygulama.', rating: 5, avatar: 'M' },
];

const stats = [
  { value: '1000+', label: 'Mutlu Gezgin', icon: Users, color: 'text-indigo-600' },
  { value: '3 dk', label: 'Ortalama Mesafe', icon: MapPin, color: 'text-rose-500' },
  { value: '7/24', label: 'Şehir İçi Erişim', icon: Clock3, color: 'text-emerald-500' },
];

/* ─────────────────────────── HELPERS ─────────────────────────── */

function Reveal({ children, delay = 0, className = '' }: { children: React.ReactNode; delay?: number; className?: string }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 28 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.15 }}
      transition={{ duration: 0.55, delay, ease: [0.22, 1, 0.36, 1] }}
      className={className}
    >
      {children}
    </motion.div>
  );
}

function SectionLabel({ children }: { children: React.ReactNode }) {
  return (
    <span className="inline-flex items-center gap-2 rounded-full bg-indigo-50 border border-indigo-100 px-4 py-1.5 text-xs font-semibold tracking-wide text-indigo-600 uppercase">
      {children}
    </span>
  );
}

/* ─────────────────────────── PHONE MOCKUP ─────────────────────────── */

function PhoneMockup({ slide }: { slide: typeof heroSlides[0] }) {
  return (
    <div className="relative mx-auto w-[270px]">
      {/* Phone shell */}
      <div className="relative rounded-[42px] bg-slate-900 p-[10px] shadow-[0_40px_80px_rgba(15,23,42,0.35),0_0_0_1px_rgba(255,255,255,0.08)]">
        {/* Screen */}
        <div className={`h-[540px] w-full overflow-hidden rounded-[34px] bg-gradient-to-b ${slide.color}`}>
          {/* Status bar */}
          <div className="flex items-center justify-between px-5 pt-4 pb-2">
            <span className="text-[10px] font-semibold text-slate-600">9:41</span>
            <div className="h-5 w-20 rounded-full bg-slate-900/10 mx-auto" />
            <div className="flex gap-1">
              <div className="h-2 w-2 rounded-full bg-slate-400" />
              <div className="h-2 w-2 rounded-full bg-slate-400" />
            </div>
          </div>

          {/* App header */}
          <div className="px-4 pt-2 pb-3">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-[10px] text-slate-500">Hoş geldin</p>
                <p className="text-sm font-bold text-slate-800">{slide.city} 👋</p>
              </div>
              <div className="h-8 w-8 rounded-full bg-gradient-to-br from-indigo-400 to-violet-500 shadow-md" />
            </div>
          </div>

          {/* Map area */}
          <div className="mx-4 rounded-2xl bg-white/70 backdrop-blur p-3 shadow-sm border border-white/80">
            <div className="relative h-28 rounded-xl overflow-hidden bg-gradient-to-br from-slate-100 to-indigo-50">
              {/* Grid lines simulating a map */}
              <svg className="absolute inset-0 w-full h-full" xmlns="http://www.w3.org/2000/svg">
                <defs>
                  <pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse">
                    <path d="M 20 0 L 0 0 0 20" fill="none" stroke="rgba(99,102,241,0.12)" strokeWidth="1"/>
                  </pattern>
                </defs>
                <rect width="100%" height="100%" fill="url(#grid)" />
                {/* Roads */}
                <line x1="0" y1="60" x2="200" y2="60" stroke="rgba(255,255,255,0.9)" strokeWidth="6"/>
                <line x1="90" y1="0" x2="90" y2="120" stroke="rgba(255,255,255,0.9)" strokeWidth="4"/>
                <line x1="0" y1="90" x2="200" y2="90" stroke="rgba(255,255,255,0.7)" strokeWidth="3"/>
              </svg>
              {/* Pin */}
              <div className="absolute top-8 left-16 flex flex-col items-center">
                <div className="h-6 w-6 rounded-full bg-indigo-600 border-2 border-white shadow-lg flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-white" />
                </div>
                <div className="h-2 w-0.5 bg-indigo-600" />
              </div>
              {/* User location */}
              <div className="absolute bottom-4 right-8">
                <div className="h-5 w-5 rounded-full bg-blue-500 border-2 border-white shadow-md" />
                <div className="absolute inset-0 rounded-full bg-blue-400 opacity-30 animate-ping" />
              </div>
            </div>
            <div className="mt-2 flex items-center justify-between">
              <p className="text-[10px] font-semibold text-slate-700">{slide.badge}</p>
              <span className="text-[9px] bg-emerald-100 text-emerald-600 rounded-full px-2 py-0.5 font-semibold">Müsait</span>
            </div>
          </div>

          {/* Reservation card */}
          <div className="mx-4 mt-3 rounded-2xl bg-white/80 backdrop-blur border border-white/90 p-3 shadow-sm">
            <div className="flex items-start gap-2">
              <div className="mt-0.5 h-7 w-7 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center flex-shrink-0">
                <div className="h-3 w-3 rounded-sm bg-white/80" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-[10px] text-slate-400">Aktif rezervasyon</p>
                <p className="text-xs font-bold text-slate-800 truncate">{slide.title}</p>
                <p className="text-[9px] text-slate-500">{slide.subtitle}</p>
              </div>
            </div>
          </div>

          {/* Quick actions */}
          <div className="mx-4 mt-3 grid grid-cols-2 gap-2">
            <div className="rounded-xl bg-white/70 border border-white/80 p-2.5 flex items-center gap-1.5">
              <div className="h-5 w-5 rounded-lg bg-indigo-100 flex items-center justify-center">
                <div className="h-2 w-2 rounded-sm border border-indigo-400" />
              </div>
              <span className="text-[9px] font-semibold text-slate-700">QR Göster</span>
            </div>
            <div className="rounded-xl bg-white/70 border border-white/80 p-2.5 flex items-center gap-1.5">
              <div className="h-5 w-5 rounded-lg bg-emerald-100 flex items-center justify-center">
                <div className="h-2 w-2 rounded-full bg-emerald-500" />
              </div>
              <span className="text-[9px] font-semibold text-slate-700">Güvenli</span>
            </div>
          </div>
        </div>
      </div>

      {/* Notch */}
      <div className="absolute top-[14px] left-1/2 -translate-x-1/2 h-6 w-28 rounded-full bg-slate-900 z-10" />
    </div>
  );
}

/* ─────────────────────────── PAGE ─────────────────────────── */

export default function HomePage() {
  const [hasSession, setHasSession] = useState(false);
  const [activeSlide, setActiveSlide] = useState(0);
  const heroRef = useRef<HTMLDivElement>(null);

  useEffect(() => { setHasSession(Boolean(getToken())); }, []);

  useEffect(() => {
    const iv = setInterval(() => setActiveSlide(p => (p + 1) % heroSlides.length), 4400);
    return () => clearInterval(iv);
  }, []);

  const slide = useMemo(() => heroSlides[activeSlide], [activeSlide]);

  return (
    <main className="bg-white text-slate-900 overflow-x-hidden" style={{ fontFamily: "'SF Pro Display','SF Pro Text',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif" }}>

      {/* ═══════════════════ HEADER ═══════════════════ */}
      <header className="sticky top-0 z-50 border-b border-slate-100 bg-white/80 backdrop-blur-xl">
        <div className="max-w-[1200px] mx-auto px-6">
          <div className="flex items-center justify-between h-16">
            {/* Logo */}
            <div className="flex items-center gap-3">
              <div className="relative h-9 w-9">
                <div className="h-9 w-9 rounded-xl bg-gradient-to-br from-indigo-500 via-violet-500 to-cyan-400 shadow-[0_8px_20px_rgba(99,102,241,0.35)]" />
                <div className="absolute inset-0 rounded-xl bg-gradient-to-br from-white/30 to-transparent" />
              </div>
              <div className="flex flex-col">
                <span className="text-[13px] font-black tracking-[0.2em] text-slate-900">KYRADI</span>
                <span className="text-[10px] text-slate-400 font-medium tracking-wide -mt-0.5">SuperApp</span>
              </div>
            </div>

            {/* Nav */}
            <nav className="hidden md:flex items-center gap-1">
              {[['#works', 'Nasıl Çalışır'], ['#features', 'Özellikler'], ['#reviews', 'Yorumlar']].map(([href, label]) => (
                <a key={href} href={href} className="px-4 py-2 rounded-full text-sm font-medium text-slate-500 hover:text-slate-900 hover:bg-slate-50 transition-all">
                  {label}
                </a>
              ))}
            </nav>

            {/* CTA */}
            <div className="flex items-center gap-3">
              <Link href="/login" className="hidden sm:block text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors px-4 py-2">
                Giriş Yap
              </Link>
              <Link
                href={hasSession ? '/dashboard' : '/register'}
                className="flex items-center gap-2 rounded-full bg-gradient-to-r from-indigo-600 to-violet-600 px-5 py-2.5 text-sm font-semibold text-white shadow-[0_8px_20px_rgba(99,102,241,0.3)] hover:shadow-[0_12px_28px_rgba(99,102,241,0.4)] hover:-translate-y-0.5 transition-all"
              >
                Uygulamayı Keşfet
                <ArrowRight className="h-3.5 w-3.5" />
              </Link>
            </div>
          </div>
        </div>
      </header>

      {/* ═══════════════════ HERO ═══════════════════ */}
      <section ref={heroRef} className="relative overflow-hidden pt-20 pb-28" style={{ background: 'radial-gradient(80rem 60rem at 110% -10%, rgba(99,102,241,0.1), transparent 60%), radial-gradient(60rem 50rem at -10% 30%, rgba(251,191,36,0.08), transparent 55%), radial-gradient(50rem 40rem at 50% 120%, rgba(34,211,238,0.08), transparent 60%)' }}>
        {/* Decorative blobs */}
        <div className="pointer-events-none absolute -top-32 -right-32 h-[500px] w-[500px] rounded-full bg-gradient-to-br from-indigo-100/60 to-violet-100/40 blur-3xl" />
        <div className="pointer-events-none absolute top-48 -left-24 h-[300px] w-[300px] rounded-full bg-gradient-to-br from-cyan-100/50 to-sky-100/30 blur-2xl" />

        <div className="max-w-[1200px] mx-auto px-6">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">

            {/* Left: Text */}
            <div className="space-y-7">
              <Reveal>
                <span className="inline-flex items-center gap-2 rounded-full border border-amber-200 bg-gradient-to-r from-amber-50 to-orange-50 px-4 py-1.5 text-xs font-semibold text-amber-700">
                  <span className="h-1.5 w-1.5 rounded-full bg-amber-500 animate-pulse" />
                  Seyahatin en hafif hali
                </span>
              </Reveal>

              <Reveal delay={0.06}>
                <h1 className="text-[3.6rem] leading-[1.08] font-black tracking-[-0.03em] text-slate-900">
                  Bavulunu bırak.<br />
                  <span className="bg-gradient-to-r from-indigo-600 via-violet-600 to-cyan-500 bg-clip-text text-transparent">
                    Şehri özgürce
                  </span>
                  <br />keşfet.
                </h1>
              </Reveal>

              <Reveal delay={0.12}>
                <p className="text-lg leading-relaxed text-slate-500 max-w-lg">
                  Ağır yüklerden kurtul, yakındaki güvenli noktayı bul, bavulunu bırak ve anın tadını çıkar. Kyradi ile şehir senin.
                </p>
              </Reveal>

              <Reveal delay={0.16}>
                <div className="flex flex-wrap gap-3">
                  <Link
                    href={hasSession ? '/dashboard' : '/register'}
                    className="flex items-center gap-2 rounded-full bg-gradient-to-r from-indigo-600 to-violet-600 px-7 py-3.5 text-[15px] font-semibold text-white shadow-[0_12px_28px_rgba(99,102,241,0.35)] hover:shadow-[0_16px_36px_rgba(99,102,241,0.45)] hover:-translate-y-0.5 transition-all"
                  >
                    Uygulamayı Keşfet
                    <ArrowRight className="h-4 w-4" />
                  </Link>
                  <a
                    href="#works"
                    className="flex items-center gap-2 rounded-full border border-slate-200 bg-white px-7 py-3.5 text-[15px] font-semibold text-slate-700 hover:border-slate-300 hover:bg-slate-50 transition-all shadow-sm"
                  >
                    Nasıl Çalışır?
                  </a>
                </div>
              </Reveal>

              <Reveal delay={0.2}>
                <div className="flex items-center gap-4">
                  <div className="flex -space-x-2">
                    {['bg-rose-400', 'bg-amber-400', 'bg-indigo-400', 'bg-emerald-400'].map((c, i) => (
                      <div key={i} className={`h-8 w-8 rounded-full ${c} border-2 border-white shadow-sm`} />
                    ))}
                  </div>
                  <div>
                    <div className="flex items-center gap-0.5">
                      {[...Array(5)].map((_, i) => <Star key={i} className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />)}
                    </div>
                    <p className="text-xs text-slate-500 mt-0.5">1000+ gezgin tarafından güvenildi</p>
                  </div>
                </div>
              </Reveal>

              <Reveal delay={0.24}>
                <div className="flex flex-wrap gap-4">
                  {[
                    { icon: ShieldCheck, label: 'Güvenli noktalar', color: 'text-emerald-500' },
                    { icon: Zap, label: 'Hızlı rezervasyon', color: 'text-amber-500' },
                    { icon: Smartphone, label: 'Kolay kullanım', color: 'text-indigo-500' },
                  ].map(({ icon: Icon, label, color }) => (
                    <div key={label} className="flex items-center gap-1.5 text-sm text-slate-500">
                      <Icon className={`h-4 w-4 ${color}`} />
                      {label}
                    </div>
                  ))}
                </div>
              </Reveal>
            </div>

            {/* Right: Phone + floating cards */}
            <Reveal delay={0.1}>
              <div className="relative flex justify-center lg:justify-end">
                {/* Background panel */}
                <div className={`absolute inset-8 rounded-[48px] bg-gradient-to-br ${slide.color} blur-2xl opacity-60 transition-all duration-700`} />

                {/* Floating badge TL */}
                <motion.div
                  animate={{ y: [0, -8, 0] }}
                  transition={{ duration: 3.8, repeat: Infinity, ease: 'easeInOut' }}
                  className="absolute -left-4 top-16 z-20 hidden lg:flex items-center gap-2.5 rounded-2xl bg-white px-4 py-3 shadow-[0_8px_24px_rgba(15,23,42,0.12)] border border-slate-100"
                >
                  <CheckCircle2 className="h-5 w-5 text-emerald-500 flex-shrink-0" />
                  <div>
                    <p className="text-xs font-bold text-slate-800">Rezervasyon onaylandı</p>
                    <p className="text-[10px] text-slate-400">Az önce</p>
                  </div>
                </motion.div>

                {/* Floating badge TR */}
                <motion.div
                  animate={{ y: [0, 10, 0] }}
                  transition={{ duration: 4.2, repeat: Infinity, ease: 'easeInOut', delay: 0.6 }}
                  className="absolute -right-4 top-32 z-20 hidden lg:flex items-center gap-2.5 rounded-2xl bg-white px-4 py-3 shadow-[0_8px_24px_rgba(15,23,42,0.12)] border border-slate-100"
                >
                  <div className="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center flex-shrink-0">
                    <MapPin className="h-4 w-4 text-indigo-600" />
                  </div>
                  <div>
                    <p className="text-xs font-bold text-slate-800">{slide.badge}</p>
                    <p className="text-[10px] text-slate-400">{slide.city}</p>
                  </div>
                </motion.div>

                {/* Floating badge bottom */}
                <motion.div
                  animate={{ y: [0, -6, 0] }}
                  transition={{ duration: 3.2, repeat: Infinity, ease: 'easeInOut', delay: 1 }}
                  className="absolute -left-4 bottom-24 z-20 hidden lg:flex items-center gap-2 rounded-2xl bg-white px-4 py-3 shadow-[0_8px_24px_rgba(15,23,42,0.12)] border border-slate-100"
                >
                  <Lock className="h-4 w-4 text-cyan-500" />
                  <p className="text-xs font-semibold text-slate-700">Güvenli teslim</p>
                </motion.div>

                {/* Phone */}
                <motion.div
                  animate={{ y: [0, -12, 0] }}
                  transition={{ duration: 5.5, repeat: Infinity, ease: 'easeInOut' }}
                  className="relative z-10"
                >
                  <PhoneMockup slide={slide} />
                </motion.div>

                {/* Slide dots */}
                <div className="absolute -bottom-6 left-1/2 -translate-x-1/2 flex gap-2">
                  {heroSlides.map((_, i) => (
                    <button
                      key={i}
                      onClick={() => setActiveSlide(i)}
                      className={`h-2 rounded-full transition-all duration-300 ${i === activeSlide ? 'w-7 bg-indigo-500' : 'w-2 bg-slate-300'}`}
                    />
                  ))}
                </div>
              </div>
            </Reveal>
          </div>
        </div>
      </section>

      {/* ═══════════════════ STATS ═══════════════════ */}
      <section className="py-16 border-y border-slate-100">
        <div className="max-w-[1200px] mx-auto px-6">
          <div className="grid grid-cols-1 md:grid-cols-3 divide-y md:divide-y-0 md:divide-x divide-slate-100">
            {stats.map((stat, i) => (
              <Reveal key={stat.label} delay={i * 0.06}>
                <div className="flex items-center gap-4 py-6 md:py-0 md:px-12 first:md:pl-0 last:md:pr-0">
                  <div className={`h-12 w-12 rounded-2xl flex items-center justify-center ${stat.color === 'text-indigo-600' ? 'bg-indigo-50' : stat.color === 'text-rose-500' ? 'bg-rose-50' : 'bg-emerald-50'}`}>
                    <stat.icon className={`h-5 w-5 ${stat.color}`} />
                  </div>
                  <div>
                    <p className="text-3xl font-black tracking-tight text-slate-900">{stat.value}</p>
                    <p className="text-sm text-slate-500 font-medium">{stat.label}</p>
                  </div>
                </div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════════════ HOW IT WORKS ═══════════════════ */}
      <section id="works" className="py-28">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <SectionLabel>Nasıl Çalışır?</SectionLabel>
            <h2 className="mt-5 text-[2.8rem] font-black tracking-[-0.03em] text-slate-900">3 adımda yük olmadan gez</h2>
            <p className="mt-4 text-lg text-slate-500 max-w-lg mx-auto">Kyradi ile bavul derdi 3 dakikadan kısa sürede çözülür.</p>
          </Reveal>

          <div className="relative grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Connecting line */}
            <div className="absolute top-12 left-[calc(16.666%+12px)] right-[calc(16.666%+12px)] hidden md:block h-px bg-gradient-to-r from-indigo-200 via-violet-200 to-emerald-200" />

            {steps.map((step, i) => (
              <Reveal key={step.title} delay={i * 0.08}>
                <motion.div
                  whileHover={{ y: -6, boxShadow: '0 20px 40px rgba(15,23,42,0.1)' }}
                  transition={{ duration: 0.25 }}
                  className="relative rounded-[28px] border border-slate-100 bg-white p-7 shadow-[0_4px_20px_rgba(15,23,42,0.06)] cursor-default"
                >
                  {/* Step number bubble */}
                  <div className={`relative z-10 mb-5 inline-flex h-12 w-12 items-center justify-center rounded-2xl border ${step.color}`}>
                    <step.icon className="h-5 w-5" />
                    <span className="absolute -top-2 -right-2 flex h-5 w-5 items-center justify-center rounded-full bg-slate-900 text-[9px] font-black text-white">
                      {i + 1}
                    </span>
                  </div>
                  <h3 className="text-xl font-bold text-slate-900">{step.title}</h3>
                  <p className="mt-2 text-sm leading-relaxed text-slate-500">{step.text}</p>
                </motion.div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════════════ STORY ═══════════════════ */}
      <section id="story" className="py-28 bg-gradient-to-b from-slate-50/80 to-white">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <SectionLabel>Deneyim</SectionLabel>
            <h2 className="mt-5 text-[2.8rem] font-black tracking-[-0.03em] text-slate-900">Şehri taşımadan yaşa</h2>
            <p className="mt-4 text-lg text-slate-500 max-w-lg mx-auto">Her seyahatçinin hissettiği o duygu — ve çözümü.</p>
          </Reveal>

          <div className="space-y-5">
            {story.map((item, i) => (
              <Reveal key={item.title} delay={i * 0.06}>
                <div className={`grid grid-cols-1 md:grid-cols-2 gap-0 rounded-[28px] overflow-hidden border border-slate-100 shadow-[0_4px_20px_rgba(15,23,42,0.05)]`}>
                  {/* Text side */}
                  <div className={`flex items-center p-8 bg-white ${i % 2 === 1 ? 'md:order-2' : ''}`}>
                    <div>
                      <div className="mb-4 flex items-center gap-3">
                        <div className="flex h-9 w-9 items-center justify-center rounded-full bg-slate-100 text-lg font-black text-slate-700">
                          {item.num}
                        </div>
                        <span className="text-2xl">{item.emoji}</span>
                      </div>
                      <h3 className="text-2xl font-bold text-slate-900">{item.title}</h3>
                      <p className="mt-3 text-base leading-relaxed text-slate-500">{item.text}</p>
                    </div>
                  </div>
                  {/* Visual side */}
                  <div className={`relative overflow-hidden bg-gradient-to-br ${item.bg} min-h-[180px] ${i % 2 === 1 ? 'md:order-1' : ''}`}>
                    <div className="absolute inset-0 flex items-center justify-center">
                      <span className="text-8xl opacity-20 select-none">{item.emoji}</span>
                    </div>
                    <div className="absolute bottom-4 right-4">
                      <div className="flex items-center gap-2 rounded-2xl bg-white/80 backdrop-blur px-4 py-2.5 shadow-sm border border-white">
                        <div className="h-2 w-2 rounded-full animate-pulse" style={{ background: item.accent }} />
                        <span className="text-xs font-semibold text-slate-700">{item.title}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════════════ FEATURES ═══════════════════ */}
      <section id="features" className="py-28">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <SectionLabel>Özellikler</SectionLabel>
            <h2 className="mt-5 text-[2.8rem] font-black tracking-[-0.03em] text-slate-900">Seyahatini kolaylaştıran detaylar</h2>
            <p className="mt-4 text-lg text-slate-500 max-w-lg mx-auto">Her detay, seyahatini daha hafif ve özgür kılmak için tasarlandı.</p>
          </Reveal>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {features.map((feat, i) => (
              <Reveal key={feat.title} delay={i * 0.05}>
                <motion.div
                  whileHover={{ y: -5, boxShadow: '0 20px 40px rgba(15,23,42,0.09)' }}
                  transition={{ duration: 0.22 }}
                  className="rounded-[24px] border border-slate-100 bg-white p-7 shadow-[0_2px_12px_rgba(15,23,42,0.05)] cursor-default"
                >
                  <div className={`mb-5 inline-flex h-12 w-12 items-center justify-center rounded-2xl border ${feat.border} ${feat.color.split(' ')[0]}`}>
                    <feat.icon className={`h-5 w-5 ${feat.color.split(' ')[1]}`} />
                  </div>
                  <h3 className="text-lg font-bold text-slate-900">{feat.title}</h3>
                  <p className="mt-2 text-sm leading-relaxed text-slate-500">{feat.text}</p>
                </motion.div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════════════ MOBILE PREVIEW ═══════════════════ */}
      <section id="mobile" className="py-28 overflow-hidden bg-gradient-to-b from-white to-slate-50/60">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <SectionLabel>Mobil Uygulama</SectionLabel>
            <h2 className="mt-5 text-[2.8rem] font-black tracking-[-0.03em] text-slate-900">Premium uygulama deneyimi</h2>
            <p className="mt-4 text-lg text-slate-500 max-w-lg mx-auto">Temiz arayüz, hızlı akış, sezgisel tasarım.</p>
          </Reveal>

          <div className="relative flex items-end justify-center gap-5 py-10">
            {/* Background glow */}
            <div className="pointer-events-none absolute inset-0 rounded-[40px] bg-gradient-to-br from-indigo-50 via-violet-50/30 to-cyan-50/30" />

            {/* Phone 1 — left, rotated */}
            <Reveal delay={0.04}>
              <motion.div
                animate={{ y: [0, -8, 0] }}
                transition={{ duration: 4.8, repeat: Infinity, ease: 'easeInOut', delay: 0.4 }}
                className="relative -rotate-6 z-10"
                style={{ transformOrigin: 'bottom center' }}
              >
                <div className="rounded-[36px] bg-slate-900 p-[8px] shadow-[0_30px_60px_rgba(15,23,42,0.25)]" style={{ width: 210 }}>
                  <div className="rounded-[30px] overflow-hidden bg-gradient-to-b from-indigo-50 to-purple-50" style={{ height: 400 }}>
                    {/* Simulated screen 1: Map */}
                    <div className="p-4">
                      <div className="flex items-center gap-2 mb-3">
                        <div className="h-6 w-6 rounded-full bg-gradient-to-br from-indigo-500 to-violet-500" />
                        <div className="h-3 w-16 rounded-full bg-slate-200" />
                      </div>
                      <div className="h-4 w-28 rounded-full bg-slate-800 mb-4 ml-1" />
                      <div className="rounded-2xl bg-white/80 p-3 shadow-sm mb-3">
                        <div className="h-32 rounded-xl bg-gradient-to-br from-indigo-100 to-sky-50 relative overflow-hidden">
                          <svg className="absolute inset-0 w-full h-full"><defs><pattern id="g2" width="18" height="18" patternUnits="userSpaceOnUse"><path d="M 18 0 L 0 0 0 18" fill="none" stroke="rgba(99,102,241,0.15)" strokeWidth="1"/></pattern></defs><rect width="100%" height="100%" fill="url(#g2)"/><line x1="0" y1="65" x2="240" y2="65" stroke="rgba(255,255,255,0.95)" strokeWidth="5"/><line x1="80" y1="0" x2="80" y2="140" stroke="rgba(255,255,255,0.8)" strokeWidth="3"/></svg>
                          <div className="absolute top-6 left-14 h-5 w-5 rounded-full bg-indigo-600 border-2 border-white shadow-md" />
                        </div>
                      </div>
                      <div className="space-y-2">
                        {[1, 2].map(j => (
                          <div key={j} className="flex items-center gap-2 rounded-xl bg-white/70 p-2.5">
                            <div className="h-6 w-6 rounded-lg bg-indigo-100" />
                            <div className="flex-1 space-y-1">
                              <div className="h-2 rounded-full bg-slate-200" />
                              <div className="h-1.5 w-3/4 rounded-full bg-slate-100" />
                            </div>
                            <div className="h-4 w-10 rounded-full bg-emerald-100" />
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </motion.div>
            </Reveal>

            {/* Phone 2 — center, main */}
            <Reveal delay={0.0}>
              <motion.div
                animate={{ y: [0, -14, 0] }}
                transition={{ duration: 5.5, repeat: Infinity, ease: 'easeInOut' }}
                className="relative z-20"
              >
                <div className="rounded-[42px] bg-slate-900 p-[10px] shadow-[0_50px_100px_rgba(15,23,42,0.35)]" style={{ width: 250 }}>
                  <div className="rounded-[34px] overflow-hidden bg-gradient-to-b from-indigo-100 to-violet-50" style={{ height: 480 }}>
                    {/* Status bar */}
                    <div className="flex items-center justify-between px-5 pt-3">
                      <span className="text-[9px] font-bold text-slate-600">9:41</span>
                      <div className="h-5 w-16 rounded-full bg-slate-900/10" />
                      <div className="flex gap-1"><div className="h-1.5 w-1.5 rounded-full bg-slate-500"/><div className="h-1.5 w-1.5 rounded-full bg-slate-500"/></div>
                    </div>
                    <div className="px-4 pt-3">
                      <div className="flex items-center justify-between mb-3">
                        <div>
                          <p className="text-[9px] text-slate-400">İstanbul</p>
                          <p className="text-sm font-black text-slate-900">KYRADI</p>
                        </div>
                        <div className="h-8 w-8 rounded-full bg-gradient-to-br from-indigo-500 to-violet-600 shadow-md" />
                      </div>
                      {/* Active reservation */}
                      <div className="rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 p-3 text-white mb-3 shadow-lg">
                        <p className="text-[9px] opacity-75 mb-1">Aktif rezervasyon</p>
                        <p className="text-xs font-bold">Taksim KYRADI Noktası</p>
                        <p className="text-[9px] opacity-80 mt-0.5">Teslime 2s 14dk</p>
                        <div className="mt-2 flex gap-1.5">
                          <div className="flex-1 rounded-lg bg-white/20 py-1 text-center text-[8px] font-semibold">QR Göster</div>
                          <div className="flex-1 rounded-lg bg-white/20 py-1 text-center text-[8px] font-semibold">Yönlendir</div>
                        </div>
                      </div>
                      {/* Map */}
                      <div className="rounded-2xl bg-white/70 p-2.5 mb-3 border border-white/80">
                        <div className="h-24 rounded-xl bg-gradient-to-br from-slate-100 to-indigo-50 relative overflow-hidden">
                          <svg className="absolute inset-0 w-full h-full"><defs><pattern id="g3" width="16" height="16" patternUnits="userSpaceOnUse"><path d="M 16 0 L 0 0 0 16" fill="none" stroke="rgba(99,102,241,0.12)" strokeWidth="1"/></pattern></defs><rect width="100%" height="100%" fill="url(#g3)"/><line x1="0" y1="50" x2="250" y2="50" stroke="rgba(255,255,255,1)" strokeWidth="5"/><line x1="110" y1="0" x2="110" y2="100" stroke="rgba(255,255,255,0.9)" strokeWidth="3"/></svg>
                          <div className="absolute top-4 left-14 h-5 w-5 rounded-full bg-indigo-600 border-2 border-white shadow-md" />
                          <div className="absolute bottom-5 right-8 h-4 w-4 rounded-full bg-blue-500 border-2 border-white" />
                        </div>
                        <p className="text-[9px] text-slate-500 mt-1 font-medium">3 dk uzaklıkta • Müsait</p>
                      </div>
                      {/* Quick stats */}
                      <div className="grid grid-cols-2 gap-2">
                        {[['💼', 'Valiz', '1 adet'],['🕐', 'Süre', '2 gün']].map(([emoji, label, val]) => (
                          <div key={label} className="rounded-xl bg-white/70 p-2 border border-white/80 text-center">
                            <p className="text-base">{emoji}</p>
                            <p className="text-[8px] text-slate-400">{label}</p>
                            <p className="text-[10px] font-bold text-slate-800">{val}</p>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </motion.div>
            </Reveal>

            {/* Phone 3 — right, rotated */}
            <Reveal delay={0.08}>
              <motion.div
                animate={{ y: [0, -9, 0] }}
                transition={{ duration: 4.5, repeat: Infinity, ease: 'easeInOut', delay: 0.8 }}
                className="relative rotate-6 z-10"
                style={{ transformOrigin: 'bottom center' }}
              >
                <div className="rounded-[36px] bg-slate-900 p-[8px] shadow-[0_30px_60px_rgba(15,23,42,0.25)]" style={{ width: 210 }}>
                  <div className="rounded-[30px] overflow-hidden bg-gradient-to-b from-violet-50 to-fuchsia-50" style={{ height: 400 }}>
                    <div className="p-4">
                      <div className="h-4 w-20 rounded-full bg-slate-800 mb-4" />
                      {/* Payment screen */}
                      <div className="rounded-2xl bg-white/80 p-3 shadow-sm mb-3">
                        <p className="text-[9px] text-slate-400 mb-1.5">Cüzdan</p>
                        <p className="text-2xl font-black text-slate-900">₺240</p>
                        <p className="text-[9px] text-emerald-500 font-semibold">+₺20 bu ay kazanıldı</p>
                      </div>
                      <div className="space-y-2">
                        {['Taksim teslimi', 'Beyoğlu teslimi', 'Kadıköy teslimi'].map((t, j) => (
                          <div key={t} className="flex items-center gap-2 rounded-xl bg-white/70 p-2.5">
                            <div className={`h-6 w-6 rounded-full ${['bg-rose-100','bg-indigo-100','bg-amber-100'][j]}`} />
                            <div className="flex-1">
                              <p className="text-[10px] font-semibold text-slate-700">{t}</p>
                              <p className="text-[8px] text-slate-400">₺{[30,25,35][j]}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </motion.div>
            </Reveal>
          </div>
        </div>
      </section>

      {/* ═══════════════════ TESTIMONIALS ═══════════════════ */}
      <section id="reviews" className="py-28">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <SectionLabel>Yorumlar</SectionLabel>
            <h2 className="mt-5 text-[2.8rem] font-black tracking-[-0.03em] text-slate-900">Gezginler ne diyor?</h2>
            <p className="mt-4 text-lg text-slate-500 max-w-md mx-auto">1000+ gezginden gerçek deneyimler.</p>
          </Reveal>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            {testimonials.map((t, i) => (
              <Reveal key={t.name} delay={i * 0.07}>
                <motion.div
                  whileHover={{ y: -5 }}
                  className="rounded-[24px] border border-slate-100 bg-white p-7 shadow-[0_4px_20px_rgba(15,23,42,0.06)] cursor-default"
                >
                  {/* Stars */}
                  <div className="flex gap-0.5 mb-5">
                    {[...Array(5)].map((_, j) => (
                      <Star key={j} className="h-4 w-4 fill-amber-400 text-amber-400" />
                    ))}
                  </div>
                  <p className="text-[15px] leading-relaxed text-slate-600">&ldquo;{t.text}&rdquo;</p>
                  <div className="mt-5 flex items-center gap-3 pt-5 border-t border-slate-100">
                    <div className={`flex h-10 w-10 items-center justify-center rounded-full font-bold text-white ${['bg-gradient-to-br from-rose-400 to-orange-400', 'bg-gradient-to-br from-indigo-500 to-violet-500', 'bg-gradient-to-br from-emerald-400 to-teal-500'][i]}`}>
                      {t.avatar}
                    </div>
                    <div>
                      <p className="text-sm font-bold text-slate-900">{t.name}</p>
                      <p className="text-xs text-slate-400">{t.role}</p>
                    </div>
                  </div>
                </motion.div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════════════ CTA ═══════════════════ */}
      <section className="py-28">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal>
            <div className="relative overflow-hidden rounded-[40px] bg-gradient-to-br from-indigo-600 via-violet-600 to-indigo-700 px-8 py-20 text-center shadow-[0_40px_80px_rgba(99,102,241,0.35)]">
              {/* Decorative circles */}
              <div className="pointer-events-none absolute -top-20 -left-20 h-80 w-80 rounded-full bg-white/5 blur-xl" />
              <div className="pointer-events-none absolute -bottom-20 -right-20 h-96 w-96 rounded-full bg-violet-400/20 blur-2xl" />
              <div className="pointer-events-none absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 h-full w-full" style={{ background: 'radial-gradient(60% 60% at 50% 50%, rgba(255,255,255,0.05) 0%, transparent 100%)' }} />

              <div className="relative z-10 space-y-7 max-w-3xl mx-auto">
                <span className="inline-flex items-center gap-2 rounded-full bg-white/10 border border-white/20 px-4 py-1.5 text-xs font-semibold text-white/80 uppercase tracking-wide">
                  <span className="h-1.5 w-1.5 rounded-full bg-emerald-400 animate-pulse" />
                  Seyahate hazır
                </span>
                <h2 className="text-[3rem] font-black tracking-[-0.03em] text-white leading-tight">
                  Hazır mısın özgür<br />gezmeye?
                </h2>
                <p className="text-lg text-white/70 max-w-xl mx-auto leading-relaxed">
                  Bavulunu taşıma derdini geride bırak. Kyradi ile yolculuk daha hafif, daha konforlu, daha özgür.
                </p>
                <div className="flex flex-wrap items-center justify-center gap-4">
                  <Link
                    href={hasSession ? '/dashboard' : '/register'}
                    className="flex items-center gap-2 rounded-full bg-white px-8 py-4 text-[15px] font-bold text-indigo-700 shadow-[0_8px_24px_rgba(0,0,0,0.2)] hover:shadow-[0_12px_32px_rgba(0,0,0,0.25)] hover:-translate-y-0.5 transition-all"
                  >
                    Şimdi Başla
                    <ArrowRight className="h-4 w-4" />
                  </Link>
                  <a href="#works" className="flex items-center gap-2 rounded-full border border-white/30 bg-white/10 px-8 py-4 text-[15px] font-semibold text-white hover:bg-white/20 transition-all">
                    Nasıl Çalışır?
                  </a>
                </div>
                <p className="text-sm text-white/50">Güvenli • Hızlı • Kolay kullanım</p>
              </div>
            </div>
          </Reveal>
        </div>
      </section>

      {/* ═══════════════════ FOOTER ═══════════════════ */}
      <footer className="border-t border-slate-100 py-10">
        <div className="max-w-[1200px] mx-auto px-6">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-6">
            {/* Brand */}
            <div className="flex items-center gap-3">
              <div className="h-8 w-8 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-500 shadow-md" />
              <div>
                <p className="text-sm font-black tracking-[0.2em] text-slate-900">KYRADI</p>
                <p className="text-[10px] text-slate-400">SuperApp</p>
              </div>
            </div>

            {/* Trust badges */}
            <div className="flex flex-wrap items-center justify-center gap-5">
              {[
                { icon: ShieldCheck, label: 'Güvenli teslim', color: 'text-emerald-500' },
                { icon: CreditCard, label: 'Kolay ödeme', color: 'text-indigo-500' },
                { icon: Clock3, label: '7/24 Erişim', color: 'text-amber-500' },
                { icon: Lock, label: 'Şifreli güvenlik', color: 'text-cyan-500' },
              ].map(({ icon: Icon, label, color }) => (
                <div key={label} className="flex items-center gap-1.5 text-sm text-slate-500">
                  <Icon className={`h-4 w-4 ${color}`} />
                  {label}
                </div>
              ))}
            </div>

            <p className="text-xs text-slate-400">© 2025 Kyradi</p>
          </div>
        </div>
      </footer>

    </main>
  );
}
