import 'package:flutter/foundation.dart';
import '../models/workout_item.dart';

/// Flutter çekirdek ChangeNotifier API'si ile egzersiz ve kalori durum yöneticisi.
class WorkoutController extends ChangeNotifier {
  WorkoutController({int initialTargetCalories = 500})
      : _targetCalories = initialTargetCalories;

  int _targetCalories;
  final List<WorkoutItem> _workouts = <WorkoutItem>[];

  int get targetCalories => _targetCalories;

  List<WorkoutItem> get workouts => List<WorkoutItem>.unmodifiable(_workouts);

  int get totalBurnedCalories => _workouts.fold<int>(
        0,
        (int sum, WorkoutItem item) => sum + item.caloriesBurned,
      );

  int get totalDurationMinutes => _workouts.fold<int>(
        0,
        (int sum, WorkoutItem item) => sum + item.durationMinutes,
      );

  DailyWorkoutGoal get goal => DailyWorkoutGoal(
        targetCalories: _targetCalories,
        burnedCalories: totalBurnedCalories,
      );

  void addWorkout(WorkoutItem workout) {
    _workouts.insert(0, workout);
    notifyListeners();
  }

  void addQuickWorkout({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
    String intensity = 'Orta',
  }) {
    final WorkoutItem item = WorkoutItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      category: category,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
      intensity: intensity,
    );
    addWorkout(item);
  }

  void removeWorkout(String id) {
    _workouts.removeWhere((WorkoutItem item) => item.id == id);
    notifyListeners();
  }

  void setTargetCalories(int newTarget) {
    if (newTarget < 100) return;
    _targetCalories = newTarget;
    notifyListeners();
  }

  void resetToday() {
    _workouts.clear();
    notifyListeners();
  }
}
