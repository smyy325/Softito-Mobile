import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/meal_entry.dart';

/// Alınan kalori hedefi ve dairesel ilerleme kartı.
class CalorieIntakeCard extends StatelessWidget {
  const CalorieIntakeCard({
    required this.goal,
    super.key,
  });

  final DailyCalorieIntakeGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              const _RingBg(),
              _RingActive(percentage: goal.progressPercentage),
              _RingText(goal: goal),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingBg extends StatelessWidget {
  const _RingBg();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 180,
      height: 180,
      child: CircularProgressIndicator(
        value: 1.0,
        strokeWidth: 14,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.obsidianElevated),
      ),
    );
  }
}

class _RingActive extends StatelessWidget {
  const _RingActive({required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: CircularProgressIndicator(
        value: percentage,
        strokeWidth: 14,
        strokeCap: StrokeCap.round,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonAmber),
      ),
    );
  }
}

class _RingText extends StatelessWidget {
  const _RingText({required this.goal});

  final DailyCalorieIntakeGoal goal;

  @override
  Widget build(BuildContext context) {
    final int percentInt = (goal.progressPercentage * 100).toInt();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.restaurant_rounded,
          color: AppColors.neonAmber,
          size: 32,
        ),
        const SizedBox(height: 6),
        Text(
          '${goal.consumedCalories} kcal',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          '%$percentInt / ${goal.targetCalories} kcal',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
