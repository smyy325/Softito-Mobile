import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/calorie_tracker_controller.dart';
import '../widget/add_meal_sheet.dart';
import '../widget/calorie_intake_card.dart';
import '../widget/macro_nutrients_row.dart';
import '../widget/meal_history_section.dart';
import '../widget/quick_meal_presets.dart';

/// Beslenme ve kalori takip modülü ana ekranı.
class CalorieTrackerView extends StatelessWidget {
  const CalorieTrackerView({
    required this.controller,
    super.key,
  });

  final CalorieTrackerController controller;

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
                  _CalorieHeader(
                    onAddCustom: () => AddMealSheet.show(
                      context,
                      onAdd: controller.addMeal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CalorieIntakeCard(goal: controller.goal),
                  const SizedBox(height: 20),
                  MacroNutrientsRow(goal: controller.goal),
                  const SizedBox(height: 24),
                  QuickMealPresets(onAddPreset: controller.addQuickMeal),
                  const SizedBox(height: 28),
                  MealHistorySection(
                    meals: controller.meals,
                    onDeleteMeal: controller.removeMeal,
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

class _CalorieHeader extends StatelessWidget {
  const _CalorieHeader({required this.onAddCustom});

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
              'BESLENME & MAKRO',
              style: TextStyle(
                color: AppColors.neonAmber,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Kalori Alımı',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.add_rounded, color: AppColors.neonAmber),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.obsidianSurface,
          ),
          onPressed: onAddCustom,
        ),
      ],
    );
  }
}
