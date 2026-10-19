import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_log.dart';

/// Günlük su istatistiklerini gösteren mini kartlar satırı.
class WaterStatsRow extends StatelessWidget {
  const WaterStatsRow({
    required this.goal,
    super.key,
  });

  final DailyWaterGoal goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _StatCard(
            title: 'Kalan',
            value: '${goal.remainingMl} ml',
            icon: Icons.hourglass_bottom_rounded,
            accentColor: AppColors.neonCyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'Hedef',
            value: '${goal.targetMl} ml',
            icon: Icons.flag_rounded,
            accentColor: AppColors.neonLime,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'Durum',
            value: goal.isCompleted ? 'Tamam!' : 'Devam',
            icon: goal.isCompleted
                ? Icons.check_circle_rounded
                : Icons.trending_up_rounded,
            accentColor: goal.isCompleted
                ? AppColors.neonEmerald
                : AppColors.neonAmber,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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
