import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Aylık kan bağışı istatistiklerini harici paket kullanmadan
/// yerel Flutter bileşenleri ve CustomPainter ile çizen sütun grafiği.
class MonthlyDonationChart extends StatelessWidget {
  final List<int> monthlyData;

  const MonthlyDonationChart({
    super.key,
    required this.monthlyData,
  });

  static const List<String> _months = [
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
  ];

  @override
  Widget build(BuildContext context) {
    final maxVal = monthlyData.isEmpty ? 1 : math.max(1, monthlyData.reduce(math.max));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ChartHeader(),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  math.min(12, monthlyData.length),
                  (index) => _BarColumn(
                    label: _months[index],
                    value: monthlyData[index],
                    maxVal: maxVal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartHeader extends StatelessWidget {
  const _ChartHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.bar_chart_rounded, color: context.colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Aylık Bağış Dağılımı',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _BarColumn extends StatelessWidget {
  final String label;
  final int value;
  final int maxVal;

  const _BarColumn({
    required this.label,
    required this.value,
    required this.maxVal,
  });

  @override
  Widget build(BuildContext context) {
    final heightRatio = (value / maxVal).clamp(0.06, 1.0);
    final isDonated = value > 0;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _BarValueHeader(value: value, isDonated: isDonated),
          const SizedBox(height: 4),
          _BarPillar(heightRatio: heightRatio, isDonated: isDonated),
          const SizedBox(height: 6),
          _BarLabel(label: label, isDonated: isDonated),
        ],
      ),
    );
  }
}

class _BarValueHeader extends StatelessWidget {
  final int value;
  final bool isDonated;

  const _BarValueHeader({required this.value, required this.isDonated});

  @override
  Widget build(BuildContext context) {
    if (!isDonated) return const SizedBox(height: 14);
    return Text(
      '$value',
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _BarPillar extends StatelessWidget {
  final double heightRatio;
  final bool isDonated;

  const _BarPillar({required this.heightRatio, required this.isDonated});

  @override
  Widget build(BuildContext context) {
    final color = isDonated
        ? context.colorScheme.primary
        : context.colorScheme.outlineVariant;

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: heightRatio,
          widthFactor: 0.55,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarLabel extends StatelessWidget {
  final String label;
  final bool isDonated;

  const _BarLabel({required this.label, required this.isDonated});

  @override
  Widget build(BuildContext context) {
    final color = isDonated
        ? context.colorScheme.onSurface
        : context.colorScheme.onSurfaceVariant;

    return Text(
      label,
      style: context.textTheme.labelSmall?.copyWith(color: color, fontSize: 10),
    );
  }
}

