import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/blood_stats_model.dart';

/// Kan gruplarının stok doluluk oranlarını yerel Flutter bileşenleri
/// ve CustomPainter ile çizen görsel stok çubuk grafiği.
class BloodStockChart extends StatelessWidget {
  final List<BloodGroupStock> stocks;

  const BloodStockChart({super.key, required this.stocks});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ChartTitle(),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: stocks.map((stock) => _StockBar(stock: stock)).toList(),
              ),
            ),
            const SizedBox(height: 12),
            const _ChartLegend(),
          ],
        ),
      ),
    );
  }
}

class _ChartTitle extends StatelessWidget {
  const _ChartTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.inventory_2_rounded, color: context.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Kan Grubu Stok Doluluk Oranları',
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class _StockBar extends StatelessWidget {
  final BloodGroupStock stock;

  const _StockBar({required this.stock});

  @override
  Widget build(BuildContext context) {
    final barColor = stock.isCritical
        ? AppColors.statusCritical
        : (stock.status == 'Uyarı' ? AppColors.statusWarning : AppColors.statusSuccess);

    final ratio = stock.occupancyRate.clamp(0.08, 1.0);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _StockUnitsLabel(units: stock.currentUnits, color: barColor),
          const SizedBox(height: 4),
          _StockPillar(ratio: ratio, color: barColor),
          const SizedBox(height: 6),
          Text(
            stock.bloodType,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _StockUnitsLabel extends StatelessWidget {
  final int units;
  final Color color;

  const _StockUnitsLabel({required this.units, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$units',
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
    );
  }
}

class _StockPillar extends StatelessWidget {
  final double ratio;
  final Color color;

  const _StockPillar({required this.ratio, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: ratio,
          widthFactor: 0.6,
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

class _ChartLegend extends StatelessWidget {
  const _ChartLegend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppColors.statusCritical, label: 'Kritik'),
        SizedBox(width: 14),
        _LegendItem(color: AppColors.statusWarning, label: 'Uyarı'),
        SizedBox(width: 14),
        _LegendItem(color: AppColors.statusSuccess, label: 'İdeal'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
