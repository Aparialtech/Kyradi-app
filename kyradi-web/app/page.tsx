'use client';

import Link from 'next/link';
import type { TouchEventHandler } from 'react';
import { useEffect, useMemo, useRef, useState } from 'react';
import { getToken } from '@/lib/auth';
import { NeoIcon } from '@/components/neo-icon';

const slides = [
  {
    id: 1,
    tone: 'mint',
    title: 'Bavulunu bırak, şehri keşfet',
    subtitle: 'KYRADI ile güvenli depolama, hızlı teslim ve canlı takip tek ekranda.',
    city: 'İstanbul',
    eta: '11 dk',
    metricA: '420+ Nokta',
    metricB: '%99.9 Güvenli',
  },
  {
    id: 2,
    tone: 'sunset',
    title: 'Tek uygulama, tam kontrol',
    subtitle: 'Rezervasyon, cüzdan, QR ve lokasyon yönetimi mobil ile birebir senkron.',
    city: 'Paris',
    eta: '8 dk',
    metricA: '65K+ İşlem',
    metricB: 'Anlık Takip',
  },
  {
    id: 3,
    tone: 'violet',
    title: 'Seyahatte ekstra yük yok',
    subtitle: 'Terminale gitmeden önce bagajını bırak, günün keyfini çıkar.',
    city: 'Londra',
    eta: '14 dk',
    metricA: '24/7 Destek',
    metricB: '7/24 Açık Noktalar',
  },
];

