import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CalorieRingsCard extends StatelessWidget {
  final int totalCalories;
  final int goalCalories;
  final int protein;
  final int carbs;
  final int fat;

  const CalorieRingsCard({
    super.key,
    required this.totalCalories,
    required this.goalCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio =
        goalCalories > 0 ? (totalCalories / goalCalories).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonLime.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _CalorieProgressRow(
            total: totalCalories,
            goal: goalCalories,
            ratio: ratio,
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 14),
          _MacroBreakdownRow(protein: protein, carbs: carbs, fat: fat),
        ],
      ),
    );
  }
}

class _CalorieProgressRow extends StatelessWidget {
  final int total;
  final int goal;
  final double ratio;

  const _CalorieProgressRow({
    required this.total,
    required this.goal,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alınan Kalori',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$total',
                    style: const TextStyle(
                      color: AppColors.neonLime,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ $goal kcal',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MacroBreakdownRow extends StatelessWidget {
  final int protein;
  final int carbs;
  final int fat;

  const _MacroBreakdownRow({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _MacroItem(
          label: 'Protein',
          amount: '${protein}g',
          color: AppColors.neonCyan,
        ),
        _MacroItem(
          label: 'Karbonhidrat',
          amount: '${carbs}g',
          color: AppColors.neonOrange,
        ),
        _MacroItem(
          label: 'Yağ',
          amount: '${fat}g',
          color: AppColors.neonFlame,
        ),
      ],
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _MacroItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
