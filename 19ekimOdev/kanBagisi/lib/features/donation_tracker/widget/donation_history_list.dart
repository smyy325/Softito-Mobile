import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/donation_tracker_model.dart';

/// Son kan bağışları listesini sunan modüler bileşen.
class DonationHistoryList extends StatelessWidget {
  final List<DonationRecord> records;

  const DonationHistoryList({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const _EmptyHistory();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HistoryHeader(),
        const SizedBox(height: 12),
        ...records.map((record) => _HistoryTile(record: record)),
      ],
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.history_rounded, color: context.colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Geçmiş Bağışlarım',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final DonationRecord record;

  const _HistoryTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.colorScheme.primary.withValues(alpha: 0.15),
          child: Icon(Icons.check_circle_outline_rounded, color: context.colorScheme.primary),
        ),
        title: Text(record.location, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('${record.date} • ${record.bloodComponent}', style: context.textTheme.bodySmall),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '+${record.units} Ünite',
            style: TextStyle(color: context.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          'Henüz kayıtlı bir bağışınız bulunmuyor.',
          style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
