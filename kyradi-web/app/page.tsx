'use client';

import Link from 'next/link';
import { useEffect, useRef, useState } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import { getToken } from '@/lib/auth';

const trustStats = [
  { value: '1000+', label: 'gezgin kullanıyor' },
  { value: '3 dk', label: 'ortalama teslim noktası uzaklığı' },
  { value: '7/24', label: 'şehir içinde erişilebilir noktalar' },
];

const howSteps = [
  {
    title: 'Konumunu seç',
    desc: 'Şehirde nerede olduğunu belirt, yakın noktaları anında gör.',
    icon: '📍',
  },
  {
    title: 'Noktanı bul',
    desc: 'Müsait ve güvenli teslim noktasını tek ekranda seç.',
    icon: '🗺️',
  },
  {
    title: 'Bavulunu bırak ve gez',
    desc: 'QR ile bırak, ellerin boş şekilde şehrin tadını çıkar.',
    icon: '🧳',
  },
];

const storyItems = [
  {
    title: 'Otele erken geldin',
    desc: 'Check-in saatin gelmedi ve bavulla beklemek zorunda kalıyorsun.',
  },
  {
    title: 'Bavulunla gezmek istemiyorsun',
    desc: 'Kafeler, müzeler, sokaklar... ama yük seni yavaşlatıyor.',
  },
  {
    title: 'Kyradi ile yakın noktayı buluyorsun',
    desc: 'Haritadan seçip hızlı rezervasyonla bavulunu güvenle bırakıyorsun.',
  },
  {
    title: 'Eller boş, gün senin',
    desc: 'Şehri özgürce geziyor, teslim saatinde kolayca geri alıyorsun.',
  },
];

const features = [
  { title: 'Güvenli teslim', icon: '🧷' },
  { title: 'Hızlı rezervasyon', icon: '⚡' },
  { title: 'Yakındaki noktalar', icon: '📍' },
  { title: 'Kolay ödeme', icon: '💳' },
  { title: 'Basit deneyim', icon: '✨' },
  { title: 'Anlık erişim', icon: '📱' },
];

const testimonials = [
  {
    name: 'Elif Y.',
    role: 'İstanbul',
    review: 'Valiz taşımadan şehri gezmek gerçek anlamda günü kurtarıyor.',
  },
  {
    name: 'Can A.',
    role: 'Paris',
    review: 'Arayüz çok sade, işlem birkaç adımda bitiyor. Tam seyahat dostu.',
  },
  {
    name: 'Mina K.',
    role: 'Londra',
    review: 'Erken uçuş günlerinde bagajı bırakıp rahatça gezebiliyorum.',
  },
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
      initial={{ opacity: 0, y: 24 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.2 }}
      transition={{ duration: 0.6, delay, ease: 'easeOut' }}
    >
      {children}
    </motion.div>
  );
}

function SectionTitle({
  tag,
  title,
  desc,
}: {
  tag: string;
  title: string;
  desc?: string;
}) {
  return (
    <div className="mx-auto mb-10 max-w-2xl text-center">
      <p className="text-sm font-semibold text-indigo-500">{tag}</p>
      <h2 className="mt-2 text-3xl font-semibold tracking-tight text-slate-900 md:text-5xl">{title}</h2>
      {desc ? <p className="mt-4 text-slate-600">{desc}</p> : null}
    </div>
  );
}

