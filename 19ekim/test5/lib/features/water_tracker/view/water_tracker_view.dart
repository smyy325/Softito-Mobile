import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/water_tracker_controller.dart';
import '../widget/quick_add_buttons.dart';
import '../widget/water_history_section.dart';
import '../widget/water_progress_indicator.dart';
import '../widget/water_stats_row.dart';

/// Su takip modülü ana ekranı.
class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({
    required this.controller,
    super.key,
  });

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _HeaderTitle(),
                  const SizedBox(height: 20),
                  WaterProgressIndicator(goal: controller.goal),
                  const SizedBox(height: 24),
                  WaterStatsRow(goal: controller.goal),
                  const SizedBox(height: 24),
                  QuickAddButtons(
                    onAddWater: (int amount, String beverage) =>
                        controller.addWater(amount, beverageType: beverage),
                  ),
                  const SizedBox(height: 28),
                  WaterHistorySection(
                    logs: controller.logs,
                    onDeleteLog: controller.removeLog,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'SUSADIM',
          style: TextStyle(
            color: AppColors.neonCyan,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Su & Sıvı Takibi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
