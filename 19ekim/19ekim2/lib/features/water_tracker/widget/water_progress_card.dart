import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterProgressCard extends StatelessWidget {
  final int current;
  final int goal;

  const WaterProgressCard({
    super.key,
    required this.current,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final int percent = (ratio * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _ProgressRing(ratio: ratio, percent: percent),
          const SizedBox(width: 24),
          Expanded(child: _InfoColumn(current: current, goal: goal)),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double ratio;
  final int percent;

  const _ProgressRing({required this.ratio, required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: ratio,
            strokeWidth: 9,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '%$percent',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'Hedef',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final int current;
  final int goal;

  const _InfoColumn({required this.current, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Günlük Hidrasyon',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$current',
              style: const TextStyle(
                color: AppColors.neonCyan,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/ $goal ml',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neonCyan.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            current >= goal
                ? '🎉 Günlük hedefe ulaşıldı!'
                : 'Kalan: ${goal - current} ml',
            style: const TextStyle(
              color: AppColors.neonCyan,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
