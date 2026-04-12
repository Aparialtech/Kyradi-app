'use client';

import Link from 'next/link';
import { useParams, useRouter } from 'next/navigation';
import { FormEvent, useEffect, useMemo, useState } from 'react';
import { AppShell } from '@/components/app-shell';
import { ProtectedPage } from '@/components/protected-page';
import {
  confirmLuggageMetadataChange,
  fetchLocations,
  fetchLuggages,
  fetchMe,
  requestLuggageMetadataChange,
} from '@/lib/api';
import { getUserId, setUserId } from '@/lib/auth';
import type { LocationItem, LuggageItem } from '@/lib/types';
import { StatusBadge } from '@/components/status-badge';

function toLocalInputDateTime(value?: string): string {
  if (!value) return '';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '';
  const offset = date.getTimezoneOffset();
  const local = new Date(date.getTime() - offset * 60000);
  return local.toISOString().slice(0, 16);
}

function luggageId(item: LuggageItem): string {
  return item._id || item.id || '';
}

export default function EditLuggagePage() {
  const router = useRouter();
  const params = useParams<{ id: string }>();
  const luggageIdParam = params?.id?.toString() ?? '';
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const [confirming, setConfirming] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [debugCode, setDebugCode] = useState<string | null>(null);

  const [userId, setCurrentUserId] = useState<string | null>(getUserId());
  const [currentItem, setCurrentItem] = useState<LuggageItem | null>(null);
  const [locations, setLocations] = useState<LocationItem[]>([]);

  const [label, setLabel] = useState('');
  const [size, setSize] = useState('');
  const [color, setColor] = useState('');
  const [note, setNote] = useState('');
  const [dropLocationId, setDropLocationId] = useState('');
  const [dropLocationName, setDropLocationName] = useState('');
  const [dropAt, setDropAt] = useState('');
  const [pickupAt, setPickupAt] = useState('');
  const [code, setCode] = useState('');

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

        const [luggageList, locationsList] = await Promise.all([
          fetchLuggages(resolvedUserId),
          fetchLocations(),
        ]);

        const selected = luggageList.find((item) => luggageId(item) === luggageIdParam);
        if (!selected) {
          throw new Error('RESERVATION_NOT_FOUND');
        }
        setCurrentItem(selected);
        setLocations(locationsList);

        setLabel(selected.label || '');
        setSize(selected.size || '');
        setColor(selected.color || '');
        setNote(selected.note || '');
        setDropLocationId(selected.dropLocationId || '');
        setDropLocationName(selected.dropLocationName || '');
        setDropAt(toLocalInputDateTime(selected.scheduledDropTime));
        setPickupAt(toLocalInputDateTime(selected.scheduledPickupTime));
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Rezervasyon yüklenemedi');
      } finally {
        setLoading(false);
      }
    };

    void load();
  }, [luggageIdParam, userId]);

  const selectedLocation = useMemo(
    () => locations.find((item) => (item._id || item.id || '').toString() === dropLocationId),
    [locations, dropLocationId],
  );

  const onRequestCode = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!userId || !luggageIdParam) return;
    setSending(true);
    setError(null);
    setMessage(null);
    setDebugCode(null);
    try {
      const result = await requestLuggageMetadataChange(userId, luggageIdParam, {
        label: label.trim() || undefined,
        size: size.trim() || undefined,
        color: color.trim() || undefined,
        note: note.trim() || undefined,
        dropLocationId: selectedLocation ? (selectedLocation._id || selectedLocation.id || '').toString() : dropLocationId,
        dropLocationName: selectedLocation?.name || dropLocationName,
        scheduledDropTime: dropAt ? new Date(dropAt).toISOString() : undefined,
        scheduledPickupTime: pickupAt ? new Date(pickupAt).toISOString() : undefined,
      });
      const codeHint =
        result && typeof result === 'object' && typeof (result as Record<string, unknown>).code === 'string'
          ? ((result as Record<string, unknown>).code as string)
          : null;
      setDebugCode(codeHint);
      setMessage('Doğrulama kodu e-posta adresine gönderildi.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Kod gönderilemedi');
    } finally {
      setSending(false);
    }
  };

  const onConfirm = async () => {
    if (!userId || !luggageIdParam || !code.trim()) return;
    setConfirming(true);
    setError(null);
    setMessage(null);
    try {
      await confirmLuggageMetadataChange(userId, luggageIdParam, code.trim());
      setMessage('Rezervasyon değişikliği onaylandı.');
      setTimeout(() => {
        router.replace('/luggages');
      }, 800);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Kod doğrulaması başarısız');
    } finally {
      setConfirming(false);
    }
  };

  return (
    <ProtectedPage>
      <AppShell title="Rezervasyon Düzenle" subtitle="Değişiklikler OTP ile onaylanır">
        <div className="card" style={{ padding: 16, maxWidth: 900 }}>
          <div style={{ marginBottom: 12 }}>
            <Link href="/luggages" style={{ color: 'var(--primary)', fontWeight: 700 }}>
              ← Bavul listesine dön
            </Link>
          </div>

          {loading ? <p>Yükleniyor...</p> : null}
          {error ? <p style={{ color: 'var(--danger)' }}>Hata: {error}</p> : null}
          {message ? <p style={{ color: 'var(--primary)' }}>{message}</p> : null}

          {!loading && currentItem ? (
            <>
              <div style={{ marginBottom: 12, display: 'flex', gap: 10, flexWrap: 'wrap' }}>
                <StatusBadge value={currentItem.status} />
                <StatusBadge value={currentItem.paymentStatus} />
                <span style={{ color: 'var(--muted)' }}>QR: {currentItem.qrCode || '-'}</span>
              </div>

              <form onSubmit={onRequestCode}>
                <div className="grid cols-2">
                  <div className="form-row">
                    <label>Etiket</label>
                    <input className="input" value={label} onChange={(e) => setLabel(e.target.value)} />
                  </div>
                  <div className="form-row">
                    <label>Boyut</label>
                    <input className="input" value={size} onChange={(e) => setSize(e.target.value)} />
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
                    <label>Lokasyon</label>
                    <select
                      className="input"
                      value={dropLocationId}
                      onChange={(e) => {
                        setDropLocationId(e.target.value);
                        const location = locations.find((item) => (item._id || item.id || '').toString() === e.target.value);
                        if (location?.name) setDropLocationName(location.name);
                      }}
                    >
                      <option value="">Seçiniz</option>
                      {locations.map((item) => {
                        const id = (item._id || item.id || '').toString();
                        return (
                          <option key={id} value={id}>
                            {item.name || id}
                          </option>
                        );
                      })}
                    </select>
                  </div>
                  <div className="form-row">
                    <label>Lokasyon Adı</label>
                    <input className="input" value={dropLocationName} onChange={(e) => setDropLocationName(e.target.value)} />
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

                <button className="button primary" type="submit" disabled={sending}>
                  {sending ? 'Kod gönderiliyor...' : 'Doğrulama Kodu Gönder'}
                </button>
              </form>

              <div className="card" style={{ padding: 14, marginTop: 14, background: 'var(--surface-soft)' }}>
                <div className="form-row" style={{ marginBottom: 10 }}>
                  <label>OTP Kodu</label>
                  <input
                    className="input"
                    value={code}
                    onChange={(e) => setCode(e.target.value)}
                    placeholder="E-postadan gelen kod"
                  />
                </div>
                <button className="button primary" type="button" onClick={() => void onConfirm()} disabled={confirming}>
                  {confirming ? 'Doğrulanıyor...' : 'Değişikliği Onayla'}
                </button>
                {debugCode ? (
                  <div style={{ marginTop: 8, color: 'var(--muted)', fontSize: 12 }}>Geliştirici kodu: {debugCode}</div>
                ) : null}
              </div>
            </>
          ) : null}
        </div>
      </AppShell>
    </ProtectedPage>
  );
}
