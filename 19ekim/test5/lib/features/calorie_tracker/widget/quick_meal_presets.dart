import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı öğün ekleme hazır şablonları.
class QuickMealPresets extends StatelessWidget {
  const QuickMealPresets({
    required this.onAddPreset,
    super.key,
  });

  final void Function({
    required String name,
    required String mealType,
    required int calories,
    int protein,
    int carbs,
    int fat,
  }) onAddPreset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Hızlı Öğün Ekle',
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
              child: _MealPresetTile(
                name: 'Yulaf Kasesi',
                details: '320 kcal • 12g P',
                icon: Icons.breakfast_dining_rounded,
                accentColor: AppColors.neonAmber,
                onTap: () => onAddPreset(
                  name: 'Yulaf & Meyve',
                  mealType: 'Kahvaltı',
                  calories: 320,
                  protein: 12,
                  carbs: 52,
                  fat: 6,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MealPresetTile(
                name: 'Tavuk & Pilav',
                details: '540 kcal • 42g P',
                icon: Icons.lunch_dining_rounded,
                accentColor: AppColors.neonLime,
                onTap: () => onAddPreset(
                  name: 'Izgara Tavuk & Pilav',
                  mealType: 'Öğle Yemeği',
                  calories: 540,
                  protein: 42,
                  carbs: 60,
                  fat: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MealPresetTile(
                name: 'Protein Shake',
                details: '180 kcal • 28g P',
                icon: Icons.sports_bar_rounded,
                accentColor: AppColors.neonCyan,
                onTap: () => onAddPreset(
                  name: 'Whey Protein Shake',
                  mealType: 'Ara Öğün',
                  calories: 180,
                  protein: 28,
                  carbs: 6,
                  fat: 3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MealPresetTile extends StatelessWidget {
  const _MealPresetTile({
    required this.name,
    required this.details,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String name;
  final String details;
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
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                details,
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
