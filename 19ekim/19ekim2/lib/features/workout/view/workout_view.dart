import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/workout_controller.dart';
import '../models/workout_model.dart';
import '../widget/workout_add_dialog.dart';
import '../widget/workout_item_tile.dart';
import '../widget/workout_summary_card.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({super.key, required this.controller});

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WorkoutAddBottomSheet(onAdd: controller.addWorkout),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egzersiz & Antrenman'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: AppColors.neonOrange,
            tooltip: 'Antrenman Ekle',
            onPressed: () => _openAddSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummarySection(controller: controller),
            const SizedBox(height: 28),
            _ListHeader(controller: controller),
            const SizedBox(height: 12),
            _WorkoutListSection(controller: controller),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.neonOrange,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.fitness_center_rounded),
        label: const Text(
          'Yeni Egzersiz',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () => _openAddSheet(context),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  final WorkoutController controller;

  const _SummarySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WorkoutExercise>>(
      valueListenable: controller.workouts,
      builder: (context, list, _) {
        return WorkoutSummaryCard(
          totalMinutes: controller.totalMinutes,
          targetMinutes: controller.targetMinutes.value,
          totalCalories: controller.totalCalories,
          targetCalories: controller.targetCalories.value,
        );
      },
    );
  }
}

class _ListHeader extends StatelessWidget {
  final WorkoutController controller;

  const _ListHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Antrenman Planı',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        ValueListenableBuilder<List<WorkoutExercise>>(
          valueListenable: controller.workouts,
          builder: (context, list, _) {
            final completedCount = list.where((e) => e.isCompleted).length;
            return Text(
              '$completedCount / ${list.length} Tamamlandı',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WorkoutListSection extends StatelessWidget {
  final WorkoutController controller;

  const _WorkoutListSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WorkoutExercise>>(
      valueListenable: controller.workouts,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Bugün için planlanan egzersiz yok.\nYeni bir antrenman ekle!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final workout = list[index];
            return WorkoutItemTile(
              workout: workout,
              onToggle: () => controller.toggleComplete(workout.id),
              onDelete: () => controller.removeWorkout(workout.id),
            );
          },
        );
      },
    );
  }
}
