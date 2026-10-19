import 'package:flutter/foundation.dart';

/// Öğün ve besin tüketim kaydı modeli.
@immutable
class MealEntry {
  const MealEntry({
    required this.id,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.timestamp,
    this.proteinGrams = 0,
    this.carbsGrams = 0,
    this.fatGrams = 0,
  });

  final String id;
  final String name;
  final String mealType;
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final DateTime timestamp;

  MealEntry copyWith({
    String? id,
    String? name,
    String? mealType,
    int? calories,
    int? proteinGrams,
    int? carbsGrams,
    int? fatGrams,
    DateTime? timestamp,
  }) {
    return MealEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Günlük kalori alımı ve makro besin hedefini hesaplayan model.
@immutable
class DailyCalorieIntakeGoal {
  const DailyCalorieIntakeGoal({
    required this.targetCalories,
    required this.consumedCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  final int targetCalories;
  final int consumedCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;

  int get remainingCalories {
    final int diff = targetCalories - consumedCalories;
    return diff < 0 ? 0 : diff;
  }

  double get progressPercentage {
    if (targetCalories <= 0) return 0.0;
    return (consumedCalories / targetCalories).clamp(0.0, 1.0);
  }

  bool get isTargetReached => consumedCalories >= targetCalories;
}
