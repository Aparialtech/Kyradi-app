'use client';

import Link from 'next/link';
import { useEffect, useMemo, useState } from 'react';
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
          <div className={`landing-slider tone-${activeSlide.tone}`}>
            <div className="landing-scene">
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

function StatusPill({ text }: { text: string }) {
  return <span className="status-pill">{text}</span>;
}
