import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/workout_controller.dart';
import '../widget/add_workout_sheet.dart';
import '../widget/calorie_ring_card.dart';
import '../widget/workout_history_section.dart';
import '../widget/workout_quick_presets.dart';
import '../widget/workout_stats_row.dart';

/// Egzersiz ve kalori takip modülü ana ekranı.
class WorkoutView extends StatelessWidget {
  const WorkoutView({
    required this.controller,
    super.key,
  });

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _WorkoutHeaderTitle(
                    onAddCustom: () => AddWorkoutSheet.show(
                      context,
                      onAdd: controller.addWorkout,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CalorieRingCard(goal: controller.goal),
                  const SizedBox(height: 20),
                  WorkoutStatsRow(
                    goal: controller.goal,
                    totalMinutes: controller.totalDurationMinutes,
                  ),
                  const SizedBox(height: 24),
                  WorkoutQuickPresets(onAddPreset: controller.addQuickWorkout),
                  const SizedBox(height: 28),
                  WorkoutHistorySection(
                    workouts: controller.workouts,
                    onDeleteWorkout: controller.removeWorkout,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WorkoutHeaderTitle extends StatelessWidget {
  const _WorkoutHeaderTitle({required this.onAddCustom});

  final VoidCallback onAddCustom;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'GÜÇ & ENERJİ',
              style: TextStyle(
                color: AppColors.neonLime,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Egzersiz & Kalori',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.add_rounded, color: AppColors.neonLime),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.obsidianSurface,
          ),
          onPressed: onAddCustom,
        ),
      ],
    );
  }
}
