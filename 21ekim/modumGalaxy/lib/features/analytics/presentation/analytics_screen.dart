import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notes/models/planet_model.dart';
import '../../notes/providers/notes_provider.dart';

/// 9. Aylık Duygu Analizi Ekranı (AnalyticsScreen)
/// Son 30 günün verilerini tarayan frekans analizi algoritması çıktısı,
/// baskın gezegen illüstrasyonu, duygu dağılım grafiği ve özel farkındalık notu.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notesProvider = context.watch<NotesProvider>();
    final analysis = notesProvider.calculateMonthlyAnalysis();

    final hasData = analysis['hasData'] as bool;
    final dominantPlanet = analysis['dominantPlanet'] as PlanetModel?;
    final dominantMood = analysis['dominantMood'] as String;
    final insight = analysis['insight'] as String;
    final totalNotes = analysis['totalNotes'] as int;
    final freqMap = (analysis['frequencyMap'] as Map<String, int>?) ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aylık Galaksi Analizi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık & Açıklama
              Text(
                '30 Günlük Duygu Frekansı',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ruh halinin galaksideki yansımalarını ve baskın gezegenini incele.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              if (!hasData)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.radar_rounded,
                          size: 64,
                          color: colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Henüz Yeterli Veri Yok',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          insight,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // 🌟 BASKIN GEZEGEN İLLÜSTRASYON KARTI
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primaryContainer.withValues(alpha: 0.5),
                        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Başlık rozeti
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Baskın Gezegenin',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Büyük Gezegen Görseli
                      if (dominantPlanet != null)
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: dominantPlanet.primaryColor.withValues(alpha: 0.35),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            dominantPlanet.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),

                      const SizedBox(height: 16),

                      Text(
                        dominantPlanet?.name ?? '',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Baskın Mod: $dominantMood',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🌟 ÖZEL FARKINDALIK VE REHBERLİK NOTU
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lightbulb_rounded,
                                color: colorScheme.onSecondaryContainer,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Aylık Farkındalık Notu',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          insight,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 📊 DUYGU FREKANS DAĞILIMI LİSTESİ (Map<String, int> görselleştirmesi)
                Text(
                  'Gezegen Frekans Dağılımı',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ...notesProvider.planets.map((planet) {
                  final count = freqMap[planet.id] ?? 0;
                  final percentage = totalNotes > 0 ? (count / totalNotes) : 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: Image.asset(planet.imagePath),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  planet.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                planet.moodLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$count not',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: percentage,
                              minHeight: 6,
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              color: planet.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
