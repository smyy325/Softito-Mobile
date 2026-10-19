import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı su ekleme butonları grubu.
class QuickAddButtons extends StatelessWidget {
  const QuickAddButtons({
    required this.onAddWater,
    super.key,
  });

  final void Function(int amount, String beverage) onAddWater;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _QuickAddCard(
            label: '+150 ml',
            subtitle: 'Bardak',
            icon: Icons.coffee_rounded,
            onTap: () => onAddWater(150, 'Çay/Kahve'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickAddCard(
            label: '+250 ml',
            subtitle: 'Su Bardağı',
            icon: Icons.local_drink_rounded,
            isHighlighted: true,
            onTap: () => onAddWater(250, 'Su'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickAddCard(
            label: '+500 ml',
            subtitle: 'Matara',
            icon: Icons.fitness_center_rounded,
            onTap: () => onAddWater(500, 'Su'),
          ),
        ),
      ],
    );
  }
}

class _QuickAddCard extends StatelessWidget {
  const _QuickAddCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isHighlighted = false,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        isHighlighted ? AppColors.neonCyan : AppColors.obsidianBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.obsidianSurface
                : AppColors.obsidianCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: isHighlighted ? AppColors.neonCyan : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
