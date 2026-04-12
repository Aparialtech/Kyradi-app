'use client';

import Link from 'next/link';
import { useEffect, useMemo, useState } from 'react';
import { AppShell } from '@/components/app-shell';
import { ProtectedPage } from '@/components/protected-page';
import { fetchLuggages, fetchLocations, fetchMe, fetchWallet } from '@/lib/api';
import { getUserId, setUserId } from '@/lib/auth';
import type { ApiUser, LuggageItem, LocationItem } from '@/lib/types';
import { StatusBadge } from '@/components/status-badge';
import { NeoIcon } from '@/components/neo-icon';

type DashboardData = {
  user: ApiUser | null;
  luggages: LuggageItem[];
  locations: LocationItem[];
  walletBalance: number;
};

const quickActions = [
  { href: '/luggages/create', title: 'Bavul Ekle', subtitle: 'Yeni rezervasyon oluştur', symbol: '✚', tone: 'cyan' as const },
  { href: '/luggages', title: 'QR & Bavullar', subtitle: 'Aktif bavullarını yönet', symbol: '◈', tone: 'violet' as const },
  { href: '/wallet', title: 'Cüzdan', subtitle: 'Bakiye yükle ve öde', symbol: '₺', tone: 'green' as const },
  { href: '/locations', title: 'Lokasyon Ara', subtitle: 'En uygun noktayı seç', symbol: '⌖', tone: 'pink' as const },
  { href: '/profile', title: 'Profil', subtitle: 'Bilgilerini güncelle', symbol: '◉', tone: 'amber' as const },
];

function currency(amount: number) {
  return new Intl.NumberFormat('tr-TR', { style: 'currency', currency: 'TRY' }).format(amount);
}

