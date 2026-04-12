'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { getToken } from '@/lib/auth';

const trustStats = [
  { value: '1000+', label: 'gezgin' },
  { value: '3 dk', label: 'yakın nokta ortalaması' },
  { value: '7/24', label: 'şehir içinde erişim' },
];

const steps = [
  { icon: '📍', title: 'Konumunu seç', text: 'Bulunduğun yere göre en yakın noktaları gör.' },
  { icon: '🗺️', title: 'Noktanı bul', text: 'Müsait teslim noktasını seç ve rezervasyon oluştur.' },
  { icon: '🧳', title: 'Bavulunu bırak ve gez', text: 'QR ile teslim et, şehri özgürce keşfet.' },
];

const story = [
  'Otele erken geldin, check-in yok.',
  'Bavulunla gezmek istemiyorsun.',
  'Kyradi ile yakındaki noktayı buluyorsun.',
  'Eller boş, gün senin.',
];

const features = [
  { icon: '🧳', title: 'Güvenli teslim' },
  { icon: '⚡', title: 'Hızlı rezervasyon' },
  { icon: '📍', title: 'Yakındaki noktalar' },
  { icon: '💳', title: 'Kolay ödeme' },
  { icon: '✨', title: 'Basit deneyim' },
  { icon: '📱', title: 'Anlık erişim' },
];

const testimonials = [
  { name: 'Elif Y.', text: 'Valiz taşımadan günümü geçirebildim, gerçekten rahatlatıcı.' },
  { name: 'Can A.', text: 'Arayüz çok net. İlk kullanımda bile süreç çok anlaşılır.' },
  { name: 'Mina K.', text: 'Uçuş öncesi valizi bırakıp özgürce gezmek harika his.' },
];

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
      transition={{ duration: 0.5, delay }}
    >
      {children}
    </motion.div>
  );
}

