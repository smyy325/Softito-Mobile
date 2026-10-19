import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

class WorkoutItemTile extends StatelessWidget {
  final WorkoutExercise workout;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const WorkoutItemTile({
    super.key,
    required this.workout,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: workout.isCompleted
              ? AppColors.cardBorder
              : AppColors.neonOrange.withAlpha(80),
        ),
      ),
      child: Row(
        children: [
          _CompleteCheckbox(isCompleted: workout.isCompleted, onTap: onToggle),
          const SizedBox(width: 14),
          Expanded(child: _ExerciseDetails(workout: workout)),
          _ExerciseMetrics(
            duration: workout.durationMinutes,
            calories: workout.caloriesBurned,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            color: AppColors.textMuted,
            onPressed: onDelete,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}

class _CompleteCheckbox extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const _CompleteCheckbox({required this.isCompleted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.neonLime.withAlpha(35)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCompleted ? AppColors.neonLime : AppColors.textMuted,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check_rounded, color: AppColors.neonLime, size: 18)
            : null,
      ),
    );
  }
}

class _ExerciseDetails extends StatelessWidget {
  final WorkoutExercise workout;

  const _ExerciseDetails({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workout.name,
          style: TextStyle(
            color: workout.isCompleted
                ? AppColors.textPrimary
                : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            decoration:
                workout.isCompleted ? null : TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            workout.category,
            style: const TextStyle(
              color: AppColors.neonOrange,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseMetrics extends StatelessWidget {
  final int duration;
  final int calories;

  const _ExerciseMetrics({required this.duration, required this.calories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$duration dk',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '$calories kcal',
          style: const TextStyle(
            color: AppColors.neonFlame,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
