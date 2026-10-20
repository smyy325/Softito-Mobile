import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/blood_stats_model.dart';

/// Her bir kan grubunun doluluk oranını ve simülasyon butonlarını içeren satır kartı.
class BloodStockRowItem extends StatelessWidget {
  final BloodGroupStock stock;
  final VoidCallback onAddUnit;
  final VoidCallback onDispatchUnit;

  const BloodStockRowItem({
    super.key,
    required this.stock,
    required this.onAddUnit,
    required this.onDispatchUnit,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = stock.isCritical
        ? AppColors.statusCritical
        : (stock.status == 'Uyarı' ? AppColors.statusWarning : AppColors.statusSuccess);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          children: [
            _RowHeader(stock: stock, statusColor: statusColor),
            const SizedBox(height: 8),
            _ProgressTrack(progress: stock.occupancyRate, color: statusColor),
            const SizedBox(height: 8),
            _RowActions(
              stock: stock,
              onAdd: onAddUnit,
              onDispatch: onDispatchUnit,
            ),
          ],
        ),
      ),
    );
  }
}

class _RowHeader extends StatelessWidget {
  final BloodGroupStock stock;
  final Color statusColor;

  const _RowHeader({required this.stock, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              stock.bloodType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                stock.status,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ],
        ),
        Text(
          '${stock.currentUnits} / ${stock.capacityUnits} Ünite',
          style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  final double progress;
  final Color color;

  const _ProgressTrack({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: context.colorScheme.outlineVariant,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  final BloodGroupStock stock;
  final VoidCallback onAdd;
  final VoidCallback onDispatch;

  const _RowActions({
    required this.stock,
    required this.onAdd,
    required this.onDispatch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Kritik Eşik: ${stock.minRequiredUnits} ünite',
          style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
        Row(
          children: [
            IconButton.filledTonal(
              iconSize: 14,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              padding: EdgeInsets.zero,
              onPressed: onDispatch,
              tooltip: 'Acil Çıkış (-1)',
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 6),
            IconButton.filled(
              iconSize: 14,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              padding: EdgeInsets.zero,
              onPressed: onAdd,
              tooltip: 'Bağış Girişi (+1)',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
