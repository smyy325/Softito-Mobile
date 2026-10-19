import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final int totalMinutes;
  final int targetMinutes;
  final int totalCalories;
  final int targetCalories;

  const WorkoutSummaryCard({
    super.key,
    required this.totalMinutes,
    required this.targetMinutes,
    required this.totalCalories,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonOrange.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _MetricItem(
              icon: Icons.timer_outlined,
              iconColor: AppColors.neonOrange,
              title: 'Aktif Süre',
              value: '$totalMinutes',
              unit: 'dk',
              subtitle: 'Hedef: $targetMinutes dk',
            ),
          ),
          Container(
            height: 50,
            width: 1,
            color: AppColors.cardBorder,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: _MetricItem(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.neonFlame,
              title: 'Yakılan Kalori',
              value: '$totalCalories',
              unit: 'kcal',
              subtitle: 'Hedef: $targetCalories kcal',
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;
  final String subtitle;

  const _MetricItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: iconColor,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
