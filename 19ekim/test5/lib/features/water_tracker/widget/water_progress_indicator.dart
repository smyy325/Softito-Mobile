import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_log.dart';

/// Neon ışıltılı dairesel su ilerleme göstergesi.
class WaterProgressIndicator extends StatelessWidget {
  const WaterProgressIndicator({
    required this.goal,
    super.key,
  });

  final DailyWaterGoal goal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const _ProgressBackgroundRing(),
            _ProgressActiveRing(percentage: goal.progressPercentage),
            _ProgressCenterContent(goal: goal),
          ],
        ),
      ),
    );
  }
}

class _ProgressBackgroundRing extends StatelessWidget {
  const _ProgressBackgroundRing();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        value: 1.0,
        strokeWidth: 14,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.obsidianElevated,
        ),
      ),
    );
  }
}

class _ProgressActiveRing extends StatelessWidget {
  const _ProgressActiveRing({required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        value: percentage,
        strokeWidth: 14,
        strokeCap: StrokeCap.round,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
      ),
    );
  }
}

class _ProgressCenterContent extends StatelessWidget {
  const _ProgressCenterContent({required this.goal});

  final DailyWaterGoal goal;

  @override
  Widget build(BuildContext context) {
    final int percentInt = (goal.progressPercentage * 100).toInt();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.water_drop_rounded,
          color: AppColors.neonCyan,
          size: 32,
        ),
        const SizedBox(height: 6),
        Text(
          '${goal.consumedMl} ml',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          '%$percentInt / ${goal.targetMl} ml',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
