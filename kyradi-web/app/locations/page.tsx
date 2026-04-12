'use client';

import { useEffect, useMemo, useState } from 'react';
import { AppShell } from '@/components/app-shell';
import { ProtectedPage } from '@/components/protected-page';
import { fetchLocations } from '@/lib/api';
import type { LocationItem } from '@/lib/types';
import { StatusBadge } from '@/components/status-badge';
import { NeoIcon } from '@/components/neo-icon';

function mapLink(item: LocationItem): string | null {
  if (typeof item.latitude === 'number' && typeof item.longitude === 'number') {
    return `https://www.google.com/maps?q=${item.latitude},${item.longitude}`;
  }
  if (item.address && item.address.trim()) {
    return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(item.address)}`;
  }
  return null;
}

export default function LocationsPage() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [locations, setLocations] = useState<LocationItem[]>([]);

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await fetchLocations();
      setLocations(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Lokasyonlar alınamadı');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void load();
  }, []);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return locations;
    return locations.filter((item) => {
      const name = (item.name || '').toLowerCase();
      const address = (item.address || '').toLowerCase();
      return name.includes(q) || address.includes(q);
    });
  }, [locations, search]);

  const totals = useMemo(() => {
    const totalSlots = locations.reduce((sum, item) => sum + Number(item.totalSlots || 0), 0);
    const availableSlots = locations.reduce((sum, item) => sum + Number(item.availableSlots || 0), 0);
    const activeCount = locations.filter((item) => item.isActive !== false).length;
    return { totalSlots, availableSlots, activeCount };
  }, [locations]);

  return (
    <ProtectedPage>
      <AppShell title="Lokasyonlar" subtitle="Harita noktalarını ve kapasite durumunu takip et">
        <div className="grid" style={{ gap: 16 }}>
          <div className="grid cols-3">
            <div className="card metric">
              <h4>Aktif Lokasyon</h4>
              <p>{totals.activeCount}</p>
            </div>
            <div className="card metric">
              <h4>Toplam Slot</h4>
              <p>{totals.totalSlots}</p>
            </div>
            <div className="card metric">
              <h4>Müsait Slot</h4>
              <p>{totals.availableSlots}</p>
            </div>
          </div>

          <div className="card" style={{ padding: 16, display: 'flex', gap: 10, justifyContent: 'space-between', flexWrap: 'wrap' }}>
            <input
              className="input"
              style={{ width: 'min(460px, 100%)' }}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Lokasyon veya adres ara"
            />
            <button className="button secondary" type="button" onClick={() => void load()} disabled={loading}>
              Yenile
            </button>
          </div>

          {loading ? <div className="card" style={{ padding: 16 }}>Yükleniyor...</div> : null}
          {error ? <div className="card" style={{ padding: 16, color: 'var(--danger)' }}>Hata: {error}</div> : null}

          {!loading && !error && filtered.length === 0 ? (
            <div className="card" style={{ padding: 16 }}>Lokasyon bulunamadı.</div>
          ) : null}

          {!loading && !error && filtered.length > 0 ? (
            <div className="grid cols-2">
              {filtered.map((item) => {
                const available = Number(item.availableSlots ?? 0);
                const total = Number(item.totalSlots ?? 0);
                const occupied = Math.max(total - available, 0);
                const fillRate = total > 0 ? Math.round((occupied / total) * 100) : 0;
                const link = mapLink(item);
                return (
                  <article key={item._id || item.id || item.name} className="card" style={{ padding: 16 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, alignItems: 'start' }}>
                      <div>
                        <h3 style={{ margin: 0 }}>{item.name || '-'}</h3>
                        <p style={{ margin: '6px 0 0', color: 'var(--muted)' }}>{item.address || '-'}</p>
                      </div>
                      <NeoIcon symbol="⌖" tone="pink" size="sm" />
                    </div>

                    <div style={{ marginTop: 12, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                      <StatusBadge value={item.isActive ? 'active' : 'inactive'}>
                        {item.isActive ? 'Aktif' : 'Pasif'}
                      </StatusBadge>
                      <StatusBadge value="slots">{available}/{total} Slot</StatusBadge>
                      <StatusBadge value="fill">Doluluk %{fillRate}</StatusBadge>
                    </div>

                    <div style={{ marginTop: 12, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                      {link ? (
                        <a href={link} target="_blank" rel="noreferrer" className="button secondary">
                          Haritada Aç
                        </a>
                      ) : null}
                    </div>
                  </article>
                );
              })}
            </div>
          ) : null}
        </div>
      </AppShell>
    </ProtectedPage>
  );
}
