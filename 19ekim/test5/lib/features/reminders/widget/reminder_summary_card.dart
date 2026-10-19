import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Aktif hatırlatıcıların durumunu gösteren neon özet kartı.
class ReminderSummaryCard extends StatelessWidget {
  const ReminderSummaryCard({
    required this.activeCount,
    required this.totalCount,
    super.key,
  });

  final int activeCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.obsidianSurface,
            child: Icon(
              Icons.notifications_active_rounded,
              color: AppColors.neonCyan,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$activeCount Aktif Hatırlatıcı',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Toplam $totalCount bildirim zamanlaması kayıtlı',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
