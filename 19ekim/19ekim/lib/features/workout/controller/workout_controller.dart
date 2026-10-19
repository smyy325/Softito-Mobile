import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController {
  final ValueNotifier<int> targetMinutes = ValueNotifier<int>(60);
  final ValueNotifier<int> targetCalories = ValueNotifier<int>(500);

  final ValueNotifier<List<WorkoutExercise>> workouts =
      ValueNotifier<List<WorkoutExercise>>([
    WorkoutExercise(
      id: 'w1',
      name: 'Sabah Koşusu (Treadmill)',
      category: 'Kardiyo',
      durationMinutes: 25,
      caloriesBurned: 220,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isCompleted: true,
    ),
    WorkoutExercise(
      id: 'w2',
      name: 'Göğüs & Kol Antrenmanı',
      category: 'Ağırlık',
      durationMinutes: 30,
      caloriesBurned: 180,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isCompleted: true,
    ),
  ]);

  int get totalMinutes {
    return workouts.value
        .where((e) => e.isCompleted)
        .fold(0, (sum, item) => sum + item.durationMinutes);
  }

  int get totalCalories {
    return workouts.value
        .where((e) => e.isCompleted)
        .fold(0, (sum, item) => sum + item.caloriesBurned);
  }

  void addWorkout({
    required String name,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    final newWorkout = WorkoutExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
      isCompleted: true,
    );
    workouts.value = [newWorkout, ...workouts.value];
  }

  void toggleComplete(String id) {
    workouts.value = workouts.value.map((e) {
      if (e.id == id) {
        return e.copyWith(isCompleted: !e.isCompleted);
      }
      return e;
    }).toList();
  }

  void removeWorkout(String id) {
    workouts.value = workouts.value.where((e) => e.id != id).toList();
  }

  void dispose() {
    targetMinutes.dispose();
    targetCalories.dispose();
    workouts.dispose();
  }
}
