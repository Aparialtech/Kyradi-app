'use client';

import Link from 'next/link';
import type { TouchEventHandler } from 'react';
import { useEffect, useMemo, useRef, useState } from 'react';
import { getToken } from '@/lib/auth';
import { NeoIcon } from '@/components/neo-icon';

const heroSlides = [
  {
    id: 1,
    title: 'Bavulunu bırak, şehri keşfet',
    subtitle: 'KYRADI ile konumu seç, bagajını güvenli bırak, QR ile anlık takip et.',
    city: 'İstanbul',
    eta: '11 dk',
    metricA: '420+ nokta',
    metricB: '%99.9 güvenli teslim',
    tone: 'mint',
  },
  {
    id: 2,
    title: 'Seyahatte ekstra yük taşıma',
    subtitle: 'Mobil ve web senkron: rezervasyon, ödeme, cüzdan ve bildirimler tek akışta.',
    city: 'Paris',
    eta: '8 dk',
    metricA: '65K+ rezervasyon',
    metricB: '7/24 canlı destek',
    tone: 'sunset',
  },
  {
    id: 3,
    title: 'Dakikalar içinde rezervasyon',
    subtitle: 'Yakındaki noktayı bul, teslim saatini seç, bilet gibi kartla tüm süreci yönet.',
    city: 'Londra',
    eta: '14 dk',
    metricA: '180+ partner',
    metricB: 'Anlık durum güncelleme',
    tone: 'violet',
  },
];

const serviceCards = [
  {
    title: 'Hızlı Rezervasyon',
    text: '3 adımda rezervasyon aç, lokasyon ve teslim saatini saniyeler içinde belirle.',
    icon: '⚡',
    tone: 'cyan' as const,
  },
  {
    title: 'Canlı Takip ve QR',
    text: 'Bırakma, depolama ve teslim alma adımlarını QR kod ile hatasız tamamla.',
    icon: '◉',
    tone: 'violet' as const,
  },
  {
    title: 'Cüzdan ve Ödeme',
    text: 'TL / EUR / USD desteğiyle cüzdanından öde, hareket geçmişini anında takip et.',
    icon: '₺',
    tone: 'green' as const,
  },
];

const flowSteps = [
  { no: '01', title: 'Nokta Seç', text: 'Haritadan sana en yakın KYRADI noktasını seç.' },
  { no: '02', title: 'Bavulu Bırak', text: 'QR ile teslim işlemini güvenli şekilde tamamla.' },
  { no: '03', title: 'Şehri Keşfet', text: 'Yük taşımadan gez, teslim saatinde geri al.' },
];

const reviews = [
  { name: 'Elif K.', role: 'Sık seyahat eden kullanıcı', text: 'Check-in öncesi valizi bırakıp tüm günü çok rahat geçirdim.' },
  { name: 'Mert A.', role: 'Dijital göçebe', text: 'Web ve mobil aynı veriyi gösteriyor. Akış çok temiz ve hızlı.' },
  { name: 'Naz Y.', role: 'Turist', text: 'QR ve lokasyon akışı net. İlk kullanımda bile kafa karıştırmıyor.' },
];

