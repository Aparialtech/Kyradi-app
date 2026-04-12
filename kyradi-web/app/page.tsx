'use client';

import Link from 'next/link';
import { useEffect, useMemo, useState } from 'react';
import { motion } from 'framer-motion';
import {
  CheckCircle2,
  Clock3,
  CreditCard,
  MapPin,
  Navigation,
  Search,
  ShieldCheck,
  Sparkles,
  Smartphone,
  Wallet,
  Zap,
} from 'lucide-react';
import { getToken } from '@/lib/auth';

const heroSlides = [
  {
    city: 'İstanbul',
    title: 'Taksim KYRADI noktası',
    subtitle: 'Rezervasyon onaylandı • Teslime 2s 14dk',
    badge: '3 dk uzaklıkta',
  },
  {
    city: 'Paris',
    title: 'Louvre KYRADI noktası',
    subtitle: 'Hızlı giriş açık • QR hazır',
    badge: '5 dk uzaklıkta',
  },
  {
    city: 'Londra',
    title: 'Soho KYRADI noktası',
    subtitle: 'Güvenli teslim • Müsait',
    badge: '4 dk uzaklıkta',
  },
];

const trustStats = [
  { value: '1000+', label: 'gezgin' },
  { value: '3 dk', label: 'ortalama yakın nokta' },
  { value: '7/24', label: 'şehir içi erişim' },
];

const steps = [
  {
    icon: Search,
    title: 'Konumunu seç',
    text: 'Bulunduğun konuma göre en yakın noktaları anında gör.',
  },
  {
    icon: Navigation,
    title: 'Noktanı bul',
    text: 'Müsait ve güvenli teslim noktasını seç, rezervasyon oluştur.',
  },
  {
    icon: CheckCircle2,
    title: 'Bavulunu bırak ve gez',
    text: 'QR ile bırak, günün geri kalanını yük taşımadan geçir.',
  },
];

const story = [
  {
    title: 'Otele erken geldin',
    text: 'Check-in saatin henüz başlamadı ve valiz yanında.',
  },
  {
    title: 'Bavulunla gezmek istemiyorsun',
    text: 'Müzeler, kafeler ve sokaklar var ama yük seni yavaşlatıyor.',
  },
  {
    title: 'Kyradi ile yakın noktayı buluyorsun',
    text: 'Birkaç dokunuşla en yakın noktaya rezervasyon açıyorsun.',
  },
  {
    title: 'Eller boş, gün senin',
    text: 'Bavulunu bırakıp şehri özgürce keşfediyorsun.',
  },
];

const features = [
  { icon: ShieldCheck, title: 'Güvenli teslim' },
  { icon: Zap, title: 'Hızlı rezervasyon' },
  { icon: MapPin, title: 'Yakındaki noktalar' },
  { icon: CreditCard, title: 'Kolay ödeme' },
  { icon: Sparkles, title: 'Basit deneyim' },
  { icon: Smartphone, title: 'Anlık erişim' },
];

const testimonials = [
  { name: 'Elif Y.', text: 'Valiz taşımadan tüm günümü rahatça gezerek geçirdim.' },
  { name: 'Can A.', text: 'Arayüz çok temiz. Rezervasyon akışı çok hızlı ilerliyor.' },
  { name: 'Mina K.', text: 'Uçuş öncesi saatlerde gerçekten hayat kurtarıyor.' },
];

function Section({
  id,
  children,
  className = '',
}: {
  id?: string;
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <section id={id} className={`py-24 ${className}`}>
      <div className="max-w-6xl mx-auto px-6">{children}</div>
    </section>
  );
}

function Reveal({
  children,
  delay = 0,
}: {
  children: React.ReactNode;
  delay?: number;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.2 }}
      transition={{ duration: 0.45, delay }}
    >
      {children}
    </motion.div>
  );
}

function IconBubble({ icon: Icon }: { icon: React.ComponentType<{ className?: string }> }) {
  return (
    <span className="inline-flex h-12 w-12 items-center justify-center rounded-2xl border border-indigo-100 bg-gradient-to-br from-indigo-50 to-cyan-50 shadow-[inset_0_1px_0_rgba(255,255,255,0.9)]">
      <Icon className="h-5 w-5 text-indigo-500" />
    </span>
  );
}

