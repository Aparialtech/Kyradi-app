'use client';

import Link from 'next/link';
import { useEffect, useRef, useState, useCallback } from 'react';
import { motion, AnimatePresence, useInView } from 'framer-motion';
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
  Menu,
  X,
} from 'lucide-react';
import { getToken } from '@/lib/auth';

/* ─────────────── DATA ─────────────── */

const heroSlides = [
  { city: 'İstanbul', title: 'Taksim KYRADI Noktası', sub: 'Rezervasyon onaylandı • Teslime hazır', badge: '3 dk uzaklıkta', from: '#6366f1', to: '#8b5cf6' },
  { city: 'Paris', title: 'Louvre KYRADI Noktası', sub: 'Hızlı giriş açık • QR hazır', badge: '5 dk uzaklıkta', from: '#ec4899', to: '#f43f5e' },
  { city: 'Londra', title: 'Soho KYRADI Noktası', sub: 'Güvenli teslim • Müsait', badge: '4 dk uzaklıkta', from: '#06b6d4', to: '#0ea5e9' },
];

const steps = [
  { icon: Search, label: '01', title: 'Konumunu seç', text: 'GPS\'inle en yakın güvenli KYRADI noktalarını anında haritada görüntüle.', grad: 'from-violet-500 to-indigo-600', glow: 'rgba(99,102,241,0.35)' },
  { icon: Navigation, label: '02', title: 'Noktanı rezerve et', text: 'Müsait ve güvenli teslim noktasını seç, 30 saniyede rezervasyonunu oluştur.', grad: 'from-fuchsia-500 to-pink-600', glow: 'rgba(236,72,153,0.35)' },
  { icon: CheckCircle2, label: '03', title: 'Bavulunu bırak ve gez', text: 'QR kodunla bırak, günün geri kalanını yük olmadan özgürce keşfet.', grad: 'from-emerald-500 to-teal-600', glow: 'rgba(16,185,129,0.35)' },
];

const features = [
  { icon: ShieldCheck, title: 'Güvenli teslim', text: 'Sertifikalı noktalarda tam güvence ile bavulunun korunması garantili.', from: '#10b981', to: '#059669' },
  { icon: Zap, title: 'Hızlı rezervasyon', text: '30 saniyede rezervasyon oluştur, anında QR kodu al ve git.', from: '#f59e0b', to: '#d97706' },
  { icon: MapPin, title: 'Yakındaki noktalar', text: 'Şehrin her köşesinde yüzlerce onaylı teslim noktası seni bekliyor.', from: '#ef4444', to: '#dc2626' },
  { icon: CreditCard, title: 'Kolay ödeme', text: 'Kart, dijital cüzdan ve daha fazla ödeme seçeneği destekleniyor.', from: '#3b82f6', to: '#2563eb' },
  { icon: Sparkles, title: 'Basit deneyim', text: 'Sezgisel arayüz ile her yaştan kullanıcı için tasarlanmış akış.', from: '#8b5cf6', to: '#7c3aed' },
  { icon: Smartphone, title: 'Anlık erişim', text: 'QR kod ile saniyeler içinde teslim al veya geri al, 7/24 açık.', from: '#06b6d4', to: '#0891b2' },
];

const story = [
  { emoji: '🏨', num: '01', title: 'Otele erken geldin', text: 'Check-in saatin henüz başlamadı. Valiz omuzlarında, şehir keşfedilmeyi bekliyor ama sen hareket edemiyorsun.', color: '#f97316' },
  { emoji: '😓', num: '02', title: 'Bavulunla gezmek istemiyorsun', text: 'Müzeler, kafeler ve dar sokaklar seni çağırıyor. Ağır valiz her adımı zorlaştırıyor. Bu böyle olmak zorunda değil.', color: '#e11d48' },
  { emoji: '📍', num: '03', title: 'Yakın noktayı buluyorsun', text: 'Telefonunu aç, birkaç dokunuşla en yakın güvenli KYRADI noktasına rezervasyon oluştur. 3 dakikadan az sürer.', color: '#6366f1' },
  { emoji: '🌟', num: '04', title: 'Eller boş, gün senin', text: 'Bavulunu güvenle bıraktın. Şehri gerçekten yaşamaya hazırsın. Hafif adımlar, dolu anlar, özgür bir gün.', color: '#10b981' },
];

const testimonials = [
  { name: 'Elif Y.', role: 'Backpacker', text: 'İstanbul turumda valiz taşımadan tüm günümü özgürce geçirdim. Kesinlikle hayat kurtarıcı bir uygulama!', avatar: 'E', grad: 'from-rose-400 to-orange-400' },
  { name: 'Can A.', role: 'İş Seyahati', text: 'Arayüz çok temiz ve hızlı. Rezervasyon akışı mükemmel çalışıyor. Her seyahatimde vazgeçilmezim.', avatar: 'C', grad: 'from-indigo-500 to-violet-500' },
  { name: 'Mina K.', role: 'Turist', text: 'Uçuş öncesi saatlerde şehri gezmek için gerçekten vazgeçilmez. Herkese tavsiye ederim!', avatar: 'M', grad: 'from-emerald-400 to-cyan-500' },
];

const cities = ['İstanbul', 'Paris', 'Londra', 'Roma', 'Barcelona', 'Amsterdam', 'Berlin', 'Viyana', 'Prag', 'Lizbon'];

/* ─────────────── ANIMATIONS ─────────────── */

const EASE = [0.22, 1, 0.36, 1] as [number, number, number, number];

const fadeUp = {
  hidden: { opacity: 0, y: 32 },
  show: (d = 0) => ({ opacity: 1, y: 0, transition: { duration: 0.6, delay: d, ease: EASE } }),
};

const staggerContainer = {
  hidden: {},
  show: { transition: { staggerChildren: 0.08 } },
};

const staggerItem = {
  hidden: { opacity: 0, y: 24 },
  show: { opacity: 1, y: 0, transition: { duration: 0.55, ease: EASE } },
};

/* ─────────────── ANIMATED COUNTER ─────────────── */
function Counter({ target, suffix = '' }: { target: number; suffix?: string }) {
  const ref = useRef<HTMLSpanElement>(null);
  const inView = useInView(ref, { once: true });
  const [count, setCount] = useState(0);

  useEffect(() => {
    if (!inView) return;
    let start = 0;
    const duration = 1800;
    const step = Math.ceil(target / (duration / 16));
    const timer = setInterval(() => {
      start += step;
      if (start >= target) { setCount(target); clearInterval(timer); }
      else setCount(start);
    }, 16);
    return () => clearInterval(timer);
  }, [inView, target]);

  return <span ref={ref}>{count}{suffix}</span>;
}

/* ─────────────── SECTION WRAPPER ─────────────── */
function Reveal({ children, delay = 0, className = '' }: { children: React.ReactNode; delay?: number; className?: string }) {
  return (
    <motion.div
      initial="hidden"
      whileInView="show"
      viewport={{ once: true, amount: 0.12 }}
      custom={delay}
      variants={fadeUp}
      className={className}
    >
      {children}
    </motion.div>
  );
}

