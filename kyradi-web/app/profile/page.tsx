'use client';

import { FormEvent, useEffect, useState } from 'react';
import { AppShell } from '@/components/app-shell';
import { ProtectedPage } from '@/components/protected-page';
import { fetchMe, updateMyProfile } from '@/lib/api';
import { setUserId } from '@/lib/auth';
import type { ApiUser } from '@/lib/types';
import { StatusBadge } from '@/components/status-badge';
import { NeoIcon } from '@/components/neo-icon';

export default function ProfilePage() {
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [user, setUser] = useState<ApiUser | null>(null);
  const [name, setName] = useState('');
  const [surname, setSurname] = useState('');
  const [phone, setPhone] = useState('');
  const [address, setAddress] = useState('');

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      setError(null);
      try {
        const me = await fetchMe();
        setUser(me);
        setName(me.name || '');
        setSurname(me.surname || '');
        setPhone(me.phone || '');
        setAddress(me.address || '');
        const userId = me._id || me.id;
        if (userId) setUserId(userId);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Profil alınamadı');
      } finally {
        setLoading(false);
      }
    };

    void load();
  }, []);

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setSaving(true);
    setError(null);
    setSuccess(null);

    try {
      await updateMyProfile({
        name: name.trim(),
        surname: surname.trim(),
        phone: phone.trim(),
        address: address.trim(),
      });
      setSuccess('Profil güncellendi.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Profil güncellenemedi');
    } finally {
      setSaving(false);
    }
  };

  return (
    <ProtectedPage>
      <AppShell title="Profil" subtitle="Kişisel bilgilerini ve doğrulama durumunu yönet">
        <div className="grid cols-2">
          <div className="card" style={{ padding: 18 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <NeoIcon symbol="◉" tone="amber" size="lg" />
              <div>
                <h3 style={{ margin: 0 }}>
                  {`${user?.name ?? ''} ${user?.surname ?? ''}`.trim() || 'Kyradi Kullanıcısı'}
                </h3>
                <p style={{ margin: '4px 0 0', color: 'var(--muted)' }}>{user?.email || '-'}</p>
              </div>
            </div>
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 14 }}>
              <StatusBadge value={user?.verified ? 'verified' : 'pending'}>
                {user?.verified ? 'E-posta Onaylı' : 'E-posta Bekliyor'}
              </StatusBadge>
              <StatusBadge value={user?.identityVerified ? 'verified' : 'pending'}>
                {user?.identityVerified ? 'Kimlik Onaylı' : 'Kimlik Bekliyor'}
              </StatusBadge>
            </div>
          </div>

          <div className="card" style={{ padding: 18 }}>
            {loading ? <p>Yükleniyor...</p> : null}
            {error ? <p style={{ color: 'var(--danger)' }}>Hata: {error}</p> : null}
            {success ? <p style={{ color: 'var(--primary)' }}>{success}</p> : null}

            {!loading ? (
              <form onSubmit={onSubmit}>
                <div className="grid cols-2">
                  <div className="form-row">
                    <label htmlFor="name">Ad</label>
                    <input
                      id="name"
                      className="input"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      required
                    />
                  </div>
                  <div className="form-row">
                    <label htmlFor="surname">Soyad</label>
                    <input
                      id="surname"
                      className="input"
                      value={surname}
                      onChange={(e) => setSurname(e.target.value)}
                      required
                    />
                  </div>
                </div>

                <div className="form-row">
                  <label htmlFor="phone">Telefon</label>
                  <input
                    id="phone"
                    className="input"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                  />
                </div>

                <div className="form-row">
                  <label htmlFor="address">Adres</label>
                  <input
                    id="address"
                    className="input"
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                  />
                </div>

                <div className="form-row">
                  <label>E-posta</label>
                  <input className="input" value={user?.email || ''} disabled />
                </div>

                <button className="button primary" type="submit" disabled={saving}>
                  {saving ? 'Kaydediliyor...' : 'Kaydet'}
                </button>
              </form>
            ) : null}
          </div>
        </div>
      </AppShell>
    </ProtectedPage>
  );
}