export default function HomePage() {
  const [hasSession, setHasSession] = useState(false);
  const heroRef = useRef<HTMLElement | null>(null);
  const { scrollYProgress } = useScroll({
    target: heroRef,
    offset: ['start start', 'end start'],
  });
  const parallax = useTransform(scrollYProgress, [0, 1], [0, 40]);

  useEffect(() => {
    setHasSession(Boolean(getToken()));
  }, []);

  return (
    <main className="relative min-h-screen overflow-x-hidden bg-[#fcfcfe] text-slate-900">
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(44rem_44rem_at_6%_12%,rgba(236,72,153,0.12),transparent_62%),radial-gradient(48rem_48rem_at_96%_10%,rgba(99,102,241,0.14),transparent_62%),radial-gradient(48rem_48rem_at_70%_92%,rgba(34,211,238,0.13),transparent_62%)]" />

      <header className="sticky top-0 z-40 border-b border-slate-200/70 bg-white/80 backdrop-blur-xl">
        <div className="mx-auto flex w-full max-w-7xl items-center justify-between px-5 py-4 md:px-8">
          <div className="flex items-center gap-3">
            <span className="h-10 w-10 rounded-2xl bg-gradient-to-br from-indigo-500 to-cyan-400 shadow-[0_10px_24px_rgba(99,102,241,.24)]" />
            <div>
              <p className="text-sm font-semibold tracking-[0.18em] text-slate-900">KYRADI</p>
              <p className="text-xs text-slate-500">SuperApp</p>
            </div>
          </div>
          <nav className="hidden items-center gap-7 text-sm font-medium text-slate-600 md:flex">
            <a href="#works" className="hover:text-slate-900">Nasıl Çalışır</a>
            <a href="#features" className="hover:text-slate-900">Özellikler</a>
            <a href="#security" className="hover:text-slate-900">Güvenlik</a>
            <a href="#reviews" className="hover:text-slate-900">Yorumlar</a>
          </nav>
          <Link
            href={hasSession ? '/dashboard' : '/register'}
            className="rounded-xl bg-gradient-to-r from-indigo-500 to-cyan-400 px-4 py-2 text-sm font-semibold text-white shadow-[0_12px_24px_rgba(99,102,241,.28)] transition hover:scale-[1.02]"
          >
            Uygulamayı Keşfet
          </Link>
        </div>
      </header>

      <section ref={heroRef} className="relative z-10 mx-auto grid w-full max-w-7xl items-center gap-12 px-5 pb-20 pt-14 md:px-8 lg:grid-cols-2 lg:pt-20">
        <motion.div style={{ y: parallax }}>
          <Reveal>
            <span className="inline-flex rounded-full border border-indigo-200 bg-white px-4 py-2 text-xs font-semibold text-indigo-600 shadow-sm">
              Seyahatin en hafif hali
            </span>
          </Reveal>
          <Reveal delay={0.08}>
            <h1 className="mt-5 text-5xl font-semibold leading-[1.02] tracking-tight text-slate-900 md:text-7xl">
              Bavulunu bırak.
              <br />
              Şehri özgürce keşfet.
            </h1>
          </Reveal>
          <Reveal delay={0.16}>
            <p className="mt-6 max-w-xl text-lg text-slate-600">
              Ağır yüklerden kurtul, yakındaki güvenli noktayı bul, bavulunu bırak ve anın tadını çıkar. Kyradi ile şehir senin.
            </p>
          </Reveal>
          <Reveal delay={0.22}>
            <div className="mt-8 flex flex-wrap gap-3">
              <a href="#works" className="rounded-2xl bg-gradient-to-r from-indigo-500 to-cyan-400 px-6 py-3 font-semibold text-white shadow-[0_14px_28px_rgba(99,102,241,.28)] transition hover:-translate-y-0.5">
                Uygulamayı Keşfet
              </a>
              <a href="#story" className="rounded-2xl border border-slate-200 bg-white px-6 py-3 font-semibold text-slate-700 transition hover:bg-slate-50">
                Nasıl Çalışır?
              </a>
            </div>
          </Reveal>
          <Reveal delay={0.28}>
            <p className="mt-6 text-sm text-slate-500">Güvenli teslim noktaları • Hızlı rezervasyon • Kolay kullanım</p>
          </Reveal>
        </motion.div>

        <Reveal delay={0.14}>
          <div className="relative rounded-[2rem] border border-slate-200 bg-gradient-to-br from-white via-[#f7f5ff] to-[#f2fbff] p-6 shadow-[0_30px_70px_rgba(15,23,42,.10)]">
            <motion.div
              className="absolute -left-7 top-12 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 shadow-lg"
              animate={{ y: [0, -8, 0] }}
              transition={{ duration: 4, repeat: Infinity, ease: 'easeInOut' }}
            >
              Rezervasyon onaylandı
            </motion.div>
            <motion.div
              className="absolute -right-8 top-28 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 shadow-lg"
              animate={{ y: [0, 9, 0] }}
              transition={{ duration: 4.6, repeat: Infinity, ease: 'easeInOut' }}
            >
              Yakındaki nokta: 3 dk
            </motion.div>
            <motion.div
              className="absolute -bottom-5 right-14 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 shadow-lg"
              animate={{ y: [0, -7, 0] }}
              transition={{ duration: 3.6, repeat: Infinity, ease: 'easeInOut' }}
            >
              Güvenli teslim • Hızlı giriş
            </motion.div>

            <motion.div
              className="mx-auto w-[280px] rounded-[2.3rem] border border-slate-200 bg-[#0f172a] p-3 shadow-[0_20px_40px_rgba(2,6,23,.22)]"
              animate={{ y: [0, -10, 0] }}
              transition={{ duration: 5.2, repeat: Infinity, ease: 'easeInOut' }}
            >
              <div className="rounded-[1.8rem] bg-gradient-to-b from-indigo-500/25 to-cyan-400/20 p-4">
                <div className="h-5 w-20 rounded-full bg-white/20" />
                <div className="mt-4 rounded-2xl bg-white/90 p-4">
                  <p className="text-xs text-slate-500">Aktif nokta</p>
                  <p className="text-lg font-semibold text-slate-900">Taksim KYRADI</p>
                  <p className="text-xs text-slate-600">Teslime 2s 14dk</p>
                </div>
                <div className="mt-3 grid grid-cols-2 gap-2">
                  <div className="rounded-xl bg-white/85 p-3 text-xs text-slate-700">QR Hazır</div>
                  <div className="rounded-xl bg-white/85 p-3 text-xs text-slate-700">Durum: Müsait</div>
                </div>
              </div>
            </motion.div>
          </div>
        </Reveal>
      </section>

      <section className="relative z-10 mx-auto w-full max-w-7xl px-5 pb-16 md:px-8">
        <div className="grid gap-4 md:grid-cols-3">
          {trustStats.map((item) => (
            <Reveal key={item.label}>
              <div className="rounded-3xl border border-slate-200 bg-white p-6 shadow-[0_16px_34px_rgba(15,23,42,.06)]">
                <p className="text-3xl font-semibold text-slate-900">{item.value}</p>
                <p className="mt-2 text-slate-600">{item.label}</p>
              </div>
            </Reveal>
          ))}
        </div>
      </section>

      <section id="works" className="mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <SectionTitle
          tag="Nasıl Çalışır?"
          title="3 adımda valiz yükünden kurtul"
          desc="Kyradi ile süreç hızlı, sade ve ilk kullanımda bile anlaşılır."
        />
        <div className="grid gap-4 md:grid-cols-3">
          {howSteps.map((step, index) => (
            <Reveal key={step.title} delay={index * 0.06}>
              <motion.article
                whileHover={{ y: -5 }}
                className="rounded-3xl border border-slate-200 bg-white p-6 shadow-[0_18px_36px_rgba(15,23,42,.07)] transition"
              >
                <div className="flex items-center justify-between">
                  <span className="inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-indigo-100 to-cyan-100 text-2xl">
                    {step.icon}
                  </span>
                  <span className="text-sm font-semibold text-indigo-500">{`0${index + 1}`}</span>
                </div>
                <h3 className="mt-5 text-2xl font-semibold text-slate-900">{step.title}</h3>
                <p className="mt-2 text-slate-600">{step.desc}</p>
              </motion.article>
            </Reveal>
          ))}
        </div>
      </section>

      <section id="story" className="mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <SectionTitle
          tag="Deneyim Hikayesi"
          title="Şehri taşımadan yaşa"
          desc="Kyradi seni yük taşımaktan, anı yaşamaya geçirir."
        />
        <div className="space-y-4">
          {storyItems.map((item, idx) => (
            <Reveal key={item.title} delay={idx * 0.05}>
              <div className={`grid items-center gap-6 rounded-3xl border border-slate-200 bg-gradient-to-r from-[#fff4f6] via-white to-[#eef8ff] p-6 shadow-[0_14px_30px_rgba(15,23,42,.06)] md:grid-cols-2 ${idx % 2 ? 'md:[&>*:first-child]:order-2' : ''}`}>
                <div>
                  <h3 className="text-2xl font-semibold text-slate-900">{item.title}</h3>
                  <p className="mt-2 text-slate-600">{item.desc}</p>
                </div>
                <div className="rounded-2xl border border-slate-200 bg-white/80 p-6">
                  <div className="h-32 rounded-2xl bg-gradient-to-br from-indigo-100 via-fuchsia-100 to-cyan-100" />
                </div>
              </div>
            </Reveal>
          ))}
        </div>
      </section>

      <section id="features" className="mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <SectionTitle
          tag="Özellikler"
          title="Seyahatini kolaylaştıran detaylar"
        />
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {features.map((item, i) => (
            <Reveal key={item.title} delay={i * 0.05}>
              <motion.article
                whileHover={{ y: -5 }}
                className="rounded-3xl border border-slate-200 bg-white p-6 shadow-[0_16px_34px_rgba(15,23,42,.06)]"
              >
                <span className="inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-indigo-100 to-cyan-100 text-xl">
                  {item.icon}
                </span>
                <h3 className="mt-4 text-xl font-semibold text-slate-900">{item.title}</h3>
              </motion.article>
            </Reveal>
          ))}
        </div>
      </section>

      <section id="security" className="mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <SectionTitle
          tag="Uygulama Önizleme"
          title="Gerçek bir seyahat günü için tasarlandı"
        />
        <div className="relative rounded-[2rem] border border-slate-200 bg-gradient-to-br from-[#f8f7ff] via-white to-[#eef9ff] p-8 shadow-[0_24px_54px_rgba(15,23,42,.08)]">
          <motion.div
            className="mx-auto grid max-w-4xl items-end gap-4 md:grid-cols-3"
            initial={{ opacity: 0, y: 24 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.7 }}
          >
            <div className="mx-auto h-[320px] w-[190px] rounded-[2rem] border border-slate-200 bg-white p-2 shadow-xl md:translate-y-8">
              <div className="h-full rounded-[1.5rem] bg-gradient-to-b from-indigo-100 to-cyan-100" />
            </div>
            <div className="mx-auto h-[380px] w-[220px] rounded-[2.2rem] border border-slate-200 bg-white p-2 shadow-2xl">
              <div className="h-full rounded-[1.7rem] bg-gradient-to-b from-indigo-200 to-cyan-100" />
            </div>
            <div className="mx-auto h-[320px] w-[190px] rounded-[2rem] border border-slate-200 bg-white p-2 shadow-xl md:translate-y-8">
              <div className="h-full rounded-[1.5rem] bg-gradient-to-b from-fuchsia-100 to-indigo-100" />
            </div>
          </motion.div>
        </div>
      </section>

      <section id="reviews" className="mx-auto w-full max-w-7xl px-5 py-16 md:px-8">
        <SectionTitle
          tag="Yorumlar"
          title="Gezginler Kyradi’yi neden seviyor?"
        />
        <div className="grid gap-4 md:grid-cols-3">
          {testimonials.map((item, i) => (
            <Reveal key={item.name} delay={i * 0.06}>
              <article className="rounded-3xl border border-slate-200 bg-white p-6 shadow-[0_14px_30px_rgba(15,23,42,.06)]">
                <div className="flex items-center gap-3">
                  <span className="inline-flex h-11 w-11 items-center justify-center rounded-full bg-gradient-to-br from-indigo-100 to-cyan-100 font-semibold text-slate-700">
                    {item.name[0]}
                  </span>
                  <div>
                    <p className="font-semibold text-slate-900">{item.name}</p>
                    <p className="text-sm text-slate-500">{item.role}</p>
                  </div>
                </div>
                <p className="mt-4 text-slate-600">{item.review}</p>
              </article>
            </Reveal>
          ))}
        </div>
      </section>

      <section className="mx-auto w-full max-w-7xl px-5 pb-24 pt-10 md:px-8">
        <Reveal>
          <div className="rounded-[2rem] border border-slate-200 bg-gradient-to-r from-[#eef6ff] via-white to-[#f7f1ff] px-8 py-12 text-center shadow-[0_24px_56px_rgba(15,23,42,.10)]">
            <h2 className="text-4xl font-semibold tracking-tight text-slate-900 md:text-6xl">Hazır mısın daha özgür gezmeye?</h2>
            <p className="mx-auto mt-4 max-w-3xl text-slate-600">
              Bavulunu taşıma derdini geride bırak. Kyradi ile yolculuk daha hafif, daha konforlu, daha özgür.
            </p>
            <Link
              href={hasSession ? '/dashboard' : '/register'}
              className="mt-8 inline-flex rounded-2xl bg-gradient-to-r from-indigo-500 to-cyan-400 px-8 py-4 text-lg font-semibold text-white shadow-[0_16px_34px_rgba(99,102,241,.28)] transition hover:-translate-y-0.5"
            >
              Şimdi Başla
            </Link>
          </div>
        </Reveal>
      </section>
    </main>
  );
}
