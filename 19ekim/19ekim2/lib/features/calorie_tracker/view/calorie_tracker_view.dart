import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/calorie_controller.dart';
import '../models/calorie_model.dart';
import '../widget/calorie_add_dialog.dart';
import '../widget/calorie_meal_tile.dart';
import '../widget/calorie_rings_card.dart';

class CalorieTrackerView extends StatelessWidget {
  final CalorieController controller;

  const CalorieTrackerView({super.key, required this.controller});

  void _openAddMealSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CalorieAddBottomSheet(onAdd: controller.addMeal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalori & Beslenme'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: AppColors.neonLime,
            tooltip: 'Öğün Ekle',
            onPressed: () => _openAddMealSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CalorieOverviewSection(controller: controller),
            const SizedBox(height: 28),
            _MealListHeader(controller: controller),
            const SizedBox(height: 12),
            _MealListSection(controller: controller),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.neonLime,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.restaurant_rounded),
        label: const Text(
          'Öğün Ekle',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () => _openAddMealSheet(context),
      ),
    );
  }
}

class _CalorieOverviewSection extends StatelessWidget {
  final CalorieController controller;

  const _CalorieOverviewSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MealEntry>>(
      valueListenable: controller.meals,
      builder: (context, list, _) {
        return CalorieRingsCard(
          totalCalories: controller.totalCalories,
          goalCalories: controller.dailyGoal.value,
          protein: controller.totalProtein,
          carbs: controller.totalCarbs,
          fat: controller.totalFat,
        );
      },
    );
  }
}

class _MealListHeader extends StatelessWidget {
  final CalorieController controller;

  const _MealListHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Günlük Öğünler',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        ValueListenableBuilder<List<MealEntry>>(
          valueListenable: controller.meals,
          builder: (context, list, _) {
            return Text(
              '${list.length} Öğün Kaydedildi',
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

class _MealListSection extends StatelessWidget {
  final CalorieController controller;

  const _MealListSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MealEntry>>(
      valueListenable: controller.meals,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Henüz bir öğün eklenmedi.\nBugünkü öğünlerini kaydet!',
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
            final meal = list[index];
            return CalorieMealTile(
              meal: meal,
              onDelete: () => controller.removeMeal(meal.id),
            );
          },
        );
      },
    );
  }
}
