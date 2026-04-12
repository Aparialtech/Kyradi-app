'use client';

import Link from 'next/link';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { AppShell } from '@/components/app-shell';
import { ProtectedPage } from '@/components/protected-page';
import {
  cancelLuggage,
  fetchLuggages,
  fetchMe,
  startPaymentCheckout,
  updateLuggageStatus,
  walletPay,
} from '@/lib/api';
import { getUserId, setUserId } from '@/lib/auth';
import type { LuggageItem } from '@/lib/types';
import { StatusBadge } from '@/components/status-badge';
import { NeoIcon } from '@/components/neo-icon';

function luggageId(item: LuggageItem): string {
  return item._id || item.id || '';
}

function canMarkDropped(item: LuggageItem): boolean {
  return (item.status || '').toLowerCase() === 'awaiting_drop';
}

function canMarkPicked(item: LuggageItem): boolean {
  return (item.status || '').toLowerCase() === 'dropped';
}

function canCancel(item: LuggageItem): boolean {
  const status = (item.status || '').toLowerCase();
  return status === 'awaiting_drop';
}

function canPay(item: LuggageItem): boolean {
  const status = (item.paymentStatus || '').toLowerCase();
  if (status === 'paid') return false;
  return (item.status || '').toLowerCase() !== 'cancelled';
}

function formatTry(amount: number) {
  return new Intl.NumberFormat('tr-TR', { style: 'currency', currency: 'TRY' }).format(amount);
}

