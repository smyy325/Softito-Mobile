# 🛠️ Teknik Yetkinlikler, Mimari ve Geliştirme Kuralları (`skills.md`)

Bu dosya, "Modum Galaxy" projesinin geliştirilmesi sırasında uygulanacak yazılım mimarisini ve derste hedeflenen temel teknik yetkinlikleri tanımlar. Proje, SOLID prensiplerine ve Temiz Mimari (Clean Architecture) kurallarına uygun olarak geliştirilecektir.

---

## 1. Hedeflenen Akademik & Teknik Yetkinlikler (Core Competencies)

### 1.1. Temel UI Elemanları, Layout ve Material 3 Entegrasyonu
- **Ferah ve Sade Düzen (Fresh UI):** Karmaşık olmayan tasarımlar için `Scaffold`, `Padding`, `SizedBox` (boşluklar için), `Row`, `Column` ve `ListView.builder` kullanılacaktır. `Card` bileşenlerine `BorderRadius.circular` ile modern bir kavis verilecektir.
- **Tema Yönetimi (Dark / Light Mode):** 
  - `ThemeData` içinde `useMaterial3: true` kullanılacaktır.
  - Sabit renkler yerine, uygulamanın her yerinde `Theme.of(context).colorScheme` çağrılarak dinamik renk paleti oluşturulacaktır (böylece tek tuşla tüm UI teması sorunsuz değişir).
- **Buton Hiyerarşisi:**
  - Ana aksiyonlar (Giriş Yap, Kaydet, Şifre Belirle): `FilledButton`
  - İkincil aksiyonlar (Yan yana gelen Giriş/Üye Ol butonları): `FilledButton.tonal` veya `OutlinedButton`

### 1.2. Form Yönetimi, Validasyonlar ve Lifecycle (Yaşam Döngüsü)
- **Form Kontrolü:** Tüm veri girişlerinde `GlobalKey<FormState>` ile yönetilen `Form` widget'ı kullanılacaktır.
- **Bellek Yönetimi:** TextField kontrolleri için oluşturulan `TextEditingController` nesneleri, StatefulWidget'ın `dispose()` metodu içerisinde mutlaka temizlenerek (dispose edilerek) bellek sızıntıları (memory leak) önlenecektir.
- **Validasyon:** E-posta, şifre uzunluğu ve boş alan kontrolleri `validator` fonksiyonları ile anlık olarak yapılacaktır.

### 1.3. State (Durum) Yönetimi ve Asenkron İşlemler (Event Loop)
- **Şifre Görünürlüğü:** Şifre gizle/göster gibi basit sayfa içi durum (state) değişikliklerinde, gereksiz sayfa yenilemelerinden (setState) kaçınmak için `ValueNotifier` ve `ValueListenableBuilder` kullanılacaktır.
- **Veri Akışı:** Notların kaydedilmesi ve analiz ekranına aktarılması gibi asenkron (Future) işlemler, Dart'ın Event Loop mekanizmasına uygun, UI'ı dondurmayacak şekilde (async/await) kurgulanacaktır.

### 1.4. Diyaloglar ve Kullanıcı Etkileşimi
- **Onay İşlemleri:** Çıkış yaparken veya bir notu silerken `AlertDialog` kullanılacaktır.
- **Geri Bildirim:** Kullanıcı sisteme girdiğinde veya şifre hata verdiğinde ekranın altında `SnackBar` gösterilecektir.

---

## 2. İş Mantığı Algoritmaları (Business Rules)

1. **Aylık Mod Algoritması:** 
   - Kullanıcının son 30 gün içinde kaydettiği notlar taranır. 
   - Notlara atanmış "Gezegen ID'leri" gruplanarak (Map<String, int>) frekansı en yüksek olan gezegen bulunur.
   - Bulunan gezegenin taşıdığı "Duygu (Örn: Sakinlik)" ekrana baskın mod olarak yansıtılır.
2. **Buton Genişlik Hesaplaması (UI Rule):**
   - 2. ve 3. ekranlardaki yan yana butonlar `Row` içinde `Expanded` widget'ı ile sarılarak, ebeveyn (parent) genişliğini (TextField genişliği) tam olarak eşit (%50 - %50) paylaşması garanti altına alınır.

---

## 3. Önerilen Proje Dizin Yapısı (Feature-First / Clean Architecture)

Proje, özellik bazlı (feature-based) modüler bir dizin yapısına sahip olacaktır. Ayrıca gezegen görselleri için özel bir asset klasörü tanımlanmıştır.

```text
lib/
├── assets/
│   └── images/
│       └── planets/                # Gezegen fotoğrafları ve illüstrasyonları (Mecburi)
├── core/
│   ├── theme/
│   │   ├── app_theme.dart          # Material 3 Light & Dark tanımları
│   │   └── theme_provider.dart     # Tema durumu yönetimi
│   ├── utils/
│   │   └── validators.dart         # Form validasyon kuralları
│   └── widgets/
│       ├── custom_text_field.dart  # Ortak kullanılan Input alanı
│       └── planet_card.dart        # Notların listelendiği kart bileşeni
├── features/
│   ├── auth/                       # Giriş, Kayıt, Şifremi Unuttum modülü
│   ├── home/                       # Alt menü ve Ana Sayfa listelemesi
│   ├── notes/                      # Not Ekleme ve Gezegen-Duygu Atama
│   ├── analytics/                  # Aylık Analiz algoritması ve ekranı
│   └── profile/                    # Kullanıcı bilgileri ve Tema değiştirme
└── main.dart                       # Uygulama başlangıç noktası