export default function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [data, setData] = useState<DashboardData>({
    user: null,
    luggages: [],
    locations: [],
    walletBalance: 0,
  });

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      setError(null);
      try {
        const me = await fetchMe();
        const userId = me._id || me.id || getUserId();
        if (!userId) {
          throw new Error('USER_ID_MISSING');
        }
        setUserId(userId);

        const [luggages, locations, wallet] = await Promise.all([
          fetchLuggages(userId),
          fetchLocations(),
          fetchWallet(),
        ]);

        setData({
          user: me,
          luggages,
          locations,
          walletBalance: wallet.balance ?? 0,
        });
      } catch (err) {
        const message = err instanceof Error ? err.message : 'Dashboard yüklenemedi';
        setError(message);
      } finally {
        setLoading(false);
      }
    };

    void load();
  }, []);

  const activeLuggage = data.luggages.find((item) => {
    const status = (item.status ?? '').toLowerCase();
    return status === 'awaiting_drop' || status === 'dropped';
  });

  const stats = useMemo(() => {
    const total = data.luggages.length;
    const active = data.luggages.filter((item) => ['awaiting_drop', 'dropped'].includes((item.status || '').toLowerCase())).length;
    const unpaid = data.luggages.filter((item) => (item.paymentStatus || '').toLowerCase() !== 'paid').length;
    return { total, active, unpaid };
  }, [data.luggages]);

  return (
    <ProtectedPage>
      <AppShell title="Merhaba" subtitle="Web'de de aynı mobil akışla devam et">
        {loading ? <div className="card" style={{ padding: 16 }}>Yükleniyor...</div> : null}

        {error ? (
          <div className="card" style={{ padding: 16, color: 'var(--danger)' }}>
            Hata: {error}
          </div>
        ) : null}

        {!loading && !error ? (
          <div className="grid" style={{ gap: 18 }}>
            <div className="card" style={{ padding: 18 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 10, flexWrap: 'wrap', alignItems: 'center' }}>
                <div>
                  <h2 style={{ margin: 0, fontSize: 28, letterSpacing: '-0.03em' }}>
                    {`${data.user?.name ?? ''} ${data.user?.surname ?? ''}`.trim() || 'Kullanıcı'}
                  </h2>
                  <p style={{ margin: '6px 0 0', color: 'var(--muted)' }}>
                    {data.user?.email || '-'}
                  </p>
                </div>
                <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                  <StatusBadge value={data.user?.identityVerified ? 'verified' : 'pending'}>
                    {data.user?.identityVerified ? 'Kimlik Onaylı' : 'Kimlik Bekliyor'}
                  </StatusBadge>
                  <StatusBadge value={data.user?.verified ? 'verified' : 'pending'}>
                    {data.user?.verified ? 'E-posta Onaylı' : 'E-posta Bekliyor'}
                  </StatusBadge>
                </div>
              </div>
              <div className="grid cols-3" style={{ marginTop: 14 }}>
                <div className="card metric">
                  <h4>Cüzdan Bakiyesi</h4>
                  <p>{currency(data.walletBalance)}</p>
                </div>
                <div className="card metric">
                  <h4>Aktif Bavul</h4>
                  <p>{stats.active}</p>
                </div>
                <div className="card metric">
                  <h4>Ödenmemiş</h4>
                  <p>{stats.unpaid}</p>
                </div>
              </div>
            </div>

            <div className="grid cols-3">
              {quickActions.map((action) => (
                <Link key={action.href} href={action.href} className="card" style={{ padding: 16 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <NeoIcon symbol={action.symbol} tone={action.tone} size="md" />
                    <div>
                      <h3 style={{ margin: 0, fontSize: 18 }}>{action.title}</h3>
                      <p style={{ margin: '4px 0 0', color: 'var(--muted)', fontSize: 13 }}>{action.subtitle}</p>
                    </div>
                  </div>
                </Link>
              ))}
            </div>

            <div className="card" style={{ padding: 16 }}>
              <h3 style={{ marginTop: 0 }}>Aktif rezervasyon bileti</h3>
              {activeLuggage ? (
                <div className="grid cols-2">
                  <div>
                    <p><strong>Etiket:</strong> {activeLuggage.label || '-'}</p>
                    <p><strong>Lokasyon:</strong> {activeLuggage.dropLocationName || '-'}</p>
                    <p><strong>QR:</strong> {activeLuggage.qrCode || '-'}</p>
                    <p><strong>Ücret:</strong> {currency(Number(activeLuggage.totalPrice ?? 0))}</p>
                  </div>
                  <div>
                    <p><strong>Durum:</strong> <StatusBadge value={activeLuggage.status} /></p>
                    <p><strong>Ödeme:</strong> <StatusBadge value={activeLuggage.paymentStatus} /></p>
                    <p><strong>Bırakma:</strong> {activeLuggage.scheduledDropTime ? new Date(activeLuggage.scheduledDropTime).toLocaleString('tr-TR') : '-'}</p>
                    <p><strong>Alış:</strong> {activeLuggage.scheduledPickupTime ? new Date(activeLuggage.scheduledPickupTime).toLocaleString('tr-TR') : '-'}</p>
                    <div style={{ marginTop: 8 }}>
                      <Link href="/luggages" className="button primary">Rezervasyonu Aç</Link>
                    </div>
                  </div>
                </div>
              ) : (
                <p>Aktif rezervasyon bulunmuyor. Yeni bavul ekleyebilirsin.</p>
              )}
            </div>

            <div className="card" style={{ padding: 16 }}>
              <h3 style={{ marginTop: 0 }}>Lokasyon Özeti</h3>
              <div className="grid cols-3">
                <div className="metric card">
                  <h4>Toplam Lokasyon</h4>
                  <p>{data.locations.length}</p>
                </div>
                <div className="metric card">
                  <h4>Müsait Slot</h4>
                  <p>{data.locations.reduce((sum, item) => sum + Number(item.availableSlots || 0), 0)}</p>
                </div>
                <div className="metric card">
                  <h4>Toplam Bavul</h4>
                  <p>{stats.total}</p>
                </div>
              </div>
            </div>
          </div>
        ) : null}
      </AppShell>
    </ProtectedPage>
  );
}
