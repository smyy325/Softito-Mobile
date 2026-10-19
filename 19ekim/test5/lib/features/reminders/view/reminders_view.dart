import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/reminder_controller.dart';
import '../models/reminder_item.dart';
import '../widget/add_reminder_sheet.dart';
import '../widget/reminder_summary_card.dart';
import '../widget/reminder_tile.dart';

/// Hatırlatıcılar modülü ana ekranı.
class RemindersView extends StatelessWidget {
  const RemindersView({
    required this.controller,
    super.key,
  });

  final ReminderController controller;

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
                  _ReminderHeader(
                    onAdd: () => AddReminderSheet.show(
                      context,
                      onAdd: controller.addReminder,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ReminderSummaryCard(
                    activeCount: controller.activeCount,
                    totalCount: controller.reminders.length,
                  ),
                  const SizedBox(height: 24),
                  _ReminderList(
                    reminders: controller.reminders,
                    onToggle: controller.toggleReminder,
                    onDelete: controller.removeReminder,
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

class _ReminderHeader extends StatelessWidget {
  const _ReminderHeader({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BİLDİRİM & ALIŞKANLIK',
              style: TextStyle(
                color: AppColors.neonCyan,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Hatırlatıcılar',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.add_rounded, color: AppColors.neonCyan),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.obsidianSurface,
          ),
          onPressed: onAdd,
        ),
      ],
    );
  }
}

class _ReminderList extends StatelessWidget {
  const _ReminderList({
    required this.reminders,
    required this.onToggle,
    required this.onDelete,
  });

  final List<ReminderItem> reminders;
  final void Function(String id) onToggle;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reminders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        final ReminderItem item = reminders[index];
        return ReminderTile(
          reminder: item,
          onToggle: (_) => onToggle(item.id),
          onDelete: () => onDelete(item.id),
        );
      },
    );
  }
}
