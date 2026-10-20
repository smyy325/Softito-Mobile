import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Acil talepleri kan grubuna göre filtreleyen yatay çip listesi.
class UrgentFilterBar extends StatelessWidget {
  final String? selectedBloodType;
  final ValueChanged<String?> onSelect;

  const UrgentFilterBar({
    super.key,
    required this.selectedBloodType,
    required this.onSelect,
  });

  static const List<String> _bloodTypes = [
    '0 Rh-', '0 Rh+', 'A Rh-', 'A Rh+', 'B Rh-', 'B Rh+', 'AB Rh-', 'AB Rh+'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip(
            context,
            label: 'Tüm Gruplar',
            isSelected: selectedBloodType == null,
            onTap: () => onSelect(null),
          ),
          ..._bloodTypes.map(
            (type) => _buildChip(
              context,
              label: type,
              isSelected: selectedBloodType == type,
              onTap: () => onSelect(type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        selectedColor: context.colorScheme.primary.withValues(alpha: 0.2),
        checkmarkColor: context.colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? context.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
