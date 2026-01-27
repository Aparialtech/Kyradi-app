# Kyradi SuperApp Migration Notes

## Legacy UI Kapatılan Alanlar
- `HomePage` (legacy monolith) artık route olarak kullanılmıyor.
- SuperApp içindeki “Classic Panel” yönlendirmeleri kaldırıldı.
- Bookings/Profile/Dashboard içindeki legacy push’lar `/luggage` ve SuperApp route’larına yönlendirildi.

## Eski → Yeni Akış Eşlemeleri
- HomePage tabları → SuperApp Shell tabları
- Bavul listesi → `/luggage`
- Bavul ekle → `/luggage/add`
- Bavul detay → `/luggage/:id`
- QR görüntüle → `/luggage/:id/qr`

## Notlar
- Legacy UI dosyaları repo’da kalabilir fakat artık navigasyonla açılmıyor.
- Luggage işlemleri `LuggageRepository` üzerinden standartlaştırıldı.
