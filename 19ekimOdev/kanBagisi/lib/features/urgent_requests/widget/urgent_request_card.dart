import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/urgent_request_model.dart';

/// Acil kan bağışı talep kartı.
class UrgentRequestCard extends StatelessWidget {
  final UrgentRequestModel request;
  final VoidCallback onSupport;

  const UrgentRequestCard({
    super.key,
    required this.request,
    required this.onSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(request: request),
            const SizedBox(height: 12),
            _HospitalInfo(request: request),
            const SizedBox(height: 12),
            _ProgressSection(request: request),
            const SizedBox(height: 14),
            _CardFooter(request: request, onSupport: onSupport),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final UrgentRequestModel request;

  const _CardHeader({required this.request});

  @override
  Widget build(BuildContext context) {
    final isCritical = request.urgencyLevel == 'Kritik';
    final badgeColor = isCritical ? AppColors.statusCritical : AppColors.statusWarning;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colorScheme.primary),
              ),
              child: Text(
                request.bloodType,
                style: TextStyle(color: context.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                request.urgencyLevel,
                style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Text(request.createdAt, style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _HospitalInfo extends StatelessWidget {
  final UrgentRequestModel request;

  const _HospitalInfo({required this.request});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasta: ${request.patientName}',
          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 14, color: context.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${request.hospitalName} (${request.district}, ${request.city})',
                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (request.notes.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            request.notes,
            style: context.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final UrgentRequestModel request;

  const _ProgressSection({required this.request});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'İhtiyaç: ${request.collectedUnits} / ${request.requiredUnits} Ünite',
              style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              request.isFulfilled ? 'Tamamlandı' : 'Kalan: ${request.remainingUnits} ünite',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: request.isFulfilled ? AppColors.statusSuccess : context.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: request.progressRatio,
            minHeight: 8,
            backgroundColor: context.colorScheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              request.isFulfilled ? AppColors.statusSuccess : context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardFooter extends StatelessWidget {
  final UrgentRequestModel request;
  final VoidCallback onSupport;

  const _CardFooter({required this.request, required this.onSupport});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.showSnackBar('İletişim: ${request.contactPhone}'),
            icon: const Icon(Icons.phone_rounded, size: 16),
            label: const Text('İletişime Geç'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: request.isFulfilled ? null : onSupport,
            icon: const Icon(Icons.volunteer_activism_rounded, size: 16),
            label: Text(request.isFulfilled ? 'Karşılandı' : '1 Ünite Bağışla'),
          ),
        ),
      ],
    );
  }
}
