import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Kan bağışı yıllık hedefini dairesel olarak çizen yerel CustomPainter bileşeni.
class DonationGoalChart extends StatelessWidget {
  final int currentUnits;
  final int goalUnits;
  final double size;

  const DonationGoalChart({
    super.key,
    required this.currentUnits,
    required this.goalUnits,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goalUnits > 0 ? (currentUnits / goalUnits).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).toInt();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RadialGoalPainter(
              progress: progress,
              primaryColor: context.colorScheme.primary,
              trackColor: context.colorScheme.outlineVariant,
            ),
          ),
          _GoalCenterInfo(
            currentUnits: currentUnits,
            goalUnits: goalUnits,
            percent: percent,
          ),
        ],
      ),
    );
  }
}

class _GoalCenterInfo extends StatelessWidget {
  final int currentUnits;
  final int goalUnits;
  final int percent;

  const _GoalCenterInfo({
    required this.currentUnits,
    required this.goalUnits,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.water_drop_rounded, color: context.colorScheme.primary, size: 28),
        const SizedBox(height: 2),
        Text(
          '$currentUnits / $goalUnits',
          style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          '%$percent Tamamlandı',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RadialGoalPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color trackColor;

  const _RadialGoalPainter({
    required this.progress,
    required this.primaryColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 14.0;

    // Arka plan iz çizgisi (Track)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // İlerleme Yayı (Progress Arc)
    final progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialGoalPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.trackColor != trackColor;
  }
}
