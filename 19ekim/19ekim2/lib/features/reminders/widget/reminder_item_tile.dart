import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reminder_model.dart';

class ReminderItemTile extends StatelessWidget {
  final ReminderItem reminder;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ReminderItemTile({
    super.key,
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: reminder.isEnabled
              ? AppColors.cardBorder
              : AppColors.cardBorder.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          _TimeBadge(timeStr: reminder.timeStr, isEnabled: reminder.isEnabled),
          const SizedBox(width: 14),
          Expanded(child: _ReminderInfo(reminder: reminder)),
          Switch.adaptive(
            value: reminder.isEnabled,
            activeTrackColor: AppColors.neonCyan,
            onChanged: (_) => onToggle(),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.textMuted,
            onPressed: onDelete,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  final String timeStr;
  final bool isEnabled;

  const _TimeBadge({required this.timeStr, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isEnabled
            ? AppColors.neonCyan.withAlpha(25)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        timeStr,
        style: TextStyle(
          color: isEnabled ? AppColors.neonCyan : AppColors.textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ReminderInfo extends StatelessWidget {
  final ReminderItem reminder;

  const _ReminderInfo({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reminder.title,
          style: TextStyle(
            color: reminder.isEnabled
                ? AppColors.textPrimary
                : AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          reminder.category,
          style: const TextStyle(
            color: AppColors.neonPurple,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