export default function HomePage() {
  const [active, setActive] = useState(0);
  const [hasSession, setHasSession] = useState(false);
  const touchStartX = useRef<number | null>(null);
  const touchDeltaX = useRef(0);

  const appStoreUrl = process.env.NEXT_PUBLIC_APP_STORE_URL ?? 'https://www.apple.com/app-store/';
  const playStoreUrl = process.env.NEXT_PUBLIC_PLAY_STORE_URL ?? 'https://play.google.com/store/apps';

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
  const goNext = () => setActive((prev) => (prev + 1) % slides.length);
  const goPrev = () => setActive((prev) => (prev - 1 + slides.length) % slides.length);

  const handleTouchStart: TouchEventHandler<HTMLDivElement> = (event) => {
    touchStartX.current = event.changedTouches[0]?.clientX ?? null;
    touchDeltaX.current = 0;
  };

  const handleTouchMove: TouchEventHandler<HTMLDivElement> = (event) => {
    if (touchStartX.current === null) return;
    const currentX = event.changedTouches[0]?.clientX ?? touchStartX.current;
    touchDeltaX.current = currentX - touchStartX.current;
  };

  const handleTouchEnd: TouchEventHandler<HTMLDivElement> = () => {
    const threshold = 44;
    if (touchDeltaX.current <= -threshold) {
      goNext();
    } else if (touchDeltaX.current >= threshold) {
      goPrev();
    }
    touchStartX.current = null;
    touchDeltaX.current = 0;
  };

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
            <Link href="/dashboard" className="button primary landing-top-btn">Panele Git</Link>
          ) : (
            <>
              <Link href="/login" className="button secondary landing-top-btn">Giriş Yap</Link>
              <Link href="/register" className="button primary landing-top-btn">Kayıt Ol</Link>
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
            <a className="store-btn apple" href={appStoreUrl} target="_blank" rel="noreferrer" aria-label="App Store">
              <span className="store-logo-wrap">
                <AppleStoreIcon />
              </span>
              <span>
                <small>Download on the</small>
                <strong>App Store</strong>
              </span>
            </a>
            <a className="store-btn google" href={playStoreUrl} target="_blank" rel="noreferrer" aria-label="Google Play">
              <span className="store-logo-wrap">
                <PlayStoreIcon />
              </span>
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
          <div
            className={`landing-slider tone-${activeSlide.tone}`}
            onTouchStart={handleTouchStart}
            onTouchMove={handleTouchMove}
            onTouchEnd={handleTouchEnd}
          >
            <div className="landing-progress" key={`progress-${activeSlide.id}`}>
              <span className="landing-progress-fill" />
            </div>

            <div className="landing-scene" key={`scene-${activeSlide.id}`}>
              <div className="desktop-frame">
                <div className="desktop-head">
                  <span className="desktop-dot" />
                  <span className="desktop-dot" />
                  <span className="desktop-dot" />
                </div>
                <div className="desktop-body">
                  <div className="hero-ticket card">
                    <div>
                      <p>{activeSlide.city} • Merkez Nokta</p>
                      <h4>{activeSlide.eta} uzaklıkta teslim</h4>
                    </div>
                    <StatusPill text="Müsait" />
                  </div>
                  <div className="hero-metrics">
                    <div className="hero-mini-card">
                      <NeoIcon symbol="◈" tone="violet" size="sm" />
                      <strong>{activeSlide.metricA}</strong>
                    </div>
                    <div className="hero-mini-card">
                      <NeoIcon symbol="⌖" tone="cyan" size="sm" />
                      <strong>{activeSlide.metricB}</strong>
                    </div>
                  </div>
                </div>
              </div>

              <div className="phone-mock">
                <div className="phone-notch" />
                <div className="phone-inner">
                  <div className="phone-balance">{activeSlide.city}</div>
                  <div className="phone-row">
                    <span className="pulse-dot" />
                    <span>QR ile teslim hazır</span>
                  </div>
                  <div className="phone-row">
                    <span className="pulse-dot" />
                    <span>Ödeme tamamlandı</span>
                  </div>
                  <div className="phone-row">
                    <span className="pulse-dot" />
                    <span>Konum doğrulandı</span>
                  </div>
                </div>
              </div>

              <div className="floating-card floating-a">
                <NeoIcon symbol="₺" tone="green" size="sm" />
                <div>
                  <small>Cüzdan</small>
                  <strong>Hızlı Öde</strong>
                </div>
              </div>

              <div className="floating-card floating-b">
                <NeoIcon symbol="✦" tone="pink" size="sm" />
                <div>
                  <small>Canlı Durum</small>
                  <strong>Aktif Rezervasyon</strong>
                </div>
              </div>
            </div>

            <div className="landing-slider-caption" key={`caption-${activeSlide.id}`}>
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

function StatusPill({ text }: { text: string }) {
  return <span className="status-pill">{text}</span>;
}

function AppleStoreIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true" className="store-icon">
      <path
        d="M15.3 4.1c-.9.1-1.9.7-2.6 1.5-.7.8-1.3 1.9-1.1 3 .9.1 1.9-.4 2.7-1.2.8-.8 1.3-1.9 1-3.3z"
        fill="currentColor"
      />
      <path
        d="M19.9 14.8c-.5 1.2-.8 1.8-1.4 2.8-.9 1.4-2.1 3.1-3.7 3.1-1.4 0-1.8-.9-3.5-.9s-2.1.9-3.5.9c-1.6 0-2.7-1.5-3.6-2.9-2.5-3.8-2.8-8.1-1.2-10.6 1.1-1.8 2.8-2.9 4.4-2.9 1.7 0 2.8.9 4.2.9 1.4 0 2.2-.9 4.2-.9 1.4 0 2.8.8 3.8 2.2-3.3 1.8-2.7 6.5.3 8.3z"
        fill="currentColor"
      />
    </svg>
  );
}

function PlayStoreIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true" className="store-icon">
      <path d="M3.4 2.8l10.6 9.3L3.4 22V2.8z" fill="#31C5F4" />
      <path d="M14 12.1l2.9-2.6 3.8 2.1-3.8 2.1-2.9-1.6z" fill="#FFD54F" />
      <path d="M3.4 2.8l12.8 7.1-2.2 2.2L3.4 2.8z" fill="#66BB6A" />
      <path d="M3.4 22l10.6-9.9 2.2 2.2L3.4 22z" fill="#EF5350" />
    </svg>
  );
}
