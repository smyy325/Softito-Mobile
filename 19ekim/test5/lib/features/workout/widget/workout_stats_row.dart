import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_item.dart';

/// Egzersiz istatistik mini kartları satırı.
class WorkoutStatsRow extends StatelessWidget {
  const WorkoutStatsRow({
    required this.goal,
    required this.totalMinutes,
    super.key,
  });

  final DailyWorkoutGoal goal;
  final int totalMinutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _WorkoutStatCard(
            title: 'Toplam Süre',
            value: '$totalMinutes dk',
            icon: Icons.timer_outlined,
            accentColor: AppColors.neonLime,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _WorkoutStatCard(
            title: 'Kalan Kalori',
            value: '${goal.remainingCalories} kcal',
            icon: Icons.flash_on_rounded,
            accentColor: AppColors.neonCoral,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _WorkoutStatCard(
            title: 'Hedef Durumu',
            value: goal.isCompleted ? 'Tamam!' : 'Sürüyor',
            icon: goal.isCompleted
                ? Icons.workspace_premium_rounded
                : Icons.directions_run_rounded,
            accentColor: goal.isCompleted
                ? AppColors.neonEmerald
                : AppColors.neonAmber,
          ),
        ),
      ],
    );
  }
}

class _WorkoutStatCard extends StatelessWidget {
  const _WorkoutStatCard({
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
