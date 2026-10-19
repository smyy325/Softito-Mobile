import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/widget/theme_mode_switch_button.dart';
import '../controller/water_tracker_controller.dart';
import '../models/water_log_model.dart';
import '../widget/water_history_tile.dart';
import '../widget/water_progress_card.dart';
import '../widget/water_quick_add_buttons.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;
  final ThemeController? themeController;

  const WaterTrackerView({
    super.key,
    required this.controller,
    this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takibi'),
        actions: [
          if (themeController != null)
            ThemeModeSwitchButton(controller: themeController!),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Sıfırla',
            onPressed: controller.resetWater,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HydrationProgressSection(controller: controller),
            const SizedBox(height: 24),
            WaterQuickAddButtons(onAddWater: controller.addWater),
            const SizedBox(height: 28),
            _HistoryHeader(controller: controller),
            const SizedBox(height: 12),
            _HistoryListSection(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _HydrationProgressSection extends StatelessWidget {
  final WaterTrackerController controller;

  const _HydrationProgressSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.currentWater,
      builder: (context, current, _) {
        return ValueListenableBuilder<int>(
          valueListenable: controller.dailyGoal,
          builder: (context, goal, _) {
            return WaterProgressCard(current: current, goal: goal);
          },
        );
      },
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final WaterTrackerController controller;

  const _HistoryHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Bugünün Kayıtları',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        ValueListenableBuilder<List<WaterLog>>(
          valueListenable: controller.logs,
          builder: (context, logs, _) {
            return Text(
              '${logs.length} Giriş',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HistoryListSection extends StatelessWidget {
  final WaterTrackerController controller;

  const _HistoryListSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WaterLog>>(
      valueListenable: controller.logs,
      builder: (context, logs, _) {
        if (logs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(
              child: Text(
                'Henüz su girişi yapılmadı.\nYukarıdan bir miktar seçerek başla!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return WaterHistoryTile(
              log: log,
              onDelete: () => controller.removeLog(log.id),
            );
          },
        );
      },
    );
  }
}
