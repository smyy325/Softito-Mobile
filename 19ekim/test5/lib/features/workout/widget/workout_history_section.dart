import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_item.dart';

/// Günlük yapılan egzersiz kayıtları listesi.
class WorkoutHistorySection extends StatelessWidget {
  const WorkoutHistorySection({
    required this.workouts,
    required this.onDeleteWorkout,
    super.key,
  });

  final List<WorkoutItem> workouts;
  final void Function(String id) onDeleteWorkout;

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const _EmptyWorkoutHistory();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Bugünkü Antrenmanlar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workouts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (BuildContext context, int index) {
            final WorkoutItem item = workouts[index];
            return _WorkoutTile(
              item: item,
              onDelete: () => onDeleteWorkout(item.id),
            );
          },
        ),
      ],
    );
  }
}

class _EmptyWorkoutHistory extends StatelessWidget {
  const _EmptyWorkoutHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: const Column(
        children: <Widget>[
          Icon(Icons.fitness_center_rounded,
              color: AppColors.textMuted, size: 36),
          SizedBox(height: 8),
          Text(
            'Henüz antrenman kaydı eklenmedi.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  const _WorkoutTile({
    required this.item,
    required this.onDelete,
  });

  final WorkoutItem item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.obsidianSurface,
            child: Icon(Icons.bolt_rounded, color: AppColors.neonLime, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${item.category} • ${item.durationMinutes} dk',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-${item.caloriesBurned} kcal',
            style: const TextStyle(
              color: AppColors.neonCoral,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.textMuted,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
