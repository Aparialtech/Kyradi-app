'use client';

import Link from 'next/link';
import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/app-shell';
import { ProtectedPage } from '@/components/protected-page';
import { createLuggage, estimatePricing, fetchLocations, fetchMe } from '@/lib/api';
import { getUserId, setUserId } from '@/lib/auth';
import type { LocationItem, PaymentMethod } from '@/lib/types';

type SizeClass = 'small' | 'medium' | 'large';

function toLocalInputDateTime(value: Date): string {
  const offset = value.getTimezoneOffset();
  const local = new Date(value.getTime() - offset * 60000);
  return local.toISOString().slice(0, 16);
}

export default function CreateLuggagePage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [estimating, setEstimating] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);

  const [userId, setCurrentUserId] = useState<string | null>(getUserId());
  const [locations, setLocations] = useState<LocationItem[]>([]);
  const [locationId, setLocationId] = useState('');
  const [label, setLabel] = useState('');
  const [size, setSize] = useState<SizeClass>('medium');
  const [color, setColor] = useState('Siyah');
  const [note, setNote] = useState('');
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod>('wallet');
  const [dropAt, setDropAt] = useState(() => toLocalInputDateTime(new Date(Date.now() + 30 * 60 * 1000)));
  const [pickupAt, setPickupAt] = useState(() => toLocalInputDateTime(new Date(Date.now() + 24 * 60 * 60 * 1000)));
  const [estimatedTotal, setEstimatedTotal] = useState<number | null>(null);

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      setError(null);
      try {
        const me = await fetchMe();
        const resolvedUserId = me._id || me.id || userId;
        if (!resolvedUserId) throw new Error('USER_ID_MISSING');
        setCurrentUserId(resolvedUserId);
        setUserId(resolvedUserId);
        const locationList = await fetchLocations();
        setLocations(locationList);
        if (locationList.length > 0) {
          const firstId = (locationList[0]._id || locationList[0].id || '').toString();
          setLocationId(firstId);
        }
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Sayfa yüklenemedi');
      } finally {
        setLoading(false);
      }
    };

    void load();
  }, [userId]);

  const selectedLocation = useMemo(() => {
    return locations.find((item) => (item._id || item.id || '').toString() === locationId);
  }, [locations, locationId]);

  const canSubmit = Boolean(userId && selectedLocation && dropAt && pickupAt);

  const onEstimate = async () => {
    if (!dropAt || !pickupAt) return;
    setEstimating(true);
    setError(null);
    setMessage(null);
    try {
      const result = await estimatePricing({
        sizeClass: size,
        dropAt: new Date(dropAt).toISOString(),
        pickupAt: new Date(pickupAt).toISOString(),
        paymentMethod,
        protectionLevel: 'standard',
      });
      const total =
        result && typeof result === 'object' && typeof (result as Record<string, unknown>).total === 'number'
          ? Number((result as Record<string, unknown>).total)
          : 0;
      setEstimatedTotal(total);
      setMessage(`Tahmini toplam: ${total.toFixed(2)} ₺`);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Fiyat hesaplanamadı');
    } finally {
      setEstimating(false);
    }
  };

  const onCreate = async () => {
    if (!canSubmit || !selectedLocation || !userId) return;
    setSaving(true);
    setError(null);
    setMessage(null);
    try {
      const created = await createLuggage(userId, {
        label: label.trim() || undefined,
        size,
        color,
        note: note.trim() || undefined,
        paymentMethod,
        totalPrice: estimatedTotal ?? undefined,
        dropLocationId: (selectedLocation._id || selectedLocation.id || '').toString(),
        dropLocationName: selectedLocation.name || 'KYRADI',
        scheduledDropTime: new Date(dropAt).toISOString(),
        scheduledPickupTime: new Date(pickupAt).toISOString(),
      });
      setMessage(`Rezervasyon oluşturuldu: ${created.label || created.qrCode || 'yeni kayıt'}`);
      router.replace('/luggages');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Rezervasyon oluşturulamadı');
    } finally {
      setSaving(false);
    }
  };

  return (
    <ProtectedPage>
      <AppShell title="Yeni Bavul" subtitle="Mobildeki bavul oluşturma akışının web karşılığı">
        <div className="card" style={{ padding: 16, maxWidth: 860 }}>
          <div style={{ marginBottom: 12 }}>
            <Link href="/luggages" style={{ color: 'var(--primary)', fontWeight: 700 }}>
              ← Bavul listesine dön
            </Link>
          </div>
          {loading ? <p>Yükleniyor...</p> : null}
          {error ? <p style={{ color: 'var(--danger)' }}>Hata: {error}</p> : null}
          {message ? <p style={{ color: 'var(--primary)' }}>{message}</p> : null}

          {!loading ? (
            <div className="grid" style={{ gap: 14 }}>
              <div className="grid cols-2">
                <div className="form-row">
                  <label>Lokasyon</label>
                  <select className="input" value={locationId} onChange={(e) => setLocationId(e.target.value)}>
                    {locations.map((location) => {
                      const id = (location._id || location.id || '').toString();
                      return (
                        <option key={id} value={id}>
                          {location.name || id}
                        </option>
                      );
                    })}
                  </select>
                </div>
                <div className="form-row">
                  <label>Ödeme Yöntemi</label>
                  <select
                    className="input"
                    value={paymentMethod}
                    onChange={(e) => setPaymentMethod(e.target.value as PaymentMethod)}
                  >
                    <option value="wallet">Kyradi Cüzdan</option>
                    <option value="card">Kart</option>
                    <option value="installment">Taksit</option>
                    <option value="pay_at_hotel">Otelde Öde</option>
                    <option value="transfer">Havale/EFT</option>
                  </select>
                </div>
              </div>

              <div className="grid cols-2">
                <div className="form-row">
                  <label>Etiket</label>
                  <input
                    className="input"
                    value={label}
                    onChange={(e) => setLabel(e.target.value)}
                    placeholder="Örn: Kabin bagaj"
                  />
                </div>
                <div className="form-row">
                  <label>Boyut</label>
                  <select className="input" value={size} onChange={(e) => setSize(e.target.value as SizeClass)}>
                    <option value="small">Küçük</option>
                    <option value="medium">Orta</option>
                    <option value="large">Büyük</option>
                  </select>
                </div>
              </div>

              <div className="grid cols-2">
                <div className="form-row">
                  <label>Renk</label>
                  <input className="input" value={color} onChange={(e) => setColor(e.target.value)} />
                </div>
                <div className="form-row">
                  <label>Not</label>
                  <input className="input" value={note} onChange={(e) => setNote(e.target.value)} />
                </div>
              </div>

              <div className="grid cols-2">
                <div className="form-row">
                  <label>Bırakma Zamanı</label>
                  <input
                    className="input"
                    type="datetime-local"
                    value={dropAt}
                    onChange={(e) => setDropAt(e.target.value)}
                  />
                </div>
                <div className="form-row">
                  <label>Alış Zamanı</label>
                  <input
                    className="input"
                    type="datetime-local"
                    value={pickupAt}
                    onChange={(e) => setPickupAt(e.target.value)}
                  />
                </div>
              </div>

              <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
                <button className="button secondary" type="button" onClick={() => void onEstimate()} disabled={estimating}>
                  {estimating ? 'Hesaplanıyor...' : 'Fiyat Hesapla'}
                </button>
                <button className="button primary" type="button" onClick={() => void onCreate()} disabled={saving || !canSubmit}>
                  {saving ? 'Kaydediliyor...' : 'Rezervasyonu Oluştur'}
                </button>
                {estimatedTotal !== null ? (
                  <div className="badge ok" style={{ alignSelf: 'center' }}>
                    Tahmini Tutar: {estimatedTotal.toFixed(2)} ₺
                  </div>
                ) : null}
              </div>
            </div>
          ) : null}
        </div>
      </AppShell>
    </ProtectedPage>
  );
}
