import 'package:flutter/material.dart';

// =============================================================================
// SUSADIM FITNESS SU TAKİP - ÖRNEK EKRAN UYGULAMASI (sample_screen.dart)
//
// Standartlar ve Kırmızı Çizgiler (project.md & SKILL.md):
// 1. Durum Yönetimi: Ağır setState yerine ValueNotifier & ValueListenableBuilder.
// 2. Performans: Tüm statik widget'lar 'const' ile işaretlenmiştir.
// 3. UI Temizlik Kuralı: Hiçbir build() metodu 40 satırı GEÇMEZ.
// 4. Tema: Renkler doğrudan Theme.of(context).colorScheme üzerinden çekilir.
// 5. Model: @immutable, copyWith, fromJson, toJson standartlarına tam uyumlu.
// =============================================================================

// -----------------------------------------------------------------------------
// 1. MODEL KATMANI (lib/features/water_tracker/models/)
// -----------------------------------------------------------------------------

/// Tek bir su tüketim kaydı
@immutable
class WaterLogEntry {
  final String id;
  final int amountMl;
  final DateTime timestamp;

  const WaterLogEntry({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });

  WaterLogEntry copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
  }) {
    return WaterLogEntry(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WaterLogEntry.fromJson(Map<String, dynamic> json) {
    return WaterLogEntry(
      id: json['id'] as String? ?? '',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Su takip modülünün değişmez (immutable) durum modeli
@immutable
class WaterTrackerState {
  final int currentWaterMl;
  final int dailyGoalMl;
  final List<WaterLogEntry> history;

  const WaterTrackerState({
    this.currentWaterMl = 0,
    this.dailyGoalMl = 2500,
    this.history = const <WaterLogEntry>[],
  });

  double get progressRatio =>
      dailyGoalMl > 0 ? (currentWaterMl / dailyGoalMl).clamp(0.0, 1.0) : 0.0;

  int get progressPercent => (progressRatio * 100).toInt();

  int get remainingWaterMl =>
      (dailyGoalMl - currentWaterMl).clamp(0, dailyGoalMl);

  WaterTrackerState copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
    List<WaterLogEntry>? history,
  }) {
    return WaterTrackerState(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      history: history ?? this.history,
    );
  }

  factory WaterTrackerState.fromJson(Map<String, dynamic> json) {
    final historyList = (json['history'] as List<dynamic>?)
            ?.map((e) => WaterLogEntry.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <WaterLogEntry>[];

    return WaterTrackerState(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2500,
      history: historyList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalMl': dailyGoalMl,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }
}

// -----------------------------------------------------------------------------
// 2. CONTROLLER KATMANI (lib/features/water_tracker/controller/)
// -----------------------------------------------------------------------------

/// Reaktif Su Takibi İş Mantığı
/// project.md Kuralı: Harici state kütüphaneleri yasaktır, ValueNotifier kullanılır.
class WaterTrackerController {
  final ValueNotifier<WaterTrackerState> stateNotifier;

  WaterTrackerController({WaterTrackerState? initialState})
      : stateNotifier = ValueNotifier<WaterTrackerState>(
          initialState ?? const WaterTrackerState(),
        );

  WaterTrackerState get state => stateNotifier.value;

  /// Su tüketimi ekle (+200, +250, +500 ml vb.)
  void addWater(int amountMl) {
    if (amountMl <= 0) return;

    final newEntry = WaterLogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );

    final updatedHistory = List<WaterLogEntry>.from(state.history)
      ..insert(0, newEntry);

    stateNotifier.value = state.copyWith(
      currentWaterMl: state.currentWaterMl + amountMl,
      history: updatedHistory,
    );
  }

  /// Günlük tüketimi sıfırla
  void resetWater() {
    stateNotifier.value = state.copyWith(
      currentWaterMl: 0,
      history: const <WaterLogEntry>[],
    );
  }

  /// Günlük hedefi güncelle
  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    stateNotifier.value = state.copyWith(dailyGoalMl: newGoalMl);
  }

  /// Bellek sızıntılarını önlemek için dinleyiciyi kapat
  void dispose() {
    stateNotifier.dispose();
  }
}

// -----------------------------------------------------------------------------
// 3. ATOMİK WIDGET KATMANI (lib/features/water_tracker/widget/)
// Kural: Hiçbir build() metodu 40 satırı geçemez. const zorunludur.
// -----------------------------------------------------------------------------

/// Dairesel su ilerleme ve özet kartı (< 40 satır)
class WaterProgressRingCard extends StatelessWidget {
  final WaterTrackerState state;

  const WaterProgressRingCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: state.progressRatio,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    backgroundColor:
                        colorScheme.outlineVariant.withValues(alpha: 0.3),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${state.currentWaterMl}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                      ),
                      Text(
                        '/ ${state.dailyGoalMl} ml',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.remainingWaterMl > 0
                  ? 'Hedefe ${state.remainingWaterMl} ml kaldı (%${state.progressPercent})'
                  : 'Tebrikler! Günlük su hedefine ulaştın 🎉',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: state.remainingWaterMl > 0
                        ? colorScheme.primary
                        : colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hızlı su ekleme buton grubu (< 40 satır)
class WaterQuickAddButtons extends StatelessWidget {
  final void Function(int amount) onAddWater;
  final VoidCallback onReset;

  const WaterQuickAddButtons({
    super.key,
    required this.onAddWater,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _buildAddButton(context, 200, '+200 ml')),
            const SizedBox(width: 8),
            Expanded(child: _buildAddButton(context, 250, '+250 ml')),
            const SizedBox(width: 8),
            Expanded(child: _buildAddButton(context, 500, '+500 ml')),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: Icon(Icons.refresh, size: 18, color: colorScheme.error),
          label: Text(
            'Günü Sıfırla',
            style: TextStyle(color: colorScheme.error),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: colorScheme.error.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, int amount, String label) {
    return FilledButton.tonal(
      onPressed: () => onAddWater(amount),
      child: Text(label),
    );
  }
}

/// Geçmiş tüketim satır bileşeni (< 30 satır)
class WaterHistoryTile extends StatelessWidget {
  final WaterLogEntry entry;

  const WaterHistoryTile({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                '+${entry.amountMl} ml',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
            ],
          ),
          Text(
            timeStr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

/// Geçmiş tüketim listesi bölümü (< 40 satır)
class WaterHistorySection extends StatelessWidget {
  final List<WaterLogEntry> history;

  const WaterHistorySection({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Henüz su girişi yapılmadı.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bugünkü Tüketimler',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        ...history.take(4).map((entry) => WaterHistoryTile(entry: entry)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. VIEW KATMANI (lib/features/water_tracker/view/water_tracker_view.dart)
// Kural: StatelessWidget / StatefulWidget yaşam döngüsü, build < 40 satır
// -----------------------------------------------------------------------------

/// Susadım Su Takibi Ana Ekranı
class SampleWaterTrackerView extends StatefulWidget {
  const SampleWaterTrackerView({super.key});

  @override
  State<SampleWaterTrackerView> createState() => _SampleWaterTrackerViewState();
}

class _SampleWaterTrackerViewState extends State<SampleWaterTrackerView> {
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
        title: const Text('Su Takibi (Susadım)'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ValueListenableBuilder<WaterTrackerState>(
            valueListenable: _controller.stateNotifier,
            builder: (context, state, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WaterProgressRingCard(state: state),
                  const SizedBox(height: 20),
                  WaterQuickAddButtons(
                    onAddWater: _controller.addWater,
                    onReset: _controller.resetWater,
                  ),
                  const SizedBox(height: 24),
                  WaterHistorySection(history: state.history),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. UYGULAMA GİRİŞ NOKTASI (İsteğe bağlı önizleme ve test)
// -----------------------------------------------------------------------------

void main() {
  runApp(const SusadimSampleApp());
}

class SusadimSampleApp extends StatelessWidget {
  const SusadimSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D0F14), // Obsidian dark
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF), // Neon cyan accent
          brightness: Brightness.dark,
        ),
      ),
      home: const SampleWaterTrackerView(),
    );
  }
}
