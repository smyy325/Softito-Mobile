import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SmartHydrationTipCard extends StatelessWidget {
  final bool isSmartEnabled;
  final VoidCallback onToggle;

  const SmartHydrationTipCard({
    super.key,
    required this.isSmartEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TipHeader(isEnabled: isSmartEnabled, onToggle: onToggle),
          const SizedBox(height: 12),
          const Text(
            '💡 Antrenmandan 2 saat önce en az 500 ml su içmek kas kramplarını önler ve performansını %15 artırır.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipHeader extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onToggle;

  const _TipHeader({required this.isEnabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Akıllı Bildirim Motoru',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Switch.adaptive(
          value: isEnabled,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.neonCyan,
          onChanged: (_) => onToggle(),
        ),
      ],
    );
  }
}