/* ─────────────── PHONE MOCKUP ─────────────── */
function PhoneMockup({ slide }: { slide: typeof heroSlides[0] }) {
  return (
    <div className="relative" style={{ width: 260 }}>
      {/* Glow aura */}
      <div
        className="absolute inset-0 rounded-[44px] blur-3xl opacity-40 transition-all duration-700"
        style={{ background: `linear-gradient(135deg, ${slide.from}, ${slide.to})`, transform: 'scale(1.1)' }}
      />
      {/* Shell */}
      <div className="relative rounded-[44px] bg-[#0c0e1a] p-[11px] shadow-[0_50px_100px_rgba(0,0,0,0.4),inset_0_1px_0_rgba(255,255,255,0.08)]">
        {/* Screen */}
        <div className="relative rounded-[35px] overflow-hidden" style={{ height: 540, background: `linear-gradient(160deg, ${slide.from}22, #ffffff 40%)` }}>
          {/* Status bar */}
          <div className="flex items-center justify-between px-5 pt-4 pb-1">
            <span className="text-[10px] font-bold text-slate-500">9:41</span>
            <div className="h-5 w-24 rounded-full bg-black/8" />
            <div className="flex gap-1">{[1,2,3].map(i=><div key={i} className="h-1.5 w-1.5 rounded-full bg-slate-300" />)}</div>
          </div>

          {/* App header */}
          <div className="px-4 py-2 flex items-center justify-between">
            <div>
              <p className="text-[10px] text-slate-400 font-medium">{slide.city}</p>
              <p className="text-sm font-black text-slate-900">KYRADI</p>
            </div>
            <div className="h-8 w-8 rounded-full shadow-lg" style={{ background: `linear-gradient(135deg, ${slide.from}, ${slide.to})` }} />
          </div>

          {/* Map */}
          <div className="mx-4 rounded-2xl bg-white/80 backdrop-blur p-2.5 shadow-sm border border-white/90">
            <div className="relative h-[110px] rounded-xl overflow-hidden bg-gradient-to-br from-slate-50 to-indigo-50/50">
              <svg className="absolute inset-0 w-full h-full">
                <defs>
                  <pattern id="map-grid" width="18" height="18" patternUnits="userSpaceOnUse">
                    <path d="M18 0L0 0 0 18" fill="none" stroke="rgba(99,102,241,0.1)" strokeWidth="0.8"/>
                  </pattern>
                </defs>
                <rect width="100%" height="100%" fill="url(#map-grid)"/>
                <rect x="0" y="52" width="100%" height="8" fill="rgba(255,255,255,0.9)" rx="2"/>
                <rect x="88" y="0" width="6" height="100%" fill="rgba(255,255,255,0.8)" rx="2"/>
                <rect x="0" y="82" width="100%" height="5" fill="rgba(255,255,255,0.6)" rx="1"/>
              </svg>
              {/* Active pin */}
              <div className="absolute top-5 left-[72px] flex flex-col items-center">
                <div className="h-7 w-7 rounded-full border-[3px] border-white shadow-lg flex items-center justify-center" style={{ background: `linear-gradient(135deg, ${slide.from}, ${slide.to})` }}>
                  <div className="h-2 w-2 rounded-full bg-white" />
                </div>
                <div className="h-1.5 w-0.5 mt-0.5" style={{ background: slide.from }} />
                <div className="h-1 w-1 rounded-full" style={{ background: slide.from }} />
              </div>
              {/* User dot */}
              <div className="absolute bottom-5 right-10">
                <div className="relative">
                  <div className="absolute inset-0 rounded-full bg-blue-400/30 animate-ping scale-150" />
                  <div className="h-4 w-4 rounded-full bg-blue-500 border-2 border-white shadow-md" />
                </div>
              </div>
              {/* Distance badge */}
              <div className="absolute top-2 right-2 rounded-lg bg-white/90 backdrop-blur px-2 py-1 shadow-sm">
                <p className="text-[8px] font-bold text-slate-700">{slide.badge}</p>
              </div>
            </div>
            <div className="flex items-center justify-between mt-2 px-1">
              <p className="text-[9px] font-semibold text-slate-500">{slide.badge}</p>
              <span className="text-[8px] bg-emerald-100 text-emerald-600 rounded-full px-2 py-0.5 font-bold">Müsait ✓</span>
            </div>
          </div>

          {/* Reservation card */}
          <div className="mx-4 mt-2.5 rounded-2xl p-3 text-white shadow-lg" style={{ background: `linear-gradient(135deg, ${slide.from}, ${slide.to})` }}>
            <p className="text-[8px] font-semibold opacity-75 mb-0.5">AKTİF REZERVASYON</p>
            <p className="text-[11px] font-black leading-tight">{slide.title}</p>
            <p className="text-[8px] opacity-80 mt-0.5">{slide.sub}</p>
            <div className="mt-2 flex gap-1.5">
              <div className="flex-1 rounded-xl bg-white/20 py-1.5 text-center text-[8px] font-bold">QR Göster</div>
              <div className="flex-1 rounded-xl bg-white/20 py-1.5 text-center text-[8px] font-bold">Yönlendir</div>
            </div>
          </div>

          {/* Bottom pills */}
          <div className="mx-4 mt-2.5 grid grid-cols-2 gap-2">
            {[['💼','1 Valiz'],['⏱️','2 Gün']].map(([emoji, label]) => (
              <div key={label} className="rounded-xl bg-white/80 border border-white/90 p-2 flex items-center gap-2">
                <span className="text-sm">{emoji}</span>
                <p className="text-[9px] font-bold text-slate-700">{label}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
      {/* Notch */}
      <div className="absolute top-[15px] left-1/2 -translate-x-1/2 h-6 w-28 rounded-full bg-[#0c0e1a] z-10" />
    </div>
  );
}

/* ─────────────── MARQUEE ─────────────── */
function CityMarquee() {
  const doubled = [...cities, ...cities];
  return (
    <div className="relative overflow-hidden py-4" style={{ maskImage: 'linear-gradient(90deg, transparent, black 15%, black 85%, transparent)' }}>
      <motion.div
        animate={{ x: ['0%', '-50%'] }}
        transition={{ duration: 22, repeat: Infinity, ease: 'linear' }}
        className="flex gap-3 w-max"
      >
        {doubled.map((city, i) => (
          <span key={i} className="flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-600 whitespace-nowrap shadow-sm">
            <span className="h-1.5 w-1.5 rounded-full bg-indigo-400" />
            {city}
          </span>
        ))}
      </motion.div>
    </div>
  );
}

/* ─────────────── MAIN PAGE ─────────────── */

export default function HomePage() {
  const [hasSession, setHasSession] = useState(false);
  const [activeSlide, setActiveSlide] = useState(0);
  const [menuOpen, setMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => { setHasSession(Boolean(getToken())); }, []);

  useEffect(() => {
    const iv = setInterval(() => setActiveSlide(p => (p + 1) % heroSlides.length), 4000);
    return () => clearInterval(iv);
  }, []);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const slide = heroSlides[activeSlide];

  /* 3D card tilt */
  const handleTilt = useCallback((e: React.MouseEvent<HTMLDivElement>) => {
    const el = e.currentTarget;
    const rect = el.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    el.style.transform = `perspective(600px) rotateY(${x * 10}deg) rotateX(${-y * 10}deg) scale(1.02)`;
  }, []);
  const resetTilt = useCallback((e: React.MouseEvent<HTMLDivElement>) => {
    e.currentTarget.style.transform = '';
  }, []);

  return (
    <main className="bg-white text-slate-900 overflow-x-hidden" style={{ fontFamily: "'SF Pro Display','SF Pro Text',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif" }}>

      {/* ══ GLOBAL KEYFRAMES ══ */}
      <style>{`
        @keyframes gradientShift {
          0%,100% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
        }
        @keyframes shimmer {
          0% { transform: translateX(-100%); }
          100% { transform: translateX(100%); }
        }
        @keyframes float1 { 0%,100%{transform:translateY(0px)} 50%{transform:translateY(-14px)} }
        @keyframes float2 { 0%,100%{transform:translateY(0px)} 50%{transform:translateY(-10px)} }
        @keyframes float3 { 0%,100%{transform:translateY(0px)} 50%{transform:translateY(-18px)} }
        @keyframes pulse-glow { 0%,100%{opacity:0.4;transform:scale(1)} 50%{opacity:0.7;transform:scale(1.05)} }
        .shimmer-btn::after {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0; bottom: 0;
          background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent);
          animation: shimmer 2.4s infinite;
          border-radius: inherit;
        }
        .card-tilt { transition: transform 0.18s ease, box-shadow 0.18s ease; }
        .grad-border {
          position: relative;
          background: white;
        }
        .grad-border::before {
          content: '';
          position: absolute;
          inset: 0;
          border-radius: inherit;
          padding: 1.5px;
          background: linear-gradient(135deg, #6366f1, #ec4899, #06b6d4);
          -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
          -webkit-mask-composite: xor;
          mask-composite: exclude;
          opacity: 0;
          transition: opacity 0.3s;
        }
        .grad-border:hover::before { opacity: 1; }
      `}</style>

      {/* ════════════════ HEADER ════════════════ */}
      <motion.header
        initial={{ y: -20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
        className={`sticky top-0 z-50 transition-all duration-300 ${scrolled ? 'border-b border-slate-100 bg-white/85 backdrop-blur-xl shadow-sm' : 'bg-transparent'}`}
      >
        <div className="max-w-[1200px] mx-auto px-6">
          <div className="flex items-center justify-between h-16">
            {/* Logo */}
            <div className="flex items-center gap-3">
              <img src="/app-icon.svg" alt="Kyradi" className="h-9 w-9 flex-shrink-0" style={{ borderRadius: 10 }} />
              <div>
                <p className="text-[13px] font-black tracking-[0.22em] text-slate-900">KYRADI</p>
                <p className="text-[10px] font-medium text-slate-400 -mt-0.5 tracking-wider">SuperApp</p>
              </div>
            </div>

            {/* Desktop Nav */}
            <nav className="hidden md:flex items-center gap-1">
              {[['#works','Nasıl Çalışır'],['#features','Özellikler'],['#story','Deneyim'],['#reviews','Yorumlar']].map(([href,label])=>(
                <a key={href} href={href} className="px-4 py-2 rounded-full text-[13px] font-medium text-slate-500 hover:text-slate-900 hover:bg-slate-50 transition-all">{label}</a>
              ))}
            </nav>

            {/* CTAs */}
            <div className="flex items-center gap-3">
              <Link href="/login" className="hidden sm:block text-[13px] font-semibold text-slate-600 hover:text-slate-900 transition-colors px-4 py-2 rounded-full hover:bg-slate-50">
                Giriş Yap
              </Link>
              <Link
                href={hasSession ? '/dashboard' : '/register'}
                className="relative overflow-hidden shimmer-btn flex items-center gap-2 rounded-full px-5 py-2.5 text-[13px] font-bold text-white shadow-[0_8px_24px_rgba(99,102,241,0.4)] hover:shadow-[0_12px_32px_rgba(99,102,241,0.5)] hover:-translate-y-0.5 transition-all"
                style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}
              >
                Keşfet <ArrowRight className="h-3.5 w-3.5" />
              </Link>
              <button onClick={()=>setMenuOpen(p=>!p)} className="md:hidden p-2 rounded-xl hover:bg-slate-100 transition-colors">
                {menuOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
              </button>
            </div>
          </div>
        </div>

        {/* Mobile menu */}
        <AnimatePresence>
          {menuOpen && (
            <motion.div initial={{opacity:0,y:-10}} animate={{opacity:1,y:0}} exit={{opacity:0,y:-10}} transition={{duration:0.2}}
              className="md:hidden absolute top-full left-0 right-0 bg-white border-b border-slate-100 shadow-xl px-6 py-4 flex flex-col gap-2">
              {[['#works','Nasıl Çalışır'],['#features','Özellikler'],['#story','Deneyim'],['#reviews','Yorumlar']].map(([href,label])=>(
                <a key={href} href={href} onClick={()=>setMenuOpen(false)} className="py-3 text-[15px] font-semibold text-slate-700 border-b border-slate-50 last:border-0">{label}</a>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </motion.header>

      {/* ════════════════ HERO ════════════════ */}
      <section className="relative overflow-hidden pt-16 pb-28">
        {/* Animated gradient orbs */}
        <div className="pointer-events-none absolute inset-0 overflow-hidden">
          <div className="absolute -top-40 -right-40 h-[700px] w-[700px] rounded-full opacity-[0.07]" style={{ background: 'radial-gradient(circle, #6366f1 0%, transparent 70%)', animation: 'pulse-glow 6s ease-in-out infinite' }} />
          <div className="absolute top-40 -left-40 h-[500px] w-[500px] rounded-full opacity-[0.06]" style={{ background: 'radial-gradient(circle, #ec4899 0%, transparent 70%)', animation: 'pulse-glow 8s ease-in-out infinite 1s' }} />
          <div className="absolute -bottom-20 left-1/2 h-[400px] w-[400px] -translate-x-1/2 rounded-full opacity-[0.05]" style={{ background: 'radial-gradient(circle, #06b6d4 0%, transparent 70%)', animation: 'pulse-glow 7s ease-in-out infinite 2s' }} />
        </div>

        <div className="max-w-[1200px] mx-auto px-6 relative z-10">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-14 items-center">

            {/* ── LEFT: Text ── */}
            <motion.div variants={staggerContainer} initial="hidden" animate="show" className="space-y-7">

              {/* Badge */}
              <motion.div variants={staggerItem}>
                <span className="inline-flex items-center gap-2.5 rounded-full border border-violet-200 px-4 py-2 text-[12px] font-bold text-violet-700 tracking-wide"
                  style={{ background: 'linear-gradient(135deg, #f5f3ff, #fdf4ff)' }}>
                  <span className="flex h-2 w-2 rounded-full animate-pulse" style={{ background: 'linear-gradient(135deg, #8b5cf6, #ec4899)' }} />
                  Seyahatin en hafif hali
                  <span className="rounded-full bg-violet-200/60 px-2 py-0.5 text-[10px] font-black text-violet-800">YENİ</span>
                </span>
              </motion.div>

              {/* Headline */}
              <motion.div variants={staggerItem}>
                <h1 className="text-[3.8rem] leading-[1.06] font-black tracking-[-0.04em] text-slate-900">
                  Bavulunu bırak.{' '}
                  <span className="relative inline-block">
                    <span className="relative z-10 bg-clip-text text-transparent" style={{ backgroundImage: 'linear-gradient(135deg, #6366f1, #8b5cf6, #ec4899)', backgroundSize: '200% 200%', animation: 'gradientShift 4s ease infinite' }}>
                      Şehri özgürce
                    </span>
                    <svg className="absolute -bottom-2 left-0 w-full" viewBox="0 0 300 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M2 8 Q75 2 150 8 Q225 14 298 8" stroke="url(#underline-grad)" strokeWidth="3" strokeLinecap="round"/>
                      <defs><linearGradient id="underline-grad" x1="0" y1="0" x2="300" y2="0"><stop stopColor="#6366f1"/><stop offset="0.5" stopColor="#ec4899"/><stop offset="1" stopColor="#06b6d4"/></linearGradient></defs>
                    </svg>
                  </span>
                  {' '}keşfet.
                </h1>
              </motion.div>

              {/* Sub */}
              <motion.div variants={staggerItem}>
                <p className="text-[17px] leading-[1.7] text-slate-500 max-w-[480px]">
                  Ağır yüklerden kurtul, yakındaki güvenli noktayı bul, bavulunu bırak ve anın tadını çıkar. Kyradi ile şehir senin.
                </p>
              </motion.div>

              {/* Buttons */}
              <motion.div variants={staggerItem} className="flex flex-wrap gap-3">
                <Link
                  href={hasSession ? '/dashboard' : '/register'}
                  className="relative overflow-hidden shimmer-btn flex items-center gap-2 rounded-full px-8 py-4 text-[15px] font-black text-white shadow-[0_16px_40px_rgba(99,102,241,0.45)] hover:shadow-[0_20px_48px_rgba(99,102,241,0.55)] hover:-translate-y-1 transition-all"
                  style={{ background: 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #ec4899 100%)', backgroundSize: '200% 200%', animation: 'gradientShift 3s ease infinite' }}
                >
                  Uygulamayı Keşfet <ArrowRight className="h-4 w-4" />
                </Link>
                <a href="#works" className="flex items-center gap-2 rounded-full border-2 border-slate-200 bg-white px-8 py-4 text-[15px] font-bold text-slate-700 hover:border-indigo-300 hover:text-indigo-700 hover:-translate-y-0.5 transition-all shadow-sm">
                  Nasıl Çalışır?
                </a>
              </motion.div>

              {/* Social proof */}
              <motion.div variants={staggerItem} className="flex items-center gap-4">
                <div className="flex -space-x-2.5">
                  {['#f43f5e','#f59e0b','#6366f1','#10b981','#ec4899'].map((c,i)=>(
                    <div key={i} className="h-9 w-9 rounded-full border-2 border-white shadow-sm" style={{ background: `linear-gradient(135deg, ${c}, ${c}bb)` }} />
                  ))}
                </div>
                <div>
                  <div className="flex items-center gap-1 mb-0.5">
                    {[...Array(5)].map((_,i)=><Star key={i} className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />)}
                    <span className="ml-1 text-[12px] font-bold text-slate-700">4.9</span>
                  </div>
                  <p className="text-[12px] text-slate-500 font-medium">1000+ gezgin tarafından güvenildi</p>
                </div>
              </motion.div>

              {/* Trust pills */}
              <motion.div variants={staggerItem} className="flex flex-wrap gap-2.5">
                {[
                  { icon: ShieldCheck, label: 'Güvenli noktalar', color: '#10b981' },
                  { icon: Zap, label: 'Hızlı rezervasyon', color: '#f59e0b' },
                  { icon: Lock, label: '7/24 Erişim', color: '#6366f1' },
                ].map(({ icon: Icon, label, color }) => (
                  <div key={label} className="flex items-center gap-2 rounded-full border border-slate-200 bg-white/80 px-4 py-2 text-[12px] font-semibold text-slate-600 shadow-sm backdrop-blur">
                    <Icon className="h-3.5 w-3.5" style={{ color }} />
                    {label}
                  </div>
                ))}
              </motion.div>
            </motion.div>

            {/* ── RIGHT: Phone ── */}
            <Reveal delay={0.15}>
              <div className="relative flex justify-center lg:justify-end pr-0 lg:pr-8">

                {/* Floating card 1 */}
                <motion.div
                  initial={{ opacity: 0, x: -30 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.8, duration: 0.6 }}
                  className="absolute -left-6 top-12 z-20 hidden lg:flex items-center gap-3 rounded-2xl bg-white px-4 py-3 shadow-[0_12px_32px_rgba(16,185,129,0.18)] border border-emerald-100/50"
                  style={{ animation: 'float2 4s ease-in-out infinite' }}
                >
                  <div className="h-9 w-9 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: 'linear-gradient(135deg, #10b981, #059669)' }}>
                    <CheckCircle2 className="h-4 w-4 text-white" />
                  </div>
                  <div>
                    <p className="text-[11px] font-black text-slate-800">Rezervasyon onaylandı</p>
                    <p className="text-[10px] text-slate-400 font-medium">Az önce • İstanbul</p>
                  </div>
                </motion.div>

                {/* Floating card 2 */}
                <motion.div
                  initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 1.0, duration: 0.6 }}
                  className="absolute -right-6 top-24 z-20 hidden lg:flex items-center gap-3 rounded-2xl bg-white px-4 py-3 shadow-[0_12px_32px_rgba(99,102,241,0.18)] border border-indigo-100/50"
                  style={{ animation: 'float1 5s ease-in-out infinite 0.5s' }}
                >
                  <div className="h-9 w-9 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}>
                    <MapPin className="h-4 w-4 text-white" />
                  </div>
                  <div>
                    <p className="text-[11px] font-black text-slate-800">{slide.badge}</p>
                    <p className="text-[10px] text-slate-400 font-medium">{slide.city}</p>
                  </div>
                </motion.div>

                {/* Floating card 3 */}
                <motion.div
                  initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 1.2, duration: 0.6 }}
                  className="absolute -left-4 bottom-16 z-20 hidden lg:flex items-center gap-2.5 rounded-2xl bg-white px-4 py-3 shadow-[0_12px_32px_rgba(6,182,212,0.18)] border border-cyan-100/50"
                  style={{ animation: 'float3 3.5s ease-in-out infinite 1s' }}
                >
                  <div className="h-8 w-8 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: 'linear-gradient(135deg, #06b6d4, #0891b2)' }}>
                    <Lock className="h-3.5 w-3.5 text-white" />
                  </div>
                  <p className="text-[11px] font-black text-slate-800">Güvenli teslim</p>
                </motion.div>

                {/* Phone */}
                <div style={{ animation: 'float1 6s ease-in-out infinite' }}>
                  <AnimatePresence mode="wait">
                    <motion.div
                      key={activeSlide}
                      initial={{ opacity: 0, scale: 0.95, y: 10 }}
                      animate={{ opacity: 1, scale: 1, y: 0 }}
                      exit={{ opacity: 0, scale: 0.95, y: -10 }}
                      transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
                    >
                      <PhoneMockup slide={slide} />
                    </motion.div>
                  </AnimatePresence>
                </div>

                {/* Slide dots */}
                <div className="absolute -bottom-8 left-1/2 -translate-x-1/2 flex gap-2">
                  {heroSlides.map((_, i) => (
                    <button key={i} onClick={() => setActiveSlide(i)}
                      className="rounded-full transition-all duration-300"
                      style={{ width: i === activeSlide ? 28 : 8, height: 8, background: i === activeSlide ? `linear-gradient(135deg, ${slide.from}, ${slide.to})` : '#cbd5e1' }}
                    />
                  ))}
                </div>
              </div>
            </Reveal>
          </div>
        </div>
      </section>

      {/* ════════════════ CITY MARQUEE ════════════════ */}
      <section className="py-6 border-y border-slate-100 bg-slate-50/50">
        <div className="max-w-[1200px] mx-auto px-6 mb-3">
          <p className="text-center text-[11px] font-bold tracking-widest text-slate-400 uppercase">Desteklenen Şehirler</p>
        </div>
        <CityMarquee />
      </section>

      {/* ════════════════ STATS ════════════════ */}
      <section className="py-20">
        <div className="max-w-[1200px] mx-auto px-6">
          <motion.div variants={staggerContainer} initial="hidden" whileInView="show" viewport={{ once: true, amount: 0.3 }}
            className="grid grid-cols-1 md:grid-cols-3 gap-5">
            {[
              { icon: Users, num: 1000, suffix: '+', label: 'Mutlu Gezgin', sub: 'Aktif kullanıcı', from: '#6366f1', to: '#8b5cf6' },
              { icon: MapPin, num: 3, suffix: ' dk', label: 'Ortalama Mesafe', sub: 'En yakın noktaya', from: '#ec4899', to: '#f43f5e' },
              { icon: Clock3, num: 24, suffix: '/7', label: 'Kesintisiz Erişim', sub: 'Her zaman, her yerde', from: '#10b981', to: '#059669' },
            ].map((stat, i) => (
              <motion.div key={stat.label} variants={staggerItem} onMouseMove={handleTilt} onMouseLeave={resetTilt}
                className="card-tilt grad-border relative rounded-[24px] p-7 shadow-[0_4px_24px_rgba(15,23,42,0.06)] overflow-hidden cursor-default"
                style={{ borderRadius: 24 }}
              >
                {/* BG orb */}
                <div className="absolute -top-6 -right-6 h-28 w-28 rounded-full opacity-10" style={{ background: `linear-gradient(135deg, ${stat.from}, ${stat.to})` }} />
                <div className="relative z-10">
                  <div className="mb-4 h-12 w-12 rounded-2xl flex items-center justify-center shadow-lg" style={{ background: `linear-gradient(135deg, ${stat.from}, ${stat.to})` }}>
                    <stat.icon className="h-5 w-5 text-white" />
                  </div>
                  <p className="text-[2.8rem] font-black tracking-[-0.04em] text-slate-900 leading-none">
                    <Counter target={stat.num} suffix={stat.suffix} />
                  </p>
                  <p className="mt-1.5 text-base font-bold text-slate-800">{stat.label}</p>
                  <p className="text-sm text-slate-400 font-medium">{stat.sub}</p>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* ════════════════ HOW IT WORKS ════════════════ */}
      <section id="works" className="py-28 relative overflow-hidden" style={{ background: 'linear-gradient(160deg, #fafafe 0%, #f8f4ff 50%, #fafafe 100%)' }}>
        <div className="pointer-events-none absolute top-0 left-1/2 -translate-x-1/2 h-px w-3/4 bg-gradient-to-r from-transparent via-indigo-200 to-transparent" />

        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <span className="inline-flex items-center gap-2 rounded-full px-4 py-1.5 text-[11px] font-black tracking-widest uppercase mb-5"
              style={{ background: 'linear-gradient(135deg, #ede9fe, #fce7f3)', color: '#7c3aed', border: '1px solid #c4b5fd' }}>
              ✦ Nasıl Çalışır?
            </span>
            <h2 className="text-[2.8rem] font-black tracking-[-0.04em] text-slate-900 leading-tight">
              3 adımda yük olmadan gez
            </h2>
            <p className="mt-4 text-[17px] text-slate-500 max-w-md mx-auto leading-relaxed">
              Kyradi ile bavul derdi 3 dakikadan kısa sürede çözülür.
            </p>
          </Reveal>

          <motion.div variants={staggerContainer} initial="hidden" whileInView="show" viewport={{ once: true, amount: 0.2 }}
            className="grid grid-cols-1 md:grid-cols-3 gap-6 relative">
            {/* Connecting line */}
            <div className="absolute top-[52px] left-[calc(16.7%+12px)] right-[calc(16.7%+12px)] hidden md:block h-px"
              style={{ background: 'linear-gradient(90deg, #6366f1, #ec4899, #10b981)' }} />

            {steps.map((step, i) => (
              <motion.div key={step.title} variants={staggerItem} onMouseMove={handleTilt} onMouseLeave={resetTilt}
                className="card-tilt relative rounded-[28px] bg-white p-7 shadow-[0_8px_32px_rgba(15,23,42,0.07)] border border-white/80 overflow-hidden cursor-default group"
              >
                {/* Top color bar */}
                <div className="absolute top-0 left-0 right-0 h-1 rounded-t-[28px]" style={{ background: `linear-gradient(90deg, ${step.grad.replace('from-','').replace(' to-',',')})` }}
                  // simpler: just use inline style with hardcoded gradient
                />
                <div className="absolute top-0 left-0 right-0 h-1 rounded-t-[28px] opacity-0 group-hover:opacity-100 transition-opacity" style={{ background: `linear-gradient(90deg, ${i === 0 ? '#6366f1,#8b5cf6' : i === 1 ? '#ec4899,#f43f5e' : '#10b981,#059669'})` }} />

                {/* Step icon */}
                <div className="relative mb-6">
                  <div className="h-14 w-14 rounded-2xl flex items-center justify-center shadow-lg" style={{ background: `linear-gradient(135deg, ${i===0?'#6366f1,#8b5cf6':i===1?'#ec4899,#f43f5e':'#10b981,#059669'})` }}>
                    <step.icon className="h-6 w-6 text-white" />
                  </div>
                  <div className="absolute -top-2 -right-2 h-6 w-6 rounded-full flex items-center justify-center text-[9px] font-black text-white shadow-md" style={{ background: '#0f172a' }}>
                    {i + 1}
                  </div>
                </div>

                <p className="text-[10px] font-black tracking-widest uppercase mb-2" style={{ color: i===0?'#6366f1':i===1?'#ec4899':'#10b981' }}>
                  Adım {step.label}
                </p>
                <h3 className="text-xl font-black text-slate-900 mb-3">{step.title}</h3>
                <p className="text-sm leading-relaxed text-slate-500">{step.text}</p>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* ════════════════ STORY ════════════════ */}
      <section id="story" className="py-28">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <span className="inline-flex items-center gap-2 rounded-full px-4 py-1.5 text-[11px] font-black tracking-widest uppercase mb-5"
              style={{ background: 'linear-gradient(135deg, #fff7ed, #fce7f3)', color: '#ea580c', border: '1px solid #fed7aa' }}>
              ✦ Deneyim Hikayesi
            </span>
            <h2 className="text-[2.8rem] font-black tracking-[-0.04em] text-slate-900">Şehri taşımadan yaşa</h2>
            <p className="mt-4 text-[17px] text-slate-500 max-w-md mx-auto">Her seyahatçinin hissettiği o duygu — ve çözümü.</p>
          </Reveal>

          <div className="space-y-5">
            {story.map((item, i) => (
              <Reveal key={item.title} delay={i * 0.05}>
                <div className="group grid grid-cols-1 md:grid-cols-2 rounded-[28px] overflow-hidden border border-slate-100 shadow-[0_8px_32px_rgba(15,23,42,0.06)] hover:shadow-[0_16px_48px_rgba(15,23,42,0.1)] transition-shadow">
                  {/* Text */}
                  <div className={`flex items-center bg-white p-8 md:p-10 ${i % 2 === 1 ? 'md:order-2' : ''}`}>
                    <div>
                      <div className="flex items-center gap-3 mb-5">
                        <div className="flex h-10 w-10 items-center justify-center rounded-2xl text-xl font-black text-white shadow-md" style={{ background: `linear-gradient(135deg, ${item.color}, ${item.color}bb)` }}>
                          {item.num}
                        </div>
                        <span className="text-3xl">{item.emoji}</span>
                      </div>
                      <h3 className="text-2xl font-black text-slate-900 mb-3">{item.title}</h3>
                      <p className="text-[15px] leading-[1.75] text-slate-500">{item.text}</p>
                    </div>
                  </div>
                  {/* Visual */}
                  <div className={`relative min-h-[200px] ${i % 2 === 1 ? 'md:order-1' : ''}`}
                    style={{ background: `linear-gradient(135deg, ${item.color}15, ${item.color}08)` }}>
                    <div className="absolute inset-0 flex items-center justify-center">
                      <span className="text-[9rem] opacity-[0.12] select-none" style={{ filter: 'grayscale(20%)' }}>{item.emoji}</span>
                    </div>
                    {/* Pill badge */}
                    <div className="absolute bottom-5 right-5">
                      <div className="flex items-center gap-2 rounded-2xl bg-white/90 backdrop-blur-sm shadow-md border border-white px-4 py-2.5">
                        <div className="h-2 w-2 rounded-full animate-pulse" style={{ background: item.color }} />
                        <span className="text-[11px] font-black text-slate-800">{item.title}</span>
                      </div>
                    </div>
                    {/* Corner accent */}
                    <div className="absolute top-4 left-4 h-12 w-12 rounded-2xl opacity-20" style={{ background: `linear-gradient(135deg, ${item.color}, transparent)` }} />
                  </div>
                </div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* ════════════════ FEATURES ════════════════ */}
      <section id="features" className="py-28 relative overflow-hidden" style={{ background: 'linear-gradient(160deg, #f8faff 0%, #fdf4ff 100%)' }}>
        <div className="pointer-events-none absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-indigo-200 to-transparent" />

        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <span className="inline-flex items-center gap-2 rounded-full px-4 py-1.5 text-[11px] font-black tracking-widest uppercase mb-5"
              style={{ background: 'linear-gradient(135deg, #eff6ff, #f0fdf4)', color: '#2563eb', border: '1px solid #bfdbfe' }}>
              ✦ Özellikler
            </span>
            <h2 className="text-[2.8rem] font-black tracking-[-0.04em] text-slate-900">Seyahatini kolaylaştıran detaylar</h2>
            <p className="mt-4 text-[17px] text-slate-500 max-w-md mx-auto">Her detay, seyahatini daha hafif ve özgür kılmak için tasarlandı.</p>
          </Reveal>

          <motion.div variants={staggerContainer} initial="hidden" whileInView="show" viewport={{ once: true, amount: 0.15 }}
            className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {features.map((feat, i) => (
              <motion.div key={feat.title} variants={staggerItem} onMouseMove={handleTilt} onMouseLeave={resetTilt}
                className="card-tilt grad-border group relative rounded-[24px] bg-white p-7 shadow-[0_4px_20px_rgba(15,23,42,0.06)] overflow-hidden cursor-default"
                style={{ borderRadius: 24 }}
              >
                {/* BG glow */}
                <div className="absolute -top-8 -right-8 h-32 w-32 rounded-full opacity-0 group-hover:opacity-[0.08] transition-opacity duration-300" style={{ background: `radial-gradient(circle, ${feat.from}, transparent)` }} />

                <div className="relative z-10">
                  <div className="mb-5 h-13 w-13 rounded-2xl flex items-center justify-center shadow-lg" style={{ background: `linear-gradient(135deg, ${feat.from}, ${feat.to})`, width: 52, height: 52 }}>
                    <feat.icon className="h-5 w-5 text-white" />
                  </div>
                  <h3 className="text-[17px] font-black text-slate-900 mb-2">{feat.title}</h3>
                  <p className="text-[13px] leading-[1.7] text-slate-500">{feat.text}</p>
                </div>

                {/* Bottom gradient line */}
                <div className="absolute bottom-0 left-0 right-0 h-0.5 opacity-0 group-hover:opacity-100 transition-opacity" style={{ background: `linear-gradient(90deg, ${feat.from}, ${feat.to})` }} />
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* ════════════════ MOBILE PREVIEW ════════════════ */}
      <section id="mobile" className="py-28 overflow-hidden relative" style={{ background: 'linear-gradient(160deg, #0f0c29 0%, #1a1040 40%, #0c1e3c 100%)' }}>
        {/* Stars */}
        <div className="pointer-events-none absolute inset-0 overflow-hidden">
          {[...Array(40)].map((_, i) => (
            <div key={i} className="absolute rounded-full bg-white" style={{ left: `${Math.random()*100}%`, top: `${Math.random()*100}%`, width: Math.random()*2+1, height: Math.random()*2+1, opacity: Math.random()*0.5+0.1 }} />
          ))}
          <div className="absolute inset-0" style={{ background: 'radial-gradient(80rem 40rem at 50% 100%, rgba(99,102,241,0.15), transparent)' }} />
        </div>

        <div className="max-w-[1200px] mx-auto px-6 relative z-10">
          <Reveal className="text-center mb-16">
            <span className="inline-flex items-center gap-2 rounded-full px-4 py-1.5 text-[11px] font-black tracking-widest uppercase mb-5"
              style={{ background: 'rgba(255,255,255,0.08)', color: 'rgba(255,255,255,0.7)', border: '1px solid rgba(255,255,255,0.12)' }}>
              ✦ Mobil Uygulama
            </span>
            <h2 className="text-[2.8rem] font-black tracking-[-0.04em] text-white leading-tight">Premium uygulama deneyimi</h2>
            <p className="mt-4 text-[17px] max-w-md mx-auto leading-relaxed" style={{ color: 'rgba(255,255,255,0.55)' }}>
              Temiz arayüz, hızlı akış, sezgisel tasarım.
            </p>
          </Reveal>

          <div className="relative flex items-end justify-center gap-6 pt-4 pb-12">
            {/* Glow under phones */}
            <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-[600px] h-40 blur-3xl opacity-20" style={{ background: 'linear-gradient(90deg, #6366f1, #ec4899, #06b6d4)' }} />

            {/* Phone left */}
            <div className="hidden md:block" style={{ animation: 'float2 5s ease-in-out infinite 0.4s' }}>
              <div className="rounded-[36px] shadow-[0_30px_60px_rgba(0,0,0,0.5)]" style={{ transform: 'rotate(-7deg)', background: '#0c0e1a', padding: 9, width: 200 }}>
                <div className="rounded-[29px] overflow-hidden" style={{ height: 390, background: 'linear-gradient(160deg, #1e1b4b, #312e81)' }}>
                  <div className="p-4 space-y-3">
                    <div className="h-3 w-20 rounded-full bg-white/10" />
                    <div className="h-4 w-28 rounded-full bg-white/20" />
                    <div className="h-24 rounded-2xl overflow-hidden" style={{ background: 'linear-gradient(135deg, #4338ca22, #6366f122)' }}>
                      <svg width="100%" height="100%"><defs><pattern id="g4" width="16" height="16" patternUnits="userSpaceOnUse"><path d="M16 0L0 0 0 16" fill="none" stroke="rgba(99,102,241,0.2)" strokeWidth="1"/></pattern></defs><rect width="100%" height="100%" fill="url(#g4)"/><rect x="0" y="46" width="100%" height="6" fill="rgba(255,255,255,0.08)" rx="2"/></svg>
                    </div>
                    {[1,2].map(j=><div key={j} className="rounded-xl p-3 flex gap-2 items-center" style={{ background: 'rgba(255,255,255,0.05)' }}><div className="h-6 w-6 rounded-lg" style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}/><div className="flex-1"><div className="h-2 rounded-full bg-white/20 mb-1"/><div className="h-1.5 w-2/3 rounded-full bg-white/10"/></div></div>)}
                  </div>
                </div>
              </div>
            </div>

            {/* Center phone */}
            <div style={{ animation: 'float1 6s ease-in-out infinite' }}>
              <div className="rounded-[44px] shadow-[0_60px_120px_rgba(0,0,0,0.6),0_0_80px_rgba(99,102,241,0.2)]" style={{ background: '#0c0e1a', padding: 11, width: 255 }}>
                <div className="rounded-[35px] overflow-hidden" style={{ height: 490, background: 'linear-gradient(160deg, #6366f122, white 35%)' }}>
                  <div className="flex items-center justify-between px-5 pt-3"><span className="text-[9px] font-bold text-slate-400">9:41</span><div className="h-5 w-16 rounded-full bg-black/8"/><div className="flex gap-1">{[1,2,3].map(i=><div key={i} className="h-1.5 w-1.5 rounded-full bg-slate-300"/>)}</div></div>
                  <div className="px-4 pt-2">
                    <div className="flex items-center justify-between mb-3">
                      <div><p className="text-[9px] text-slate-400">İstanbul</p><p className="text-sm font-black text-slate-900">KYRADI</p></div>
                      <div className="h-9 w-9 rounded-full shadow-lg" style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}/>
                    </div>
                    <div className="rounded-2xl text-white p-3 shadow-lg mb-3" style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}>
                      <p className="text-[8px] opacity-70 mb-0.5">AKTİF REZERVASYON</p>
                      <p className="text-[11px] font-black">Taksim KYRADI Noktası</p>
                      <p className="text-[8px] opacity-80 mt-0.5">Teslime 2s 14dk</p>
                      <div className="mt-2 flex gap-1.5"><div className="flex-1 rounded-xl bg-white/20 py-1.5 text-center text-[8px] font-bold">QR Göster</div><div className="flex-1 rounded-xl bg-white/20 py-1.5 text-center text-[8px] font-bold">Yönlendir</div></div>
                    </div>
                    <div className="rounded-2xl bg-white/80 border border-white/90 p-2.5 mb-3">
                      <div className="h-28 rounded-xl overflow-hidden relative" style={{ background: 'linear-gradient(135deg, #f0f4ff, #e8f0ff)' }}>
                        <svg className="absolute inset-0 w-full h-full"><defs><pattern id="g5" width="15" height="15" patternUnits="userSpaceOnUse"><path d="M15 0L0 0 0 15" fill="none" stroke="rgba(99,102,241,0.12)" strokeWidth="0.8"/></pattern></defs><rect width="100%" height="100%" fill="url(#g5)"/><rect x="0" y="50" width="100%" height="7" fill="rgba(255,255,255,1)" rx="2"/><rect x="95" y="0" width="5" height="100%" fill="rgba(255,255,255,0.9)" rx="1"/></svg>
                        <div className="absolute top-4 left-16 h-6 w-6 rounded-full border-2 border-white shadow-lg flex items-center justify-center" style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)' }}><div className="h-2 w-2 rounded-full bg-white"/></div>
                        <div className="absolute bottom-4 right-8 relative"><div className="absolute inset-0 scale-150 rounded-full bg-blue-400/30 animate-ping"/><div className="h-4 w-4 rounded-full bg-blue-500 border-2 border-white shadow-md"/></div>
                      </div>
                      <p className="text-[9px] text-slate-500 mt-1.5 font-semibold">3 dk uzaklıkta • Müsait</p>
                    </div>
                    <div className="grid grid-cols-2 gap-2">{[['💼','1 Valiz'],['⏱️','2 Gün']].map(([e,l])=><div key={l} className="rounded-xl bg-white/80 border border-white/90 p-2 text-center"><p className="text-sm">{e}</p><p className="text-[8px] text-slate-400 mt-0.5">{l}</p></div>)}</div>
                  </div>
                </div>
              </div>
            </div>

            {/* Phone right */}
            <div className="hidden md:block" style={{ animation: 'float3 4.5s ease-in-out infinite 0.8s' }}>
              <div className="rounded-[36px] shadow-[0_30px_60px_rgba(0,0,0,0.5)]" style={{ transform: 'rotate(7deg)', background: '#0c0e1a', padding: 9, width: 200 }}>
                <div className="rounded-[29px] overflow-hidden" style={{ height: 390, background: 'linear-gradient(160deg, #1a0533, #2d1060)' }}>
                  <div className="p-4 space-y-3">
                    <div className="h-3 w-16 rounded-full bg-white/10"/>
                    <div className="h-4 w-24 rounded-full bg-white/20"/>
                    <div className="rounded-2xl p-3" style={{ background: 'rgba(139,92,246,0.2)' }}>
                      <p className="text-[9px] text-purple-300 font-bold mb-1">CÜZDAN</p>
                      <p className="text-2xl font-black text-white">₺240</p>
                      <p className="text-[8px] text-emerald-400 font-bold mt-0.5">+₺20 bu ay</p>
                    </div>
                    {['Taksim', 'Beyoğlu', 'Kadıköy'].map((t,j)=><div key={t} className="flex items-center gap-2 rounded-xl p-2.5" style={{ background: 'rgba(255,255,255,0.05)' }}><div className="h-6 w-6 rounded-full" style={{ background: ['linear-gradient(135deg,#f43f5e,#e11d48)','linear-gradient(135deg,#6366f1,#8b5cf6)','linear-gradient(135deg,#f59e0b,#d97706)'][j] }}/><div className="flex-1"><p className="text-[9px] font-bold text-white/80">{t}</p><p className="text-[8px] text-white/40">₺{[30,25,35][j]}</p></div></div>)}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ════════════════ TESTIMONIALS ════════════════ */}
      <section id="reviews" className="py-28">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal className="text-center mb-16">
            <span className="inline-flex items-center gap-2 rounded-full px-4 py-1.5 text-[11px] font-black tracking-widest uppercase mb-5"
              style={{ background: 'linear-gradient(135deg, #fefce8, #fff7ed)', color: '#b45309', border: '1px solid #fde68a' }}>
              ✦ Yorumlar
            </span>
            <h2 className="text-[2.8rem] font-black tracking-[-0.04em] text-slate-900">Gezginler ne diyor?</h2>
            <p className="mt-4 text-[17px] text-slate-500 max-w-md mx-auto">1000+ gezginden gerçek deneyimler.</p>
          </Reveal>

          <motion.div variants={staggerContainer} initial="hidden" whileInView="show" viewport={{ once: true, amount: 0.2 }}
            className="grid grid-cols-1 md:grid-cols-3 gap-5">
            {testimonials.map((t, i) => (
              <motion.div key={t.name} variants={staggerItem} onMouseMove={handleTilt} onMouseLeave={resetTilt}
                className="card-tilt grad-border relative rounded-[24px] bg-white p-7 shadow-[0_4px_20px_rgba(15,23,42,0.06)] overflow-hidden cursor-default group"
                style={{ borderRadius: 24 }}
              >
                {/* Quote mark */}
                <div className="absolute top-5 right-6 text-[60px] font-black leading-none select-none opacity-5 text-slate-900">&ldquo;</div>

                <div className="flex gap-0.5 mb-5">
                  {[...Array(5)].map((_,j)=><Star key={j} className="h-4 w-4 fill-amber-400 text-amber-400" />)}
                  <span className="ml-1.5 text-[12px] font-bold text-amber-600">5.0</span>
                </div>
                <p className="text-[15px] leading-[1.75] text-slate-600 mb-6">&ldquo;{t.text}&rdquo;</p>
                <div className="flex items-center gap-3 pt-5 border-t border-slate-100">
                  <div className="flex h-11 w-11 items-center justify-center rounded-full text-base font-black text-white shadow-md flex-shrink-0" style={{ background: `linear-gradient(135deg, ${t.grad.replace('from-','').split(' ')[0].replace('from-','')})` }}>
                    {t.avatar}
                  </div>
                  <div>
                    <p className="text-[14px] font-black text-slate-900">{t.name}</p>
                    <p className="text-[12px] text-slate-400 font-medium">{t.role}</p>
                  </div>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* ════════════════ CTA ════════════════ */}
      <section className="py-28">
        <div className="max-w-[1200px] mx-auto px-6">
          <Reveal>
            <div className="relative overflow-hidden rounded-[40px] px-8 py-24 text-center shadow-[0_40px_100px_rgba(99,102,241,0.35)]"
              style={{ background: 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 35%, #ec4899 70%, #f43f5e 100%)', backgroundSize: '300% 300%', animation: 'gradientShift 5s ease infinite' }}>
              {/* Orbs */}
              <div className="pointer-events-none absolute -top-24 -left-24 h-96 w-96 rounded-full bg-white/5 blur-3xl" />
              <div className="pointer-events-none absolute -bottom-24 -right-24 h-80 w-80 rounded-full bg-white/8 blur-2xl" />
              {/* Mesh dots */}
              <div className="pointer-events-none absolute inset-0 opacity-10">
                <svg width="100%" height="100%"><defs><pattern id="dots" width="30" height="30" patternUnits="userSpaceOnUse"><circle cx="2" cy="2" r="1.5" fill="white"/></pattern></defs><rect width="100%" height="100%" fill="url(#dots)"/></svg>
              </div>

              <div className="relative z-10 max-w-2xl mx-auto space-y-8">
                <span className="inline-flex items-center gap-2 rounded-full bg-white/10 border border-white/20 px-4 py-1.5 text-[11px] font-black tracking-widest text-white/80 uppercase">
                  <span className="h-1.5 w-1.5 rounded-full bg-emerald-400 animate-pulse" />
                  Seyahate Hazır
                </span>
                <h2 className="text-[3.2rem] font-black tracking-[-0.04em] text-white leading-tight">
                  Hazır mısın özgür<br />gezmeye?
                </h2>
                <p className="text-[17px] leading-relaxed" style={{ color: 'rgba(255,255,255,0.75)' }}>
                  Bavulunu taşıma derdini geride bırak. Kyradi ile yolculuk daha hafif, daha konforlu, daha özgür.
                </p>
                <div className="flex flex-wrap items-center justify-center gap-4">
                  <Link
                    href={hasSession ? '/dashboard' : '/register'}
                    className="shimmer-btn relative overflow-hidden flex items-center gap-2 rounded-full bg-white px-9 py-4 text-[16px] font-black text-indigo-700 shadow-[0_12px_40px_rgba(0,0,0,0.2)] hover:shadow-[0_20px_60px_rgba(0,0,0,0.3)] hover:-translate-y-1 transition-all"
                  >
                    Şimdi Başla <ArrowRight className="h-4 w-4" />
                  </Link>
                  <a href="#works" className="flex items-center gap-2 rounded-full border-2 border-white/30 bg-white/10 px-9 py-4 text-[16px] font-bold text-white hover:bg-white/20 hover:-translate-y-0.5 transition-all backdrop-blur">
                    Nasıl Çalışır?
                  </a>
                </div>
                <p className="text-[13px] font-medium" style={{ color: 'rgba(255,255,255,0.5)' }}>
                  Güvenli • Hızlı • Kolay kullanım • 7/24 destek
                </p>
              </div>
            </div>
          </Reveal>
        </div>
      </section>

      {/* ════════════════ FOOTER ════════════════ */}
      <footer className="border-t border-slate-100 py-10">
        <div className="max-w-[1200px] mx-auto px-6">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-6">
            <div className="flex items-center gap-3">
              <img src="/app-icon.svg" alt="Kyradi" className="h-9 w-9 flex-shrink-0" style={{ borderRadius: 10 }} />
              <div>
                <p className="text-[12px] font-black tracking-[0.22em] text-slate-900">KYRADI</p>
                <p className="text-[10px] text-slate-400">SuperApp</p>
              </div>
            </div>
            <div className="flex flex-wrap items-center justify-center gap-5">
              {[
                { icon: ShieldCheck, label: 'Güvenli teslim', color: '#10b981' },
                { icon: CreditCard, label: 'Kolay ödeme', color: '#6366f1' },
                { icon: Clock3, label: '7/24 Erişim', color: '#f59e0b' },
                { icon: Lock, label: 'Şifreli güvenlik', color: '#06b6d4' },
              ].map(({ icon: Icon, label, color }) => (
                <div key={label} className="flex items-center gap-1.5 text-[13px] font-medium text-slate-500">
                  <Icon className="h-4 w-4" style={{ color }} />
                  {label}
                </div>
              ))}
            </div>
            <p className="text-[12px] text-slate-400 font-medium">© 2025 Kyradi</p>
          </div>
        </div>
      </footer>

    </main>
  );
}
