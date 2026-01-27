# Kyradi iOS Maps Crash Triage

## Hızlı Özet
iOS’ta Google Maps native SDK’sı, **eksik API key** veya **yanlış lifecycle** durumlarında
uygulamayı native seviyede sonlandırabilir. Bu doküman, crash log yakalama ve hızlı teşhis
adımlarını içerir.

## Log Toplama
1) Xcode Console:
   - Cihazı bağla → Xcode → Window → Devices and Simulators → device log
2) Simulator log:
   - Xcode Console veya `Console.app` üzerinden simulator loglarını izle
3) Flutter log:
   - `MAP_TAP`, `MAP_PREFLIGHT_OK/FAIL`, `MAP_WIDGET_CREATED`, `MAP_ERROR`

## En Sık Nedenler
1) **GMSApiKey eksik**
   - `Info.plist` içinde `GOOGLE_MAPS_API_KEY` tanımlı değil.
2) **API key restriction mismatch**
   - Bundle ID farklı olduğunda SDK çalışmayabilir.
3) **Location permission eksik**
   - `NSLocationWhenInUseUsageDescription` yok veya kullanıcı reddetti.
4) **Lifecycle hatası**
   - Controller dispose sonrası kullanılmaya çalışılır.

## Checklist
- [ ] `Info.plist` içinde `GOOGLE_MAPS_API_KEY` var
- [ ] API key, iOS bundle ID için yetkili
- [ ] `NSLocationWhenInUseUsageDescription` mevcut
- [ ] `MAP_PREFLIGHT_OK` log görülüyor
- [ ] `MAP_WIDGET_CREATED` log görülüyor

## Not
Preflight fail olduğunda uygulama haritayı açmaz ve kullanıcıya uyarı gösterir.
