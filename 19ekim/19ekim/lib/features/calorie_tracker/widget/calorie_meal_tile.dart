import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/calorie_model.dart';

class CalorieMealTile extends StatelessWidget {
  final MealEntry meal;
  final VoidCallback onDelete;

  const CalorieMealTile({
    super.key,
    required this.meal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _MealTypeIcon(mealType: meal.mealType),
          const SizedBox(width: 14),
          Expanded(child: _MealInfo(meal: meal)),
          _CalorieAndAction(calories: meal.calories, onDelete: onDelete),
        ],
      ),
    );
  }
}

class _MealTypeIcon extends StatelessWidget {
  final String mealType;

  const _MealTypeIcon({required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.neonLime.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.restaurant_rounded,
        color: AppColors.neonLime,
        size: 20,
      ),
    );
  }
}

class _MealInfo extends StatelessWidget {
  final MealEntry meal;

  const _MealInfo({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meal.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${meal.mealType} • P: ${meal.protein}g  K: ${meal.carbs}g  Y: ${meal.fat}g',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _CalorieAndAction extends StatelessWidget {
  final int calories;
  final VoidCallback onDelete;

  const _CalorieAndAction({required this.calories, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$calories kcal',
          style: const TextStyle(
            color: AppColors.neonLime,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 18),
          color: AppColors.textMuted,
          onPressed: onDelete,
          splashRadius: 18,
        ),
      ],
    );
  }
}
