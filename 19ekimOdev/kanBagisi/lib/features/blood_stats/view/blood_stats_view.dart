import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/blood_stats_controller.dart';
import '../models/blood_stats_model.dart';
import '../widget/blood_compatibility_matrix.dart';
import '../widget/blood_stats_card.dart';
import '../widget/blood_stock_chart.dart';
import '../widget/blood_stock_row_item.dart';

/// Kan stok durumu ve istatistik ekranı.
class BloodStatsView extends StatelessWidget {
  final BloodStatsController controller;

  BloodStatsView({
    super.key,
    BloodStatsController? controller,
  }) : controller = controller ?? BloodStatsController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BloodStatsModel>(
      valueListenable: controller.stateNotifier,
      builder: (context, state, _) {
        final displayedStocks = state.showCriticalOnly
            ? state.stockList.where((s) => s.isCritical).toList()
            : state.stockList;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BloodStatsCard(
              totalUnits: state.totalUnits,
              criticalCount: state.criticalGroupCount,
              dailyNeed: state.dailyNeed,
              donationsToday: state.donationsToday,
            ),
            const SizedBox(height: 16),
            BloodStockChart(stocks: state.stockList),
            const SizedBox(height: 16),
            _CriticalFilterToggle(
              isFiltered: state.showCriticalOnly,
              onToggle: controller.toggleFilterCritical,
            ),
            const SizedBox(height: 12),
            ...displayedStocks.map((stock) => _buildStockItem(stock)),
            const SizedBox(height: 16),
            const BloodCompatibilityMatrix(),
          ],
        );
      },
    );
  }

  Widget _buildStockItem(BloodGroupStock stock) {
    return BloodStockRowItem(
      stock: stock,
      onAddUnit: () => controller.simulateDonation(stock.bloodType, 1),
      onDispatchUnit: () => controller.simulateDispatch(stock.bloodType, 1),
    );
  }
}

class _CriticalFilterToggle extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onToggle;

  const _CriticalFilterToggle({
    required this.isFiltered,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Grup Bazlı Stok Detayları',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        FilterChip(
          selected: isFiltered,
          label: const Text('Sadece Kritikler'),
          selectedColor: AppColors.statusCritical.withValues(alpha: 0.2),
          checkmarkColor: AppColors.statusCritical,
          labelStyle: TextStyle(
            color: isFiltered ? AppColors.statusCritical : null,
            fontWeight: isFiltered ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (_) => onToggle(),
        ),
      ],
    );
  }
}