export default function HomePage() {
  const [hasSession, setHasSession] = useState(false);
  const [activeSlide, setActiveSlide] = useState(0);

  useEffect(() => {
    setHasSession(Boolean(getToken()));
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      setActiveSlide((prev) => (prev + 1) % heroSlides.length);
    }, 4200);
    return () => clearInterval(interval);
  }, []);

  const currentSlide = useMemo(() => heroSlides[activeSlide], [activeSlide]);

  return (
    <main className="bg-white text-slate-900">
      <header className="sticky top-0 z-40 border-b border-slate-200/80 bg-white/90 backdrop-blur">
        <div className="max-w-6xl mx-auto px-6">
          <div className="flex items-center justify-between py-5">
            <div className="flex items-center gap-3">
              <span className="h-10 w-10 rounded-xl bg-gradient-to-br from-indigo-500 to-cyan-400 shadow-[0_10px_22px_rgba(99,102,241,0.28)]" />
              <div>
                <p className="text-sm font-bold tracking-[0.18em]">KYRADI</p>
                <p className="text-xs text-slate-500">SuperApp</p>
              </div>
            </div>
            <nav className="hidden items-center gap-6 text-sm font-medium text-slate-600 md:flex">
              <a href="#works" className="hover:text-slate-900">Nasıl Çalışır</a>
              <a href="#features" className="hover:text-slate-900">Özellikler</a>
              <a href="#mobile" className="hover:text-slate-900">Mobil</a>
              <a href="#reviews" className="hover:text-slate-900">Yorumlar</a>
            </nav>
            <Link
              href={hasSession ? '/dashboard' : '/register'}
              className="rounded-full px-6 py-3 text-sm font-semibold text-white bg-gradient-to-r from-indigo-500 to-cyan-400 shadow-[0_12px_24px_rgba(99,102,241,0.28)]"
            >
              Uygulamayı Keşfet
            </Link>
          </div>
        </div>
      </header>

      <Section className="bg-[radial-gradient(60rem_30rem_at_75%_0%,rgba(99,102,241,0.12),transparent_65%),radial-gradient(50rem_30rem_at_5%_15%,rgba(34,211,238,0.11),transparent_64%)]">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div className="space-y-6">
            <Reveal>
              <span className="inline-flex rounded-full border border-indigo-200 bg-indigo-50 px-4 py-2 text-xs font-semibold text-indigo-600">
                Seyahatin en hafif hali
              </span>
            </Reveal>
            <Reveal delay={0.05}>
              <h1 className="text-5xl font-bold leading-tight">
                Bavulunu bırak.
                <br />
                Şehri özgürce keşfet.
              </h1>
            </Reveal>
            <Reveal delay={0.1}>
              <p className="text-lg text-gray-600 max-w-xl">
                Ağır yüklerden kurtul, yakındaki güvenli noktayı bul, bavulunu bırak ve anın tadını çıkar.
                Kyradi ile şehir senin.
              </p>
            </Reveal>
            <Reveal delay={0.15}>
              <div className="flex flex-wrap gap-3">
                <a href="#works" className="rounded-full px-6 py-3 text-white font-semibold bg-gradient-to-r from-indigo-500 to-cyan-400">
                  Uygulamayı Keşfet
                </a>
                <a href="#story" className="rounded-full px-6 py-3 border border-slate-300 text-slate-700 font-semibold bg-white">
                  Nasıl Çalışır?
                </a>
              </div>
            </Reveal>
            <Reveal delay={0.2}>
              <p className="text-sm text-slate-500">Güvenli teslim noktaları • Hızlı rezervasyon • Kolay kullanım</p>
            </Reveal>
          </div>

          <Reveal delay={0.1}>
            <div className="rounded-3xl border border-slate-200 bg-gradient-to-br from-[#fff8f6] via-white to-[#f2f8ff] p-8 shadow-[0_24px_48px_rgba(15,23,42,0.08)]">
              <div className="relative mx-auto w-[290px]">
                <motion.div
                  animate={{ y: [0, -10, 0] }}
                  transition={{ duration: 4.6, repeat: Infinity }}
                  className="rounded-[2.2rem] border border-slate-200 bg-[#0f172a] p-3 shadow-[0_18px_40px_rgba(15,23,42,0.24)]"
                >
                  <div className="h-[500px] rounded-[1.8rem] bg-gradient-to-b from-indigo-200 via-white to-cyan-100 p-4">
                    <div className="flex items-center justify-between">
                      <div className="h-6 w-20 rounded-full bg-white/70" />
                      <span className="text-xs font-semibold text-indigo-600">{currentSlide.city}</span>
                    </div>
                    <div className="mt-4 rounded-2xl bg-white p-4 shadow-sm">
                      <p className="text-xs text-slate-500">Aktif rezervasyon</p>
                      <p className="font-semibold text-slate-900">{currentSlide.title}</p>
                      <p className="text-xs text-slate-600">{currentSlide.subtitle}</p>
                    </div>
                    <div className="mt-3 grid grid-cols-2 gap-2 text-xs">
                      <div className="rounded-xl border border-slate-200 bg-white p-3 text-slate-700">QR Hazır</div>
                      <div className="rounded-xl border border-slate-200 bg-white p-3 text-slate-700">Güvenli Teslim</div>
                    </div>
                    <div className="mt-3 rounded-2xl border border-slate-200 bg-white p-4">
                      <p className="text-xs text-slate-500">Yakındaki nokta</p>
                      <p className="text-sm font-semibold text-slate-800">{currentSlide.badge}</p>
                    </div>
                  </div>
                </motion.div>

                <div className="absolute -left-24 top-14 hidden rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-md xl:block">
                  <div className="flex items-center gap-2 text-sm text-slate-700">
                    <CheckCircle2 className="h-4 w-4 text-emerald-500" />
                    Rezervasyon onaylandı
                  </div>
                </div>
                <div className="absolute -right-24 top-28 hidden rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-md xl:block">
                  <div className="flex items-center gap-2 text-sm text-slate-700">
                    <Clock3 className="h-4 w-4 text-indigo-500" />
                    {currentSlide.badge}
                  </div>
                </div>
                <div className="absolute -bottom-4 left-12 hidden rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-md xl:block">
                  <div className="flex items-center gap-2 text-sm text-slate-700">
                    <ShieldCheck className="h-4 w-4 text-cyan-500" />
                    Güvenli giriş
                  </div>
                </div>
              </div>
              <div className="mt-5 flex justify-center gap-2">
                {heroSlides.map((slide, i) => (
                  <button
                    key={slide.city}
                    type="button"
                    onClick={() => setActiveSlide(i)}
                    className={`h-2.5 rounded-full transition-all ${i === activeSlide ? 'w-7 bg-indigo-500' : 'w-2.5 bg-slate-300'}`}
                    aria-label={`slide-${i + 1}`}
                  />
                ))}
              </div>
            </div>
          </Reveal>
        </div>
      </Section>

      <Section>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {trustStats.map((item, i) => (
            <Reveal key={item.label} delay={i * 0.05}>
              <div className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                <p className="text-3xl font-bold">{item.value}</p>
                <p className="mt-2 text-gray-600">{item.label}</p>
              </div>
            </Reveal>
          ))}
        </div>
      </Section>

      <Section id="works">
        <div className="text-center space-y-3">
          <p className="text-sm font-semibold text-indigo-500">Nasıl Çalışır?</p>
          <h2 className="text-4xl font-bold">3 adımda valiz yükünden kurtul</h2>
        </div>
        <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6">
          {steps.map((step, i) => (
            <Reveal key={step.title} delay={i * 0.05}>
              <motion.div whileHover={{ y: -4 }} className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm space-y-4">
                <IconBubble icon={step.icon} />
                <h3 className="text-2xl font-semibold">{step.title}</h3>
                <p className="text-gray-600">{step.text}</p>
              </motion.div>
            </Reveal>
          ))}
        </div>
      </Section>

      <Section id="story">
        <div className="text-center space-y-3">
          <p className="text-sm font-semibold text-indigo-500">Deneyim Hikayesi</p>
          <h2 className="text-4xl font-bold">Şehri taşımadan yaşa</h2>
        </div>
        <div className="mt-12 space-y-6">
          {story.map((item, i) => (
            <Reveal key={item.title} delay={i * 0.04}>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 items-center rounded-3xl border border-slate-200 bg-gradient-to-r from-[#fff7f5] to-[#f4f9ff] p-6">
                <div className={i % 2 ? 'md:order-2' : ''}>
                  <h3 className="text-2xl font-semibold">{item.title}</h3>
                  <p className="mt-2 text-slate-600">{item.text}</p>
                </div>
                <div className="rounded-2xl border border-slate-200 bg-white p-5">
                  <div className="h-28 rounded-xl bg-gradient-to-br from-indigo-100 to-cyan-100" />
                </div>
              </div>
            </Reveal>
          ))}
        </div>
      </Section>

      <Section id="features">
        <div className="text-center space-y-3">
          <p className="text-sm font-semibold text-indigo-500">Özellikler</p>
          <h2 className="text-4xl font-bold">Seyahatini kolaylaştıran detaylar</h2>
        </div>
        <div className="mt-12 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((item, i) => (
            <Reveal key={item.title} delay={i * 0.04}>
              <motion.div whileHover={{ y: -4 }} className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                <IconBubble icon={item.icon} />
                <h3 className="mt-4 text-xl font-semibold">{item.title}</h3>
              </motion.div>
            </Reveal>
          ))}
        </div>
      </Section>

      <Section id="mobile">
        <div className="text-center space-y-3">
          <p className="text-sm font-semibold text-indigo-500">Mobil Önizleme</p>
          <h2 className="text-4xl font-bold">Premium uygulama deneyimi</h2>
        </div>
        <div className="mt-12 rounded-3xl border border-slate-200 bg-gradient-to-br from-[#f8f5ff] to-[#eef8ff] p-8">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 items-end">
            <div className="h-[320px] rounded-[2rem] border border-slate-200 bg-white p-2">
              <div className="h-full rounded-[1.5rem] bg-gradient-to-b from-indigo-100 to-cyan-100" />
            </div>
            <div className="h-[380px] rounded-[2.2rem] border border-slate-200 bg-white p-2 shadow-md">
              <div className="h-full rounded-[1.7rem] bg-gradient-to-b from-indigo-200 to-cyan-100" />
            </div>
            <div className="h-[320px] rounded-[2rem] border border-slate-200 bg-white p-2">
              <div className="h-full rounded-[1.5rem] bg-gradient-to-b from-fuchsia-100 to-indigo-100" />
            </div>
          </div>
        </div>
      </Section>

      <Section id="reviews">
        <div className="text-center space-y-3">
          <p className="text-sm font-semibold text-indigo-500">Yorumlar</p>
          <h2 className="text-4xl font-bold">Gezginler Kyradi’yi neden seviyor?</h2>
        </div>
        <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6">
          {testimonials.map((item, i) => (
            <Reveal key={item.name} delay={i * 0.04}>
              <div className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                <div className="flex items-center gap-3">
                  <span className="inline-flex h-10 w-10 items-center justify-center rounded-full bg-indigo-100 font-semibold text-indigo-700">
                    {item.name[0]}
                  </span>
                  <p className="font-semibold">{item.name}</p>
                </div>
                <p className="mt-4 text-gray-600">{item.text}</p>
              </div>
            </Reveal>
          ))}
        </div>
      </Section>

      <Section>
        <div className="rounded-3xl border border-slate-200 bg-gradient-to-r from-[#eef6ff] to-[#f8f2ff] p-12 text-center space-y-6">
          <h2 className="text-5xl font-bold leading-tight">Hazır mısın daha özgür gezmeye?</h2>
          <p className="text-lg text-gray-600 max-w-3xl mx-auto">
            Bavulunu taşıma derdini geride bırak. Kyradi ile yolculuk daha hafif, daha konforlu, daha özgür.
          </p>
          <Link
            href={hasSession ? '/dashboard' : '/register'}
            className="inline-flex rounded-full px-6 py-3 text-white font-semibold bg-gradient-to-r from-indigo-500 to-cyan-400"
          >
            Şimdi Başla
          </Link>
        </div>
      </Section>

      <Section className="pt-0 pb-12">
        <div className="rounded-2xl border border-slate-200 bg-white px-6 py-4">
          <div className="flex flex-wrap items-center gap-5 text-sm text-slate-600">
            <div className="flex items-center gap-2"><ShieldCheck className="h-4 w-4 text-emerald-500" /> Güvenli teslim</div>
            <div className="flex items-center gap-2"><Wallet className="h-4 w-4 text-indigo-500" /> Kolay ödeme</div>
            <div className="flex items-center gap-2"><Clock3 className="h-4 w-4 text-cyan-500" /> Hızlı süreç</div>
          </div>
        </div>
      </Section>
    </main>
  );
}
