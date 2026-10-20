import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

/// Genel kan istatistiklerini (Toplam stok, kritik gruplar, günlük ihtiyaç)
/// özetleyen 4'lü metrik kartı.
class BloodStatsCard extends StatelessWidget {
  final int totalUnits;
  final int criticalCount;
  final int dailyNeed;
  final int donationsToday;

  const BloodStatsCard({
    super.key,
    required this.totalUnits,
    required this.criticalCount,
    required this.dailyNeed,
    required this.donationsToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopMetricsRow(
          totalUnits: totalUnits,
          criticalCount: criticalCount,
        ),
        const SizedBox(height: 12),
        _BottomMetricsRow(
          dailyNeed: dailyNeed,
          donationsToday: donationsToday,
        ),
      ],
    );
  }
}

class _TopMetricsRow extends StatelessWidget {
  final int totalUnits;
  final int criticalCount;

  const _TopMetricsRow({required this.totalUnits, required this.criticalCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            title: 'Toplam Stok',
            value: '$totalUnits Ünite',
            icon: Icons.inventory_rounded,
            accentColor: context.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricTile(
            title: 'Kritik Seviye',
            value: '$criticalCount Grup',
            icon: Icons.warning_amber_rounded,
            accentColor: AppColors.statusCritical,
          ),
        ),
      ],
    );
  }
}

class _BottomMetricsRow extends StatelessWidget {
  final int dailyNeed;
  final int donationsToday;

  const _BottomMetricsRow({required this.dailyNeed, required this.donationsToday});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            title: 'Günlük İhtiyaç',
            value: '$dailyNeed Ünite',
            icon: Icons.local_hospital_rounded,
            accentColor: context.colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricTile(
            title: 'Bugünkü Bağış',
            value: '$donationsToday Ünite',
            icon: Icons.volunteer_activism_rounded,
            accentColor: AppColors.statusSuccess,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onSurfaceVariant)),
              Icon(icon, size: 18, color: accentColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