export default function HomePage() {
  const [activeSlideIndex, setActiveSlideIndex] = useState(0);
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
      setActiveSlideIndex((prev) => (prev + 1) % heroSlides.length);
    }, 4600);
    return () => clearInterval(interval);
  }, []);

  const activeSlide = useMemo(() => heroSlides[activeSlideIndex], [activeSlideIndex]);

  const goNext = () => setActiveSlideIndex((prev) => (prev + 1) % heroSlides.length);
  const goPrev = () => setActiveSlideIndex((prev) => (prev - 1 + heroSlides.length) % heroSlides.length);

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
    if (touchDeltaX.current <= -threshold) goNext();
    if (touchDeltaX.current >= threshold) goPrev();
    touchStartX.current = null;
    touchDeltaX.current = 0;
  };

  return (
    <main className="lp-page">
      <div className="lp-orb lp-orb-a" />
      <div className="lp-orb lp-orb-b" />
      <div className="lp-orb lp-orb-c" />

      <header className="lp-header card">
        <div className="lp-brand">
          <span className="lp-brand-core">K</span>
          <div>
            <p>KYRADI</p>
            <small>Global Bagaj SuperApp</small>
          </div>
        </div>

        <nav className="lp-nav">
          <a href="#ozellikler">Özellikler</a>
          <a href="#nasil">Nasıl Çalışır</a>
          <a href="#yorumlar">Yorumlar</a>
        </nav>

        <div className="lp-actions">
          {hasSession ? (
            <Link href="/dashboard" className="button primary lp-action-btn">Panele Git</Link>
          ) : (
            <>
              <Link href="/login" className="button secondary lp-action-btn">Giriş Yap</Link>
              <Link href="/register" className="button primary lp-action-btn">Kayıt Ol</Link>
            </>
          )}
        </div>
      </header>

      <section className="lp-hero">
        <article className="lp-copy card">
          <span className="lp-chip">Yeni nesil seyahat deneyimi</span>
          <h1>{activeSlide.title}</h1>
          <p>{activeSlide.subtitle}</p>

          <div className="lp-cta-row">
            <Link href={hasSession ? '/dashboard' : '/register'} className="button primary lp-main-btn">
              Hemen Başla
            </Link>
            <a href="#nasil" className="button secondary lp-secondary-btn">Nasıl çalışır?</a>
          </div>

          <div className="lp-store-row">
            <a className="store-btn apple" href={appStoreUrl} target="_blank" rel="noreferrer" aria-label="App Store">
              <span className="store-logo-wrap"><AppleStoreIcon /></span>
              <span><small>Download on the</small><strong>App Store</strong></span>
            </a>
            <a className="store-btn google" href={playStoreUrl} target="_blank" rel="noreferrer" aria-label="Google Play">
              <span className="store-logo-wrap"><PlayStoreIcon /></span>
              <span><small>GET IT ON</small><strong>Google Play</strong></span>
            </a>
          </div>

          <div className="lp-trust-row">
            <div><strong>120K+</strong><span>Kullanıcı</span></div>
            <div><strong>420+</strong><span>Lokasyon</span></div>
            <div><strong>4.9/5</strong><span>Memnuniyet</span></div>
          </div>
        </article>

        <article
          className={`lp-visual card tone-${activeSlide.tone}`}
          onTouchStart={handleTouchStart}
          onTouchMove={handleTouchMove}
          onTouchEnd={handleTouchEnd}
        >
          <div className="lp-progress" key={`prog-${activeSlide.id}`}>
            <span className="lp-progress-fill" />
          </div>

          <div className="lp-scene" key={`scene-${activeSlide.id}`}>
            <div className="lp-desktop">
              <div className="lp-desktop-top">
                <span />
                <span />
                <span />
              </div>
              <div className="lp-ticket card">
                <div>
                  <p>{activeSlide.city} merkez nokta</p>
                  <h4>{activeSlide.eta} uzaklıkta teslim</h4>
                </div>
                <StatusPill text="Müsait" />
              </div>
              <div className="lp-mini-grid">
                <div className="lp-mini-card"><NeoIcon symbol="✦" tone="violet" size="sm" /><strong>{activeSlide.metricA}</strong></div>
                <div className="lp-mini-card"><NeoIcon symbol="⌖" tone="cyan" size="sm" /><strong>{activeSlide.metricB}</strong></div>
              </div>
            </div>

            <div className="lp-phone">
              <div className="lp-phone-notch" />
              <div className="lp-phone-inner">
                <p className="lp-phone-city">{activeSlide.city}</p>
                <div className="lp-phone-row"><span className="lp-dot" />QR ile teslim hazır</div>
                <div className="lp-phone-row"><span className="lp-dot" />Ödeme tamamlandı</div>
                <div className="lp-phone-row"><span className="lp-dot" />Konum eşleşti</div>
              </div>
            </div>

            <div className="lp-float lp-float-a"><NeoIcon symbol="₺" tone="green" size="sm" /><div><small>Cüzdan</small><strong>Hızlı Öde</strong></div></div>
            <div className="lp-float lp-float-b"><NeoIcon symbol="◉" tone="pink" size="sm" /><div><small>Canlı Durum</small><strong>Aktif Rezervasyon</strong></div></div>
          </div>

          <div className="lp-caption" key={`cap-${activeSlide.id}`}>
            <h3>{activeSlide.title}</h3>
            <p>{activeSlide.subtitle}</p>
          </div>

          <div className="lp-dots">
            {heroSlides.map((slide, index) => (
              <button
                key={slide.id}
                type="button"
                className={`dot ${index === activeSlideIndex ? 'active' : ''}`}
                onClick={() => setActiveSlideIndex(index)}
                aria-label={`Slide ${index + 1}`}
              />
            ))}
          </div>
        </article>
      </section>

      <section id="ozellikler" className="lp-section">
        <div className="lp-section-head">
          <p>Özellikler</p>
          <h2>Mobil ve webde aynı güçlü akış</h2>
        </div>
        <div className="lp-service-grid">
          {serviceCards.map((card) => (
            <article key={card.title} className="lp-service-card card">
              <NeoIcon symbol={card.icon} tone={card.tone} size="md" />
              <h3>{card.title}</h3>
              <p>{card.text}</p>
            </article>
          ))}
        </div>
      </section>

      <section id="nasil" className="lp-section lp-how">
        <div className="lp-section-head">
          <p>Nasıl çalışır?</p>
          <h2>3 adımda tamamla</h2>
        </div>
        <div className="lp-flow-grid">
          {flowSteps.map((step) => (
            <article key={step.no} className="lp-step card">
              <span className="lp-step-no">{step.no}</span>
              <h3>{step.title}</h3>
              <p>{step.text}</p>
            </article>
          ))}
        </div>
      </section>

      <section id="yorumlar" className="lp-section">
        <div className="lp-section-head">
          <p>Kullanıcı Yorumları</p>
          <h2>İlk kullanımda anlaşılır, her gün güvenilir</h2>
        </div>
        <div className="lp-review-grid">
          {reviews.map((review) => (
            <article key={review.name} className="lp-review card">
              <p>{review.text}</p>
              <div>
                <strong>{review.name}</strong>
                <small>{review.role}</small>
              </div>
            </article>
          ))}
        </div>
      </section>

      <section className="lp-bottom-cta card">
        <div>
          <p>KYRADI SuperApp</p>
          <h2>Bavulunu bırak, şehri keşfet.</h2>
        </div>
        <div className="lp-cta-row">
          <Link href={hasSession ? '/dashboard' : '/register'} className="button primary">Hemen Başla</Link>
          <Link href="/login" className="button secondary">Giriş Yap</Link>
        </div>
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
