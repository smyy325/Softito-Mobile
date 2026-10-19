---
name: flutter-feature-scaffold
description: Flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken Clean UI ve reaktif state kurallarına tam uyulmasını garanti altına alır. [project.md](file:///Users/d1-21/19ekim2/project.md) belgesindeki standartlarla %100 senkronizedir.

---

## 1. Temel Kurallar ve Kırmızı Çizgiler

1. **Asla Tek Dosyada Toplama:** UI (`_view.dart`), State Controller (`_controller.dart`), Model (`_model.dart`) ve alt bileşenler (`widget/`) dosyaları ayrı ayrı açılmalıdır.
2. **State Yönetimi:** Basit ve reaktif durumlar için `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır. Devasa `StatefulWidget` ve sayfa genelinde ağır `setState` kullanımları yasaktır.
3. **const Zorunluluğu:** Mümkün olan tüm statik widget'larda `const` yapıcı zorunludur.
4. **40 Satır UI Kuralı:** Hiçbir `build()` metodu 40 satırı geçemez. Aşan kısımlar `widget/` altına bağımsız atomik widget olarak ayrılmalıdır.
5. **Tema Entegrasyonu:** Sabit renkler (Colors.red vb.) yasaktır. Renkler `Theme.of(context).colorScheme` üzerinden alınmalıdır.

---

## 2. Yeteneğin İlgili Kaynak Dosyaları

Bu yetenek aşağıdaki yardımcı araç ve referans belgeleriyle birlikte çalışır:

* **İskelet Üretici Betik:** [generate_feture.sh](file:///Users/d1-21/19ekim2/.agents/skills/script/generate_feture.sh) — Yeni bir modül iskeletini, modellerini, controller'ını, view'ını ve birim testlerini otomatik üretir.
* **Mimari Akış Referansı:** [state_flow.md](file:///Users/d1-21/19ekim2/.agents/skills/referances/state_flow.md) — Reaktif `ValueNotifier` döngüsünü, yaşam döngüsünü ve tema senkronizasyonunu açıklayan teknik kılavuz.
* **Eksiksiz Örnek Ekran:** [sample_screen.dart](file:///Users/d1-21/19ekim2/.agents/skills/examples/sample_screen.dart) — Tüm kurallara uyan, çalışan, sıfır hatalı örnek Flutter ekranı.

---

## 3. Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısını Oluşturma
Hedeflenen modül adını (örn: `water_tracker`) `lib/features/<feature_name>` altına kur:

```text
lib/features/<feature_name>/
    controller/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    view/
        <feature_name>_view.dart
    widget/
        <feature_name>_summary_card.dart
        <feature_name>_action_buttons.dart
test/features/<feature_name>/
    <feature_name>_controller_test.dart
```

> [!TIP]
> Bu yapıyı tek komutla otomatik kurmak için betiği kullanabilirsin:
> ```bash
> ./.agents/skills/script/generate_feture.sh water_tracker
> ```

---

### Adım 2: Controller Dosyasını Yaz
`controller/<feature_name>_controller.dart` içinde iş mantığını ve `ValueNotifier` tanımlarını oluştur, mutlaka `dispose()` metodunu ekle:

```dart
import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> stateNotifier;

  WaterTrackerController({WaterTrackerModel? initialState})
      : stateNotifier = ValueNotifier<WaterTrackerModel>(
          initialState ?? WaterTrackerModel.initial(),
        );

  WaterTrackerModel get state => stateNotifier.value;

  void addWater(int amount) {
    if (amount <= 0) return;
    stateNotifier.value = state.copyWith(
      currentWaterMl: state.currentWaterMl + amount,
    );
  }

  void resetWater() {
    stateNotifier.value = state.copyWith(currentWaterMl: 0);
  }

  void dispose() {
    stateNotifier.dispose();
  }
}
```

---

### Adım 3: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `@immutable` olarak tanımla:

```dart
import 'package:flutter/foundation.dart';

@immutable
class WaterTrackerModel {
  final int currentWaterMl;
  final int dailyGoalMl;

  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
  });

  factory WaterTrackerModel.initial() {
    return const WaterTrackerModel(currentWaterMl: 0, dailyGoalMl: 2500);
  }

  WaterTrackerModel copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
  }) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalMl': dailyGoalMl,
    };
  }
}
```

---

### Adım 4: View Dosyasını Oluşturma
`view/<feature_name>_view.dart` dosyasını `build` metodu 40 satırı geçmeyen, `ValueListenableBuilder` ile dinlenen bir yapı olarak kur:

```dart
import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widget/water_tracker_summary_card.dart';
import '../widget/water_tracker_action_buttons.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

class _WaterTrackerViewState extends State<WaterTrackerView> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takibi'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<WaterTrackerModel>(
            valueListenable: _controller.stateNotifier,
            builder: (context, state, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WaterTrackerSummaryCard(state: state),
                  const Spacer(),
                  WaterTrackerActionButtons(
                    onAddWater: () => _controller.addWater(250),
                    onReset: _controller.resetWater,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

---

### Adım 5: Widget Dosyalarını Oluşturma
`widget/<feature_name>_*.dart` dosyalarında `build` metotları 40 satırın altında kalan atomik bileşenler oluştur:

```dart
import 'package:flutter/material.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerSummaryCard extends StatelessWidget {
  final WaterTrackerModel state;

  const WaterTrackerSummaryCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          '${state.currentWaterMl} / ${state.dailyGoalMl} ml',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
```

---

## 4. Geliştirme ve Doğrulama Komutları

Değişikliklerin ardından mutlaka alttaki komutlarla doğrulama yapılmalıdır:

* **Statik Kod Analizi (0 uyarı, 0 hata şart):**
  ```bash
  flutter analyze
  ```

* **Birim ve Widget Testleri:**
  ```bash
  flutter test
  ```

---

## 5. Sıkça Sorulan Sorular (SSS)

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni bir ekran veya işlev modülü (su, kalori, egzersiz, hatırlatıcı vb.) açarken bu yeteneği kullanmalısın.

### Soru: Hangi durumlarda kullanmamalıyım?
**Cevap:** Mevcut bir ekranda tek satırlık küçük bir görsel rötuş veya minik hata düzeltmesi yaparken tüm iskeleti baştan açmaya gerek yoktur.