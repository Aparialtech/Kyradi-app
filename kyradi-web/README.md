# KYRADI Web

Bu uygulama, `Kyradi-SuperApp` içindeki mobil uygulamayla aynı backend API'yi kullanan web istemcisidir.

## Mimari

- Backend: `../backend` (NestJS + MongoDB)
- Mobil: `../lib` (Flutter)
- Web: `./` (Next.js)

Mobil ve web aynı API/DB üzerinde çalıştığı için aynı kullanıcı hesabıyla iki platformda da aynı rezervasyon/cüzdan/profil verisi görünür.

## Kurulum

```bash
cd kyradi-web
cp .env.example .env.local
npm install
npm run dev
```

Varsayılan adres: `http://localhost:3000`

## Çalışan sayfalar

- `/login` — backend `/auth/login` ile giriş
- `/register` — backend `/auth/register` + `/auth/verify` ile kayıt/doğrulama
- `/dashboard` — kullanıcı özeti, aktif rezervasyon, cüzdan/lokasyon metrikleri
- `/luggages` — kullanıcı bavul listesi + ödeme/durum/iptal işlemleri
- `/luggages/create` — yeni rezervasyon oluşturma + fiyat hesaplama
- `/luggages/[id]/edit` — rezervasyon bilgisi güncelleme + OTP onayı
- `/wallet` — cüzdan bakiye + yükleme + rezervasyon ödeme + işlem geçmişi
- `/locations` — lokasyon listesi ve uygunluk
- `/profile` — profil görüntüleme/güncelleme

## Entegrasyon notları

- Token `localStorage` içinde saklanır (MVP).
- Prod hardening için `httpOnly cookie + refresh token` yapısına geçiş önerilir.
- Backend CORS whitelist içine web domainini ekleyin:
  - `http://localhost:3000`
  - `https://web.kyradi.com`

## Build

```bash
npm run lint
npm run build
```
