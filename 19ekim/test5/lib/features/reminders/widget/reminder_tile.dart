import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reminder_item.dart';

/// Bireysel hatırlatıcı öğesi kartı.
class ReminderTile extends StatelessWidget {
  const ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final ReminderItem reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bool isWater = reminder.category == 'water';
    final Color iconColor = isWater ? AppColors.neonCyan : AppColors.neonLime;
    final IconData icon = isWater
        ? Icons.water_drop_rounded
        : Icons.fitness_center_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.obsidianSurface,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  reminder.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  reminder.formattedTime,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: reminder.isEnabled,
            activeThumbColor: AppColors.neonCyan,
            activeTrackColor: AppColors.neonCyanGlow,
            onChanged: onToggle,
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.textMuted,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
