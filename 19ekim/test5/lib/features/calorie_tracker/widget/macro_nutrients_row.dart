import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/meal_entry.dart';

/// Protein, Karbonhidrat ve Yağ makro besin özet kartları satırı.
class MacroNutrientsRow extends StatelessWidget {
  const MacroNutrientsRow({
    required this.goal,
    super.key,
  });

  final DailyCalorieIntakeGoal goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _MacroCard(
            title: 'Protein',
            value: '${goal.totalProtein}g',
            icon: Icons.fitness_center_rounded,
            accentColor: AppColors.neonCyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MacroCard(
            title: 'Karb',
            value: '${goal.totalCarbs}g',
            icon: Icons.grain_rounded,
            accentColor: AppColors.neonAmber,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MacroCard(
            title: 'Yağ',
            value: '${goal.totalFat}g',
            icon: Icons.bubble_chart_rounded,
            accentColor: AppColors.neonCoral,
          ),
        ),
      ],
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: accentColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
