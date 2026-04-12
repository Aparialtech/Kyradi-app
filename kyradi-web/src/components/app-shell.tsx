'use client';

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { clearSession } from '@/lib/auth';
import { getApiBaseUrl } from '@/lib/api';
import { NeoIcon } from '@/components/neo-icon';
import type { PropsWithChildren } from 'react';

type AppShellProps = PropsWithChildren<{
  title: string;
  subtitle?: string;
}>;

const navItems = [
  { href: '/dashboard', label: 'Ana Sayfa', symbol: '⌂', tone: 'cyan' as const },
  { href: '/luggages', label: 'Bavullar', symbol: '◈', tone: 'violet' as const },
  { href: '/wallet', label: 'Cüzdan', symbol: '₺', tone: 'green' as const },
  { href: '/locations', label: 'Lokasyonlar', symbol: '⌖', tone: 'pink' as const },
  { href: '/profile', label: 'Profil', symbol: '◉', tone: 'amber' as const },
];

export function AppShell({ title, subtitle, children }: AppShellProps) {
  const pathname = usePathname();
  const router = useRouter();

  const isActive = (href: string) => {
    if (href === '/dashboard') return pathname === '/dashboard';
    return pathname === href || pathname.startsWith(`${href}/`);
  };

  return (
    <div className="app-bg">
      <div className="app-shell">
        <header className="consumer-topbar card">
          <div className="brand-group">
            <span className="brand-orb" />
            <div>
              <p className="brand-name">KYRADI</p>
              <p className="brand-sub">Seyahat ve Bavul Asistanı</p>
            </div>
          </div>
          <div className="top-actions">
            <button
              className="button secondary"
              type="button"
              onClick={() => {
                clearSession();
                router.replace('/login');
              }}
            >
              Çıkış
            </button>
          </div>
        </header>

        <nav className="consumer-nav card">
          {navItems.map((item) => (
            <Link key={item.href} href={item.href} className={`nav-pill ${isActive(item.href) ? 'active' : ''}`}>
              <NeoIcon symbol={item.symbol} tone={item.tone} size="sm" />
              <span>{item.label}</span>
            </Link>
          ))}
        </nav>

        <section className="consumer-header card">
          <span className="hero-glow hero-glow-a" />
          <span className="hero-glow hero-glow-b" />
          <span className="hero-glow hero-glow-c" />
          <div>
            <h1>{title}</h1>
            {subtitle ? <p>{subtitle}</p> : null}
          </div>
          <div className="hero-right">
            <NeoIcon symbol="✦" tone="pink" size="md" />
            <p className="hero-note">Hızlı, güvenli, modern</p>
          </div>
        </section>

        <main>{children}</main>
        <p className="api-tag">API: {getApiBaseUrl()}</p>
      </div>
    </div>
  );
}
