import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/meal_entry.dart';

/// Günlük öğün ve besin tüketim geçmişi.
class MealHistorySection extends StatelessWidget {
  const MealHistorySection({
    required this.meals,
    required this.onDeleteMeal,
    super.key,
  });

  final List<MealEntry> meals;
  final void Function(String id) onDeleteMeal;

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const _EmptyMealHistory();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Bugünkü Öğünler',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (BuildContext context, int index) {
            final MealEntry item = meals[index];
            return _MealTile(
              item: item,
              onDelete: () => onDeleteMeal(item.id),
            );
          },
        ),
      ],
    );
  }
}

class _EmptyMealHistory extends StatelessWidget {
  const _EmptyMealHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: const Column(
        children: <Widget>[
          Icon(Icons.dining_rounded, color: AppColors.textMuted, size: 36),
          SizedBox(height: 8),
          Text(
            'Henüz öğün kaydı eklenmedi.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  const _MealTile({
    required this.item,
    required this.onDelete,
  });

  final MealEntry item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.obsidianSurface,
            child: Icon(Icons.restaurant, color: AppColors.neonAmber, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${item.mealType} • ${item.proteinGrams}g P • ${item.carbsGrams}g K • ${item.fatGrams}g Y',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${item.calories} kcal',
            style: const TextStyle(
              color: AppColors.neonAmber,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.textMuted,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
