import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterQuickAddButtons extends StatelessWidget {
  final ValueChanged<int> onAddWater;

  const WaterQuickAddButtons({super.key, required this.onAddWater});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Ekle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickAddButton(
              amount: 200,
              label: 'Bardak',
              icon: Icons.local_drink_rounded,
              onTap: () => onAddWater(200),
            ),
            const SizedBox(width: 10),
            _QuickAddButton(
              amount: 330,
              label: 'Kutu',
              icon: Icons.sports_bar_rounded,
              onTap: () => onAddWater(330),
            ),
            const SizedBox(width: 10),
            _QuickAddButton(
              amount: 500,
              label: 'Şişe',
              icon: Icons.water_drop_rounded,
              onTap: () => onAddWater(500),
            ),
            const SizedBox(width: 10),
            _QuickAddButton(
              amount: 750,
              label: 'Matara',
              icon: Icons.fitness_center_rounded,
              onTap: () => onAddWater(750),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.neonCyan, size: 24),
              const SizedBox(height: 8),
              Text(
                '+$amount',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
