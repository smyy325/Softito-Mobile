# Fitness Su Takip Uygulaması
Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve Teknolojiler
- **Uygulama Adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması)
- **Hedef Platformlar:** IOS ve Android öncelikli ardından web ve masaüstü platformları.
- **Flutter SDK:** 3.15.1
- **Dart SDK:** 3.6.0
- **Tasarım Dili:** Material 3, Çift Tema Desteği (Karanlık Mod / Sistem Teması / Aydınlık Mod; Gece spor salonu paleti dark obsidian & neon + Modern sportif aydınlık palet) 


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
        water_tracker/
            controller/
            models/
            view/
            widget/
        workout/
            controller/
            models/
            view/
            widget/
        calorie_tracker/
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

3 - Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır. 

4 - **Sistem Karanlık Mod ve Tema Standartları:**
Tema yönetimi `core/theme/theme_controller.dart` içinde `ValueNotifier<ThemeMode>` ile reaktif olarak yönetilir. `ThemeMode.system`, `ThemeMode.dark` ve `ThemeMode.light` durumları desteklenir. Cihaz sistem modu ile tam senkronize çalışır; istenirse kullanıcı manuel olarak da karanlık/aydınlık moda geçebilir. Doğrudan sabit renkler yerine `Theme.of(context).colorScheme` ve tema tokens kullanılmalıdır. 

## 4. Geliştirme Analiz ve Test Komutları
Ajan ayptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır. 

* **Statik kod analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```
- **Birim ve widget testleri:** 
```bash
flutter test
```

* **Projeyi çalıştırma:**
```bash
flutter run
```

## 5. Ajanın Çıktı ve Yanıt Verme Standartları
**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olcaktır.

**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sonra basma; hedef satıralrı ve diff yapısını göster. 

**Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver. 