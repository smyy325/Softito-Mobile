import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_log.dart';

/// Günlük su tüketim geçmişi listesi bölümü.
class WaterHistorySection extends StatelessWidget {
  const WaterHistorySection({
    required this.logs,
    required this.onDeleteLog,
    super.key,
  });

  final List<WaterLog> logs;
  final void Function(String id) onDeleteLog;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const _EmptyWaterHistory();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (BuildContext context, int index) {
            final WaterLog log = logs[index];
            return _WaterLogTile(log: log, onDelete: () => onDeleteLog(log.id));
          },
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Bugünkü Kayıtlar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _EmptyWaterHistory extends StatelessWidget {
  const _EmptyWaterHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: const Column(
        children: <Widget>[
          Icon(Icons.opacity_rounded, color: AppColors.textMuted, size: 36),
          SizedBox(height: 8),
          Text(
            'Henüz su tüketimi kaydedilmedi.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _WaterLogTile extends StatelessWidget {
  const _WaterLogTile({
    required this.log,
    required this.onDelete,
  });

  final WaterLog log;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final String timeStr =
        '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.obsidianBorder, width: 1),
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.obsidianSurface,
            child: Icon(Icons.water_drop, color: AppColors.neonCyan, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  log.beverageType,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${log.amountMl} ml',
            style: const TextStyle(
              color: AppColors.neonCyan,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 4),
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
