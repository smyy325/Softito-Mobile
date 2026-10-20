name:flutter-feature-scaffold
description:Flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur.
valueNotifier state mimarisini UI ayrımını grafik bileşenlerini ve birim test iskeletini standartlara uygun olarak üretir.
# Flutter feature scaffold(modüler ekran iskeleti)
bu yetenek, projede yeni bir ekran yada işlev modülü açarken clean UI ve reaktif state kurallarına tam uyulmasını garanti altına alır.
## Temel kurallar
1. **Asla tek dosyada toplama:** UI ('_view.dart') State controller
('_controller.dart') ve model
('_model.dart') dosyaları ayrı ayrı açılmalıdır.

2. **State Yönetimi:**
Basit ve reaktif durumlar için `ValueNotifier` kullanılmalıdır. doğrudan devasa statefulWidget yazarak işi karmaşıklaştırma.

3. **const zorunluluğu:** mümkün olan tüm widgetlarda const olmalıdır.

## adım adım uygulama akışı
### adım 1: klasör yapısını oluşturma
Hedeflenen modül adlarını (örn: 'donation_tracker'), 'lib/features/<feature_name>' altına yapıyı kur

```text
lib/features/<feature_name>
    controller/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    view/
        <feature_name>_view.dart
    widget/
        <feature_name>_card.dart
```
    
### Adım 2: Controller Dosyasını Yaz
`controller/<feature_name>_controller.dart` içinde mantığı `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';

class DonationTrackerController {
  final ValueNotifier<int> currentUnits = ValueNotifier<int>(0);
  final int yearlyGoalUnits = 4; // Yıllık 4 ünite hedefi

  void addDonation() {
    if (currentUnits.value < yearlyGoalUnits) {
      currentUnits.value += 1;
    }
  }

  void resetDonation() {
    currentUnits.value = 0;
  }

  void dispose() {
    currentUnits.dispose();
  }
}
```

### Adım 3: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `immutable` olarak tanımla:

```dart
class DonorProfile {
  final String name;
  final String bloodType;
  final String profileImage;
  final int totalUnits;
  final int savedLives;

  const DonorProfile({
    required this.name,
    required this.bloodType,
    required this.profileImage,
    required this.totalUnits,
    required this.savedLives,
  });

  DonorProfile copyWith({
    String? name,
    String? bloodType,
    String? profileImage,
    int? totalUnits,
    int? savedLives,
  }) {
    return DonorProfile(
      name: name ?? this.name,
      bloodType: bloodType ?? this.bloodType,
      profileImage: profileImage ?? this.profileImage,
      totalUnits: totalUnits ?? this.totalUnits,
      savedLives: savedLives ?? this.savedLives,
    );
  }

  factory DonorProfile.fromJson(Map<String, dynamic> json) {
    return DonorProfile(
      name: json['name'] ?? '',
      bloodType: json['bloodType'] ?? '',
      profileImage: json['profileImage'] ?? '',
      totalUnits: json['totalUnits'] ?? 0,
      savedLives: json['savedLives'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bloodType': bloodType,
      'profileImage': profileImage,
      'totalUnits': totalUnits,
      'savedLives': savedLives,
    };
  }
}
```

### adım 4 : view dosyasını oluşturma
`view/<feature_name>_view.dart` dosyasını `StatelessWidget` olarak tasarla.

```dart
import 'package:flutter/material.dart';
import '../controller/donation_tracker_controller.dart';
import '../widget/donation_tracker_card.dart';

class DonationTrackerView extends StatelessWidget {
  final DonationTrackerController _controller = DonationTrackerController();
  DonationTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kan Bağışı Takibi'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _controller.currentUnits,
        builder: (context, currentUnits, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DonationTrackerCard(
                  title: 'Yıllık Bağış Grafiği',
                  bloodType: '0 Rh+',
                  currentUnits: currentUnits,
                  goalUnits: _controller.yearlyGoalUnits,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _controller.addDonation,
                  child: const Text('1 Ünite Kan Bağışı Ekle'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _controller.resetDonation,
                  child: const Text('Sıfırla'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Adım 5: Widget Dosyasını Oluşturma
`widget/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanılarak grafik ve UI katmanını oluştur:

```dart
import 'package:flutter/material.dart';

class DonationTrackerCard extends StatelessWidget {
  final String title;
  final String bloodType;
  final int currentUnits;
  final int goalUnits;

  const DonationTrackerCard({
    super.key,
    required this.title,
    required this.bloodType,
    required this.currentUnits,
    required this.goalUnits,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = (currentUnits / goalUnits).clamp(0.0, 1.0);
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title),
            Text('Kan Grubu: $bloodType'),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: ratio,
              minHeight: 12,
            ),
            const SizedBox(height: 8),
            Text('Bağış: $currentUnits / $goalUnits Ünite'),
            Text('Kurtarılan Hayat: ${currentUnits * 3}'),
          ],
        ),
      ),
    );
  }
}
```

### Adım 6: Clean Architecture Kurallarına Uyum
- **Separation of Concerns:** Her dosyanın belirli bir sorumluluğu olduğundan emin ol.
- **Reusability:** Widget'ları ve controller'ı diğer ekranlarda da kullanabilecek şekilde tasarla.
- **Testability:** Her katman için ayrı testler yazabileceğinden emin ol.

## Kullanım Örnekleri

### Örnek 1: Basit bir ekran oluşturma
```dart
import 'package:flutter/material.dart';
import '../view/donation_tracker_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DonationTrackerView();
  }
}
```
### Örnek 2: Modüler widget kullanımı
```dart
import 'package:flutter/material.dart';
import '../widget/donation_tracker_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DonationTrackerCard(
      title: 'Kan Bağışı Grafiği',
      bloodType: '0 Rh+',
      currentUnits: 2,
      goalUnits: 4,
    );
  }
}
```
## Ekstra İpuçları
- **Dependency Injection:** Controller'ları widgetlara inject etmek için GetIt veya Provider kullanabilirsin.
- **Navigation:** Navigasyonu sağlamak için Navigator 2.0 veya go_router kullanabilirsin.
- **Testing:** Her katman için ayrı testler yazarak uygulamanın stabilitesini sağlayabilirsin. 

## SSS

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni bir ekran veya işlev modülü oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yetenek hangi durumlarda kullanmamalıyım?
**Cevap:** Mevcut bir ekranı güncellerken veya küçük bir hata düzeltmesi yaparken bu yeteneği kullanmamalısın.