import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import 'donation_goal_chart.dart';

/// Bağışçı profil özetini, hedef grafiğini ve eylemleri sunan ana kart.
class DonationTrackerCard extends StatelessWidget {
  final String donorName;
  final String bloodType;
  final int currentUnits;
  final int goalUnits;
  final int totalUnits;
  final int savedLives;
  final VoidCallback onAddDonation;
  final VoidCallback onReset;

  const DonationTrackerCard({
    super.key,
    required this.donorName,
    required this.bloodType,
    required this.currentUnits,
    required this.goalUnits,
    required this.totalUnits,
    required this.savedLives,
    required this.onAddDonation,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _CardHeader(donorName: donorName, bloodType: bloodType),
            const SizedBox(height: 20),
            DonationGoalChart(currentUnits: currentUnits, goalUnits: goalUnits),
            const SizedBox(height: 20),
            _StatRow(totalUnits: totalUnits, savedLives: savedLives),
            const SizedBox(height: 16),
            _ActionButtons(onAdd: onAddDonation, onReset: onReset),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String donorName;
  final String bloodType;

  const _CardHeader({required this.donorName, required this.bloodType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(donorName, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('Düzenli Kan Bağışçısı', style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colorScheme.primary, width: 1.5),
          ),
          child: Text(
            bloodType,
            style: TextStyle(color: context.colorScheme.primary, fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final int totalUnits;
  final int savedLives;

  const _StatRow({required this.totalUnits, required this.savedLives});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'Toplam Bağış',
            value: '$totalUnits Ünite',
            icon: Icons.bloodtype_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'Kurtarılan Hayat',
            value: '$savedLives Can',
            icon: Icons.favorite_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBox({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onSurfaceVariant)),
              Text(value, style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onReset;

  const _ActionButtons({required this.onAdd, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('1 Ünite Bağış Ekle'),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.outlined(
          onPressed: onReset,
          tooltip: 'Hedefi Sıfırla',
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }
}
