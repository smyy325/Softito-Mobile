import 'package:flutter/foundation.dart';

/// Egzersiz ve aktivite veri modeli.
@immutable
class WorkoutItem {
  const WorkoutItem({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
    this.intensity = 'Orta',
  });

  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;
  final String intensity;

  WorkoutItem copyWith({
    String? id,
    String? title,
    String? category,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
    String? intensity,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
      intensity: intensity ?? this.intensity,
    );
  }
}

/// Günlük yakılan kalori hedefini ve ilerlemeyi hesaplayan model.
@immutable
class DailyWorkoutGoal {
  const DailyWorkoutGoal({
    required this.targetCalories,
    required this.burnedCalories,
  });

  final int targetCalories;
  final int burnedCalories;

  int get remainingCalories {
    final int diff = targetCalories - burnedCalories;
    return diff < 0 ? 0 : diff;
  }

  double get progressPercentage {
    if (targetCalories <= 0) return 0.0;
    return (burnedCalories / targetCalories).clamp(0.0, 1.0);
  }

  bool get isCompleted => burnedCalories >= targetCalories;
}
