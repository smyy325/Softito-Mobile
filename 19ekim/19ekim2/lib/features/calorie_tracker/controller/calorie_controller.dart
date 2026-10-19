import 'package:flutter/foundation.dart';
import '../models/calorie_model.dart';

class CalorieController {
  final ValueNotifier<int> dailyGoal = ValueNotifier<int>(2200);

  final ValueNotifier<List<MealEntry>> meals =
      ValueNotifier<List<MealEntry>>([
    MealEntry(
      id: 'm1',
      name: 'Yulaf Kasesi & Muz & Fıstık Ezmesi',
      mealType: 'Kahvaltı',
      calories: 450,
      protein: 18,
      carbs: 65,
      fat: 14,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    MealEntry(
      id: 'm2',
      name: 'Izgara Tavuk Göğsü & Basmati Pirinç',
      mealType: 'Öğle Yemeği',
      calories: 620,
      protein: 52,
      carbs: 70,
      fat: 10,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ]);

  int get totalCalories {
    return meals.value.fold(0, (sum, item) => sum + item.calories);
  }

  int get totalProtein {
    return meals.value.fold(0, (sum, item) => sum + item.protein);
  }

  int get totalCarbs {
    return meals.value.fold(0, (sum, item) => sum + item.carbs);
  }

  int get totalFat {
    return meals.value.fold(0, (sum, item) => sum + item.fat);
  }

  void addMeal({
    required String name,
    required String mealType,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
  }) {
    final entry = MealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      mealType: mealType,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      timestamp: DateTime.now(),
    );
    meals.value = [entry, ...meals.value];
  }

  void removeMeal(String id) {
    meals.value = meals.value.where((element) => element.id != id).toList();
  }

  void dispose() {
    dailyGoal.dispose();
    meals.dispose();
  }
}
