# Kan Bağışı ve İstatistik Takip Uygulaması
Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve Teknolojiler
- **Uygulama Adı:** KanVer (akıllı kan bağışı, stok grafiği ve acil talep takibi uygulaması)
- **Hedef Platformlar:** IOS ve Android öncelikli ardından web ve masaüstü platformları.
- **Flutter SDK:** 3.15.1
- **Dart SDK:** 3.6.0
- **Tasarım Dili:** Material 3, Çift Tema Desteği (Karanlık Mod / Sistem Teması / Aydınlık Mod; Gece medikal paleti dark obsidian & crimson neon + Modern medikal aydınlık palet) 


## Mimari Yapı: Özellik bazlı
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır. 

```text
lib/
    core/
        constants/app_colors.dart
        extensions/context_extensions.dart
        theme/
            app_theme.dart
            theme_controller.dart
            widget/
                theme_mode_switch_button.dart
    features/
        donation_tracker/
            controller/
            models/
            view/
            widget/
        blood_stats/
            controller/
            models/
            view/
            widget/
        urgent_requests/
            controller/
            models/
            view/
            widget/
        reminders/
            controller/
            models/
            view/
            widget/
    main.dart
```

#### Sadece uygulama başlatma ve tema bölümleri

## 3. Kırmızı Çizgiler Kod Kalite Standartları
1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` kullanımından kesinlikle kaçın. Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans Kuralları:** 
Statik tüm widget'larda `const` zorunludur. 
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.
Büyük build metotları yasaktır. 40 satırı geçen build metotları özel widgetlara yazılacaktır. 
Kan bağışı ve stok grafikleri harici paket kullanılmadan yerel Flutter widget'ları ile `widget/` klasörü altında çizilecektir.

3 - Projeye onay almadan harici ağır state veya grafik paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır. 

4 - **Sistem Karanlık Mod ve Tema Standartları:**
Tema yönetimi `core/theme/theme_controller.dart` içinde `ValueNotifier<ThemeMode>` ile reaktif olarak yönetilir. `ThemeMode.system`, `ThemeMode.dark` ve `ThemeMode.light` durumları desteklenir. C