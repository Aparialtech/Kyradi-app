'use client';

import { FormEvent, useEffect, useMemo, useState } from 'react';
import { AppShell } from '@/components/app-shell';
import { ProtectedPage } from '@/components/protected-page';
import { fetchWallet, walletPay, walletTopup } from '@/lib/api';
import type { WalletTx } from '@/lib/types';
import { StatusBadge } from '@/components/status-badge';
import { NeoIcon } from '@/components/neo-icon';

function formatTry(value: number) {
  return new Intl.NumberFormat('tr-TR', { style: 'currency', currency: 'TRY' }).format(value);
}

export default function WalletPage() {
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [balance, setBalance] = useState(0);
  const [transactions, setTransactions] = useState<WalletTx[]>([]);
  const [topupAmount, setTopupAmount] = useState('500');
  const [payReservationId, setPayReservationId] = useState('');
  const [payAmount, setPayAmount] = useState('');

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await fetchWallet();
      setBalance(Number(data.balance || 0));
      setTransactions(Array.isArray(data.transactions) ? data.transactions : []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Cüzdan alınamadı');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void load();
  }, []);

  const totals = useMemo(() => {
    let incoming = 0;
    let outgoing = 0;
    for (const tx of transactions) {
      const amount = Number(tx.amount || 0);
      if ((tx.type || '').toLowerCase() === 'pay') outgoing += amount;
      else incoming += amount;
    }
    return { incoming, outgoing };
  }, [transactions]);

  const onTopup = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const amount = Number(topupAmount);
    if (!Number.isFinite(amount) || amount <= 0) {
      setError('Geçerli bir yükleme tutarı gir.');
      return;
    }
    setActionLoading(true);
    setError(null);
    setMessage(null);
    try {
      await walletTopup({ amount });
      setMessage(`${formatTry(amount)} cüzdana eklendi.`);
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Yükleme başarısız');
    } finally {
      setActionLoading(false);
    }
  };

  const onWalletPay = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!payReservationId.trim()) {
      setError('Rezervasyon ID gerekli.');
      return;
    }
    const amountParsed = payAmount.trim() ? Number(payAmount) : NaN;
    const amount =
      Number.isFinite(amountParsed) && amountParsed > 0 ? Math.round(amountParsed) : undefined;
    setActionLoading(true);
    setError(null);
    setMessage(null);
    try {
      await walletPay({
        reservationId: payReservationId.trim(),
        amount,
      });
      setMessage('Rezervasyon için cüzdan ödemesi işlendi.');
      setPayAmount('');
      setPayReservationId('');
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Ödeme başarısız');
    } finally {
      setActionLoading(false);
    }
  };

  return (
    <ProtectedPage>
      <AppShell title="Cüzdan" subtitle="Bakiye, yükleme ve ödeme işlemleri">
        <div className="grid" style={{ gap: 16 }}>
          <div className="grid cols-3">
            <div className="card metric">
              <h4>Toplam Bakiye</h4>
              <p>{formatTry(balance)}</p>
            </div>
            <div className="card metric">
              <h4>Toplam Gelen</h4>
              <p>{formatTry(totals.incoming)}</p>
            </div>
            <div className="card metric">
              <h4>Toplam Giden</h4>
              <p>{formatTry(totals.outgoing)}</p>
            </div>
          </div>

          <div className="grid cols-2">
            <div className="card" style={{ padding: 16 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
                <NeoIcon symbol="₺" tone="green" size="md" />
                <h3 style={{ margin: 0 }}>Bakiye Yükle</h3>
              </div>
              <form onSubmit={onTopup}>
                <div className="form-row">
                  <label htmlFor="topupAmount">Tutar (₺)</label>
                  <input
                    id="topupAmount"
                    className="input"
                    value={topupAmount}
                    onChange={(e) => setTopupAmount(e.target.value)}
                  />
                </div>
                <button className="button primary" type="submit" disabled={actionLoading}>
                  Cüzdana Ekle
                </button>
              </form>
            </div>

            <div className="card" style={{ padding: 16 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
                <NeoIcon symbol="◈" tone="violet" size="md" />
                <h3 style={{ margin: 0 }}>Rezervasyon Öde</h3>
              </div>
              <form onSubmit={onWalletPay}>
                <div className="form-row">
                  <label htmlFor="reservationId">Rezervasyon ID</label>
                  <input
                    id="reservationId"
                    className="input"
                    value={payReservationId}
                    onChange={(e) => setPayReservationId(e.target.value)}
                    placeholder="Mongo id"
                  />
                </div>
                <div className="form-row">
                  <label htmlFor="payAmount">Tutar (opsiyonel)</label>
                  <input
                    id="payAmount"
                    className="input"
                    value={payAmount}
                    onChange={(e) => setPayAmount(e.target.value)}
                    placeholder="Boş bırak: rezervasyon tutarı"
                  />
                </div>
                <button className="button primary" type="submit" disabled={actionLoading}>
                  Cüzdanla Öde
                </button>
              </form>
            </div>
          </div>

          {loading ? <div className="card" style={{ padding: 16 }}>Yükleniyor...</div> : null}
          {error ? <div className="card" style={{ padding: 16, color: 'var(--danger)' }}>Hata: {error}</div> : null}
          {message ? <div className="card" style={{ padding: 16, color: 'var(--primary)' }}>{message}</div> : null}

          {!loading ? (
            <section className="grid cols-2">
              {transactions.map((tx) => (
                <article key={tx._id || `${tx.type}-${tx.createdAt}-${tx.amount}`} className="card" style={{ padding: 14 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', gap: 10 }}>
                    <div>
                      <p style={{ margin: 0, color: 'var(--muted)', fontSize: 13 }}>
                        {tx.createdAt ? new Date(tx.createdAt).toLocaleString('tr-TR') : '-'}
                      </p>
                      <h4 style={{ margin: '6px 0 0' }}>{tx.note || 'Cüzdan işlemi'}</h4>
                    </div>
                    <StatusBadge value={tx.type}>{tx.type || '-'}</StatusBadge>
                  </div>
                  <p style={{ margin: '10px 0 0', fontWeight: 800, fontSize: 20 }}>
                    {formatTry(Number(tx.amount || 0))}
                  </p>
                  {tx.reservationId ? (
                    <p style={{ margin: '5px 0 0', color: 'var(--muted)', fontSize: 13 }}>
                      Rezervasyon: {tx.reservationId}
                    </p>
                  ) : null}
                </article>
              ))}
              {transactions.length === 0 ? <div className="card" style={{ padding: 16 }}>Henüz işlem yok.</div> : null}
            </section>
          ) : null}
        </div>
      </AppShell>
    </ProtectedPage>
  );
}
