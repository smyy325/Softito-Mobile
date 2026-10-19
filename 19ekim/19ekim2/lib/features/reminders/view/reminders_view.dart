import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/widget/theme_mode_switch_button.dart';
import '../controller/reminder_controller.dart';
import '../models/reminder_model.dart';
import '../widget/reminder_add_dialog.dart';
import '../widget/reminder_item_tile.dart';
import '../widget/smart_hydration_tip_card.dart';

class RemindersView extends StatelessWidget {
  final ReminderController controller;
  final ThemeController? themeController;

  const RemindersView({
    super.key,
    required this.controller,
    this.themeController,
  });

  void _openAddReminderSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReminderAddBottomSheet(onAdd: controller.addReminder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akıllı Hatırlatıcılar'),
        actions: [
          if (themeController != null)
            ThemeModeSwitchButton(controller: themeController!),
          IconButton(
            icon: const Icon(Icons.alarm_add_rounded),
            color: AppColors.neonPurple,
            tooltip: 'Hatırlatıcı Ekle',
            onPressed: () => _openAddReminderSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SmartTipSection(controller: controller),
            const SizedBox(height: 28),
            _ReminderHeader(controller: controller),
            const SizedBox(height: 12),
            _ReminderListSection(controller: controller),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.neonPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.alarm_on_rounded),
        label: const Text(
          'Hatırlatıcı Ekle',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () => _openAddReminderSheet(context),
      ),
    );
  }
}

class _SmartTipSection extends StatelessWidget {
  final ReminderController controller;

  const _SmartTipSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.smartReminders,
      builder: (context, isEnabled, _) {
        return SmartHydrationTipCard(
          isSmartEnabled: isEnabled,
          onToggle: controller.toggleSmartReminders,
        );
      },
    );
  }
}

class _ReminderHeader extends StatelessWidget {
  final ReminderController controller;

  const _ReminderHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Zamanlanmış Hatırlatıcılar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        ValueListenableBuilder<List<ReminderItem>>(
          valueListenable: controller.reminders,
          builder: (context, list, _) {
            final activeCount = list.where((r) => r.isEnabled).length;
            return Text(
              '$activeCount Aktif',
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

class _ReminderListSection extends StatelessWidget {
  final ReminderController controller;

  const _ReminderListSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ReminderItem>>(
      valueListenable: controller.reminders,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Kayıtlı hatırlatıcı yok.\nYeni bir su veya antrenman saati ekle!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final reminder = list[index];
            return ReminderItemTile(
              reminder: reminder,
              onToggle: () => controller.toggleReminder(reminder.id),
              onDelete: () => controller.removeReminder(reminder.id),
            );
          },
        );
      },
    );
  }
}
