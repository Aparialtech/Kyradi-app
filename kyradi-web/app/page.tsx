'use client';

import Image from 'next/image';
import Link from 'next/link';
import { useEffect, useMemo, useState } from 'react';
import { getToken } from '@/lib/auth';
import { NeoIcon } from '@/components/neo-icon';

const slides = [
  {
    id: 1,
    title: 'Bavulunu bırak, şehri keşfet',
    subtitle: 'KYRADI ile güvenli depolama, hızlı teslim ve canlı takip tek ekranda.',
    image: '/landing/hero-slide-1.webp',
  },
  {
    id: 2,
    title: 'Tek uygulama, tam kontrol',
    subtitle: 'Rezervasyon, cüzdan, QR ve lokasyon yönetimi mobil ile birebir senkron.',
    image: '/landing/hero-slide-2.webp',
  },
  {
    id: 3,
    title: 'Hızlı, modern, kullanıcı odaklı',
    subtitle: 'Dakikalar içinde rezervasyon oluştur, öde, bavulunu güvenle teslim et.',
    image: '/landing/hero-slide-1.webp',
  },
];

export default function HomePage() {
  const [active, setActive] = useState(0);
  const [hasSession, setHasSession] = useState(false);

  useEffect(() => {
    setHasSession(Boolean(getToken()));
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      setActive((prev) => (prev + 1) % slides.length);
    }, 4200);
    return () => clearInterval(interval);
  }, []);

  const activeSlide = useMemo(() => slides[active], [active]);

  return (
    <main className="landing-page">
      <div className="landing-bg-orb landing-bg-orb-a" />
      <div className="landing-bg-orb landing-bg-orb-b" />
      <div className="landing-bg-orb landing-bg-orb-c" />

      <header className="landing-topbar card">
        <div className="landing-brand">
          <span className="brand-orb" />
          <div>
            <p className="brand-name">KYRADI</p>
            <p className="brand-sub">Bavulunu bırak, şehri keşfet</p>
          </div>
        </div>
        <nav className="landing-top-actions">
          {hasSession ? (
            <Link href="/dashboard" className="button primary">Panele Git</Link>
          ) : (
            <>
              <Link href="/login" className="button secondary">Giriş Yap</Link>
              <Link href="/register" className="button primary">Kayıt Ol</Link>
            </>
          )}
        </nav>
      </header>

      <section className="landing-hero">
        <article className="landing-left card">
          <div className="landing-kicker">
            <NeoIcon symbol="✦" tone="pink" size="sm" />
            <span>Yeni nesil KYRADI SuperApp</span>
          </div>
          <h1>{activeSlide.title}</h1>
          <p>{activeSlide.subtitle}</p>

          <div className="landing-store-row">
            <a className="store-btn" href="#" aria-label="App Store">
              <span className="store-logo">A</span>
              <span>
                <small>Download on the</small>
                <strong>App Store</strong>
              </span>
            </a>
            <a className="store-btn" href="#" aria-label="Google Play">
              <span className="store-logo">▶</span>
              <span>
                <small>GET IT ON</small>
                <strong>Google Play</strong>
              </span>
            </a>
          </div>

          <div className="landing-feature-grid">
            <div className="feature-chip">
              <NeoIcon symbol="◈" tone="violet" size="sm" />
              <span>QR ile Takip</span>
            </div>
            <div className="feature-chip">
              <NeoIcon symbol="₺" tone="green" size="sm" />
              <span>Hızlı Ödeme</span>
            </div>
            <div className="feature-chip">
              <NeoIcon symbol="⌖" tone="cyan" size="sm" />
              <span>Yakındaki Lokasyon</span>
            </div>
          </div>
        </article>

        <article className="landing-right card">
          <div className="landing-slider">
            <div className="landing-slider-image-wrap">
              <Image
                key={activeSlide.id}
                src={activeSlide.image}
                alt={activeSlide.title}
                width={900}
                height={520}
                className="landing-slider-image"
                priority
              />
              <div className="landing-slider-overlay" />
            </div>
            <div className="landing-slider-caption">
              <h3>{activeSlide.title}</h3>
              <p>{activeSlide.subtitle}</p>
            </div>
            <div className="landing-dots">
              {slides.map((slide, index) => (
                <button
                  key={slide.id}
                  type="button"
                  className={`dot ${index === active ? 'active' : ''}`}
                  onClick={() => setActive(index)}
                  aria-label={`Slide ${index + 1}`}
                />
              ))}
            </div>
          </div>
        </article>
      </section>
    </main>
  );
}
