import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı egzersiz ekleme hazır şablonları.
class WorkoutQuickPresets extends StatelessWidget {
  const WorkoutQuickPresets({
    required this.onAddPreset,
    super.key,
  });

  final void Function({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) onAddPreset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Hızlı Egzersiz Ekle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _PresetTile(
                title: 'Koşu',
                subtitle: '20 dk • 180 kcal',
                icon: Icons.directions_run_rounded,
                accentColor: AppColors.neonLime,
                onTap: () => onAddPreset(
                  title: 'Açık Hava Koşu',
                  category: 'Kardiyo',
                  durationMinutes: 20,
                  caloriesBurned: 180,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PresetTile(
                title: 'Ağırlık',
                subtitle: '40 dk • 240 kcal',
                icon: Icons.fitness_center_rounded,
                accentColor: AppColors.neonCyan,
                onTap: () => onAddPreset(
                  title: 'Ağırlık & Kuvvet',
                  category: 'Fitness',
                  durationMinutes: 40,
                  caloriesBurned: 240,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PresetTile(
                title: 'HIIT',
                subtitle: '15 dk • 150 kcal',
                icon: Icons.flash_on_rounded,
                accentColor: AppColors.neonCoral,
                onTap: () => onAddPreset(
                  title: 'HIIT Yağ Yakımı',
                  category: 'HIIT',
                  durationMinutes: 15,
                  caloriesBurned: 150,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PresetTile extends StatelessWidget {
  const _PresetTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.obsidianCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.obsidianBorder, width: 1),
          ),
          child: Column(
            children: <Widget>[
              Icon(icon, color: accentColor, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
