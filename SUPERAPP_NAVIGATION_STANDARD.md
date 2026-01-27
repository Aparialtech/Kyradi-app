# Kyradi SuperApp Navigation Standard

## Amaç
Tek bir routing standardı (go_router) ve tek bir Shell yapısı ile tüm UI akışları SuperApp içinde çalışır. Legacy UI ekranları navigasyonla erişilmez.

## Route Tree
- `/intro` → IntroSplashPage
- `/login` → Login
- `/register` → Register
- `/verify` → Verify Code
- `/forgot` → Forgot Password
- `/home` → Dashboard (Shell tab 0)
- `/explore` → Explore (Shell tab 1)
- `/bookings` → Bookings (Shell tab 2)
- `/wallet` → Wallet (Shell tab 3)
- `/profile` → Profile (Shell tab 4)
- `/luggage` → Luggage List
- `/luggage/add` → Add Luggage
- `/luggage/:id` → Luggage Detail
- `/luggage/:id/qr` → QR Preview
- `/location/:id` → Location Reservation
- `/notifications` → Notifications

## Kurallar
1) Navigasyon yalnızca `context.go()` / `context.push()` ile yapılır.  
2) Legacy route’lar kullanılmaz; `/app` gibi eski path’ler `/home`’a redirect edilir.  
3) UI katmanı sadece SuperApp ekranlarını çağırır; HomePage (legacy) route olarak yoktur.  
4) Luggage akışları `/luggage` altında toplanır.  

## Legacy Redirect/Block
- `/app` → `/home`
- Legacy HomePage route’u kaldırılmıştır (build içinde kullanılmaz).
