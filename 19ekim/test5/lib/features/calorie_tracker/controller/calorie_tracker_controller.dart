import 'package:flutter/foundation.dart';
import '../models/meal_entry.dart';

/// Flutter çekirdek ChangeNotifier API'si ile besin ve kalori takibi durum yöneticisi.
class CalorieTrackerController extends ChangeNotifier {
  CalorieTrackerController({int initialTargetCalories = 2000})
      : _targetCalories = initialTargetCalories;

  int _targetCalories;
  final List<MealEntry> _meals = <MealEntry>[];

  int get targetCalories => _targetCalories;

  List<MealEntry> get meals => List<MealEntry>.unmodifiable(_meals);

  int get totalConsumedCalories => _meals.fold<int>(
        0,
        (int sum, MealEntry item) => sum + item.calories,
      );

  int get totalProtein => _meals.fold<int>(
        0,
        (int sum, MealEntry item) => sum + item.proteinGrams,
      );

  int get totalCarbs => _meals.fold<int>(
        0,
        (int sum, MealEntry item) => sum + item.carbsGrams,
      );

  int get totalFat => _meals.fold<int>(
        0,
        (int sum, MealEntry item) => sum + item.fatGrams,
      );

  DailyCalorieIntakeGoal get goal => DailyCalorieIntakeGoal(
        targetCalories: _targetCalories,
        consumedCalories: totalConsumedCalories,
        totalProtein: totalProtein,
        totalCarbs: totalCarbs,
        totalFat: totalFat,
      );

  void addMeal(MealEntry meal) {
    _meals.insert(0, meal);
    notifyListeners();
  }

  void addQuickMeal({
    required String name,
    required String mealType,
    required int calories,
    int protein = 0,
    int carbs = 0,
    int fat = 0,
  }) {
    final MealEntry entry = MealEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      mealType: mealType,
      calories: calories,
      proteinGrams: protein,
      carbsGrams: carbs,
      fatGrams: fat,
      timestamp: DateTime.now(),
    );
    addMeal(entry);
  }

  void removeMeal(String id) {
    _meals.removeWhere((MealEntry item) => item.id == id);
    notifyListeners();
  }

  void setTargetCalories(int newTarget) {
    if (newTarget < 500) return;
    _targetCalories = newTarget;
    notifyListeners();
  }

  void resetToday() {
    _meals.clear();
    notifyListeners();
  }
}
