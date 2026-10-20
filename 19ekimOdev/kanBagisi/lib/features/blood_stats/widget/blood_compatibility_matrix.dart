import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Kan grubu uyumluluk rehberini sunan modüler kart.
class BloodCompatibilityMatrix extends StatelessWidget {
  const BloodCompatibilityMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _MatrixHeader(),
            const SizedBox(height: 12),
            const _InfoTile(
              bloodGroup: '0 Rh-',
              badgeText: 'Genel Verici',
              description: 'Tüm kan gruplarına eritrosit verebilir. Acil durumlarda ilk başvurulan kandır.',
            ),
            const SizedBox(height: 8),
            const _InfoTile(
              bloodGroup: 'AB Rh+',
              badgeText: 'Genel Alıcı',
              description: 'Tüm kan gruplarından eritrosit alabilir. Plazma bağışında genel vericidir.',
            ),
          ],
        ),
      ),
    );
  }
}

class _MatrixHeader extends StatelessWidget {
  const _MatrixHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.sync_alt_rounded, color: context.colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Kan Grubu Uyumluluk Notları',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String bloodGroup;
  final String badgeText;
  final String description;

  const _InfoTile({
    required this.bloodGroup,
    required this.badgeText,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(bloodGroup, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(color: context.colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(description, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}