export default function LuggagesPage() {
  const [userId, setCurrentUserId] = useState<string | null>(getUserId());
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [items, setItems] = useState<LuggageItem[]>([]);
  const [workingKey, setWorkingKey] = useState<string>('');

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const me = await fetchMe();
      const resolvedUserId = me._id || me.id || userId;
      if (!resolvedUserId) throw new Error('USER_ID_MISSING');
      setCurrentUserId(resolvedUserId);
      setUserId(resolvedUserId);
      const data = await fetchLuggages(resolvedUserId);
      setItems(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Bavullar alınamadı');
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => {
    void load();
  }, [load]);

  const stats = useMemo(() => {
    const total = items.length;
    const awaiting = items.filter((item) => (item.status || '').toLowerCase() === 'awaiting_drop').length;
    const dropped = items.filter((item) => (item.status || '').toLowerCase() === 'dropped').length;
    const unpaid = items.filter((item) => (item.paymentStatus || '').toLowerCase() !== 'paid').length;
    return { total, awaiting, dropped, unpaid };
  }, [items]);

  const runAction = async (actionKey: string, fn: () => Promise<void>) => {
    setWorkingKey(actionKey);
    setError(null);
    setMessage(null);
    try {
      await fn();
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'İşlem başarısız');
    } finally {
      setWorkingKey('');
    }
  };

  const onWalletPay = async (item: LuggageItem) => {
    if (!userId) return;
    const id = luggageId(item);
    if (!id) return;
    const amount = Number(item.totalPrice ?? 0);
    if (!Number.isFinite(amount) || amount <= 0) {
      setError('Ödeme tutarı geçersiz.');
      return;
    }
    await runAction(`wallet:${id}`, async () => {
      await walletPay({
        reservationId: id,
        amount: Math.round(amount),
      });
      setMessage(`Rezervasyon ${item.label || id} için cüzdan ödemesi tamamlandı.`);
    });
  };

  const onCheckout = async (item: LuggageItem, method: 'card' | 'installment' | 'pay_at_hotel' | 'transfer') => {
    const id = luggageId(item);
    if (!id) return;
    await runAction(`checkout:${id}:${method}`, async () => {
      const result = await startPaymentCheckout({
        reservationId: id,
        paymentMethod: method,
      });
      const checkoutUrl =
        result && typeof result === 'object' && typeof (result as Record<string, unknown>).checkoutUrl === 'string'
          ? ((result as Record<string, unknown>).checkoutUrl as string)
          : '';
      if (checkoutUrl) {
        window.open(checkoutUrl, '_blank', 'noopener,noreferrer');
      }
      if (method === 'pay_at_hotel') {
        setMessage('Ödeme yöntemi "Otelde Öde" olarak güncellendi.');
      } else if (checkoutUrl) {
        setMessage('Checkout bağlantısı yeni sekmede açıldı.');
      } else {
        setMessage('Checkout başlatıldı.');
      }
    });
  };

  const onUpdateStatus = async (item: LuggageItem, status: 'dropped' | 'picked_up') => {
    if (!userId) return;
    const id = luggageId(item);
    if (!id) return;
    await runAction(`status:${id}:${status}`, async () => {
      await updateLuggageStatus(userId, id, status);
      setMessage(status === 'dropped' ? 'Bavul bırakıldı olarak işaretlendi.' : 'Bavul teslim alındı olarak işaretlendi.');
    });
  };

  const onCancel = async (item: LuggageItem) => {
    if (!userId) return;
    const id = luggageId(item);
    if (!id) return;
    await runAction(`cancel:${id}`, async () => {
      await cancelLuggage(userId, id);
      setMessage('Rezervasyon iptal edildi.');
    });
  };

  return (
    <ProtectedPage>
      <AppShell title="Bavullarım" subtitle="Rezervasyonlarını tek akışta yönet">
        <div className="grid" style={{ gap: 16 }}>
          <div className="grid cols-3">
            <div className="card metric">
              <h4>Toplam</h4>
              <p>{stats.total}</p>
            </div>
            <div className="card metric">
              <h4>Teslim Bekleyen</h4>
              <p>{stats.awaiting}</p>
            </div>
            <div className="card metric">
              <h4>Depoda</h4>
              <p>{stats.dropped}</p>
            </div>
          </div>

          <div className="card" style={{ padding: 16 }}>
            <div style={{ display: 'flex', gap: 8, justifyContent: 'space-between', flexWrap: 'wrap' }}>
              <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
                <NeoIcon symbol="◈" tone="violet" size="md" />
                <div>
                  <strong>Rezervasyonlar</strong>
                  <p style={{ margin: 0, color: 'var(--muted)', fontSize: 13 }}>Ödenmemiş: {stats.unpaid}</p>
                </div>
              </div>
              <div style={{ display: 'flex', gap: 8 }}>
                <button className="button secondary" type="button" onClick={() => void load()} disabled={loading}>
                  Yenile
                </button>
                <Link href="/luggages/create" className="button primary">
                  Yeni Bavul
                </Link>
              </div>
            </div>
          </div>

          {loading ? <div className="card" style={{ padding: 16 }}>Yükleniyor...</div> : null}
          {error ? <div className="card" style={{ padding: 16, color: 'var(--danger)' }}>Hata: {error}</div> : null}
          {message ? <div className="card" style={{ padding: 16, color: 'var(--primary)' }}>{message}</div> : null}

          {!loading && !error && items.length === 0 ? (
            <div className="card" style={{ padding: 16 }}>Kayıtlı bavul bulunamadı.</div>
          ) : null}

          {!loading && !error && items.length > 0 ? (
            <div className="grid cols-2">
              {items.map((item) => {
                const id = luggageId(item);
                const amount = Number(item.totalPrice ?? 0);
                const isBusy = workingKey.includes(id);
                return (
                  <article key={id || item.qrCode} className="card" style={{ padding: 16 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', gap: 10, alignItems: 'start' }}>
                      <div>
                        <h3 style={{ margin: 0 }}>{item.label || 'Rezervasyon'}</h3>
                        <p style={{ margin: '6px 0 0', color: 'var(--muted)', fontSize: 13 }}>
                          {item.dropLocationName || '-'} · {item.qrCode || '-'}
                        </p>
                      </div>
                      <NeoIcon symbol="◉" tone="cyan" size="sm" />
                    </div>

                    <div style={{ marginTop: 12, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                      <StatusBadge value={item.status} />
                      <StatusBadge value={item.paymentStatus} />
                      <StatusBadge value="price">{formatTry(amount)}</StatusBadge>
                    </div>

                    <div style={{ marginTop: 14, display: 'grid', gap: 8 }}>
                      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                        {canPay(item) ? (
                          <>
                            <button className="button secondary" type="button" onClick={() => void onWalletPay(item)} disabled={isBusy}>
                              Cüzdanla Öde
                            </button>
                            <button className="button secondary" type="button" onClick={() => void onCheckout(item, 'card')} disabled={isBusy}>
                              Kart
                            </button>
                            <button
                              className="button secondary"
                              type="button"
                              onClick={() => void onCheckout(item, 'pay_at_hotel')}
                              disabled={isBusy}
                            >
                              Otelde Öde
                            </button>
                          </>
                        ) : null}
                        {canCancel(item) ? (
                          <button className="button secondary" type="button" onClick={() => void onCancel(item)} disabled={isBusy}>
                            İptal
                          </button>
                        ) : null}
                      </div>

                      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                        {canMarkDropped(item) ? (
                          <button className="button primary" type="button" onClick={() => void onUpdateStatus(item, 'dropped')} disabled={isBusy}>
                            Bavul Bırakıldı
                          </button>
                        ) : null}
                        {canMarkPicked(item) ? (
                          <button className="button primary" type="button" onClick={() => void onUpdateStatus(item, 'picked_up')} disabled={isBusy}>
                            Bavul Teslim Alındı
                          </button>
                        ) : null}
                        <Link href={`/luggages/${id}/edit`} className="button secondary">
                          Düzenle + OTP
                        </Link>
                      </div>
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