export default function HomePage() {
  const [hasSession, setHasSession] = useState(false);

  useEffect(() => {
    setHasSession(Boolean(getToken()));
  }, []);

  return (
    <main className="bg-white text-slate-900">
      <header className="border-b border-slate-200 bg-white">
        <div className="max-w-6xl mx-auto px-6">
          <div className="flex items-center justify-between py-5">
            <div className="flex items-center gap-3">
              <span className="h-9 w-9 rounded-xl bg-gradient-to-br from-indigo-500 to-cyan-400" />
              <div>
                <p className="text-sm font-bold tracking-[0.16em]">KYRADI</p>
                <p className="text-xs text-slate-500">SuperApp</p>
              </div>
            </div>
            <nav className="hidden items-center gap-6 text-sm text-slate-600 md:flex">
              <a href="#works">Nasıl Çalışır</a>
              <a href="#features">Özellikler</a>
              <a href="#security">Güvenlik</a>
              <a href="#reviews">Yorumlar</a>
            </nav>
            <Link
              href={hasSession ? '/dashboard' : '/register'}
              className="rounded-full px-6 py-3 text-sm font-semibold text-white bg-gradient-to-r from-indigo-500 to-cyan-400"
            >
              Uygulamayı Keşfet
            </Link>
          </div>
        </div>
      </header>

      <section className="py-24">
        <div className="max-w-6xl mx-auto px-6">
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
                  Ağır yüklerden kurtul, yakındaki güvenli noktayı bul, bavulunu bırak ve anın tadını çıkar. Kyradi ile şehir senin.
                </p>
              </Reveal>
              <Reveal delay={0.15}>
                <div className="flex flex-wrap gap-3">
                  <a href="#works" className="rounded-full px-6 py-3 text-white font-semibold bg-gradient-to-r from-indigo-500 to-cyan-400">
                    Uygulamayı Keşfet
                  </a>
                  <a href="#story" className="rounded-full px-6 py-3 border border-slate-300 text-slate-700 font-semibold">
                    Nasıl Çalışır?
                  </a>
                </div>
              </Reveal>
              <Reveal delay={0.2}>
                <p className="text-sm text-slate-500">Güvenli teslim noktaları • Hızlı rezervasyon • Kolay kullanım</p>
              </Reveal>
            </div>

            <Reveal delay={0.1}>
              <div className="rounded-3xl border border-slate-200 bg-gradient-to-br from-[#fff8f6] via-white to-[#f2f8ff] p-8 shadow-[0_24px_48px_rgba(15,23,42,.08)]">
                <div className="relative mx-auto w-[280px]">
                  <motion.div
                    animate={{ y: [0, -10, 0] }}
                    transition={{ duration: 4.5, repeat: Infinity }}
                    className="rounded-[2.2rem] border border-slate-200 bg-[#0f172a] p-3"
                  >
                    <div className="h-[470px] rounded-[1.8rem] bg-gradient-to-b from-indigo-200 to-cyan-100 p-4">
                      <div className="h-6 w-20 rounded-full bg-white/70" />
                      <div className="mt-4 rounded-2xl bg-white p-4">
                        <p className="text-xs text-slate-500">Aktif rezervasyon</p>
                        <p className="font-semibold text-slate-900">Taksim KYRADI</p>
                        <p className="text-xs text-slate-600">Teslime 2s 14dk</p>
                      </div>
                      <div className="mt-3 grid grid-cols-2 gap-2 text-xs">
                        <div className="rounded-xl bg-white p-3 text-slate-700">QR Hazır</div>
                        <div className="rounded-xl bg-white p-3 text-slate-700">Durum: Müsait</div>
                      </div>
                      <div className="mt-3 h-40 rounded-2xl border border-slate-200 bg-white/80" />
                    </div>
                  </motion.div>

                  <div className="absolute -left-20 top-10 hidden rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 shadow-md lg:block">
                    Rezervasyon onaylandı
                  </div>
                  <div className="absolute -right-20 top-24 hidden rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 shadow-md lg:block">
                    Yakındaki nokta: 3 dk
                  </div>
                  <div className="absolute -bottom-4 left-10 hidden rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 shadow-md lg:block">
                    Güvenli teslim
                  </div>
                </div>
              </div>
            </Reveal>
          </div>
        </div>
      </section>

      <section className="py-24">
        <div className="max-w-6xl mx-auto px-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {trustStats.map((item) => (
              <div key={item.label} className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                <p className="text-3xl font-bold">{item.value}</p>
                <p className="mt-2 text-gray-600">{item.label}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section id="works" className="py-24">
        <div className="max-w-6xl mx-auto px-6">
          <div className="text-center space-y-4">
            <h2 className="text-4xl font-bold">Nasıl çalışır?</h2>
          </div>
          <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6">
            {steps.map((step) => (
              <motion.div key={step.title} whileHover={{ y: -4 }} className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm space-y-4">
                <span className="inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-indigo-50 text-2xl">{step.icon}</span>
                <h3 className="text-2xl font-semibold">{step.title}</h3>
                <p className="text-gray-600">{step.text}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <section id="story" className="py-24">
        <div className="max-w-6xl mx-auto px-6">
          <div className="text-center space-y-4">
            <h2 className="text-4xl font-bold">Şehri taşımadan yaşa</h2>
          </div>
          <div className="mt-12 space-y-6">
            {story.map((line, i) => (
              <div key={line} className="grid grid-cols-1 md:grid-cols-2 gap-6 items-center rounded-3xl border border-slate-200 bg-gradient-to-r from-[#fff7f5] to-[#f4f9ff] p-6">
                <div className={i % 2 ? 'md:order-2' : ''}>
                  <h3 className="text-2xl font-semibold">{line}</h3>
                </div>
                <div className="rounded-2xl border border-slate-200 bg-white p-5">
                  <div className="h-28 rounded-xl bg-gradient-to-br from-indigo-100 to-cyan-100" />
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section id="features" className="py-24">
        <div className="max-w-6xl mx-auto px-6">
          <div className="text-center space-y-4">
            <h2 className="text-4xl font-bold">Seyahatini kolaylaştıran detaylar</h2>
          </div>
          <div className="mt-12 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {features.map((item) => (
              <motion.div key={item.title} whileHover={{ y: -4 }} className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                <span className="inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-cyan-50 text-2xl">{item.icon}</span>
                <h3 className="mt-4 text-xl font-semibold">{item.title}</h3>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <section id="security" className="py-24">
        <div className="max-w-6xl mx-auto px-6">
          <div className="text-center space-y-4">
            <h2 className="text-4xl font-bold">Mobil deneyim</h2>
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
        </div>
      </section>

      <section id="reviews" className="py-24">
        <div className="max-w-6xl mx-auto px-6">
          <div className="text-center space-y-4">
            <h2 className="text-4xl font-bold">Gezginler Kyradi’yi neden seviyor?</h2>
          </div>
          <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6">
            {testimonials.map((item) => (
              <div key={item.name} className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                <div className="flex items-center gap-3">
                  <span className="inline-flex h-10 w-10 items-center justify-center rounded-full bg-indigo-100 font-semibold">{item.name[0]}</span>
                  <p className="font-semibold">{item.name}</p>
                </div>
                <p className="mt-4 text-gray-600">{item.text}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="py-24">
        <div className="max-w-6xl mx-auto px-6">
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
        </div>
      </section>
    </main>
  );
}
