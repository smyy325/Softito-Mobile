import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutAddBottomSheet extends StatefulWidget {
  final void Function({
    required String name,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) onAdd;

  const WorkoutAddBottomSheet({super.key, required this.onAdd});

  @override
  State<WorkoutAddBottomSheet> createState() => _WorkoutAddBottomSheetState();
}

class _WorkoutAddBottomSheetState extends State<WorkoutAddBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController =
      TextEditingController(text: '30');
  final TextEditingController _caloriesController =
      TextEditingController(text: '200');
  String _selectedCategory = 'Kardiyo';

  final List<String> _categories = const [
    'Kardiyo',
    'Ağırlık',
    'HIIT',
    'Esneme',
    'Yüzme',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final duration = int.tryParse(_durationController.text) ?? 20;
    final calories = int.tryParse(_caloriesController.text) ?? 150;

    widget.onAdd(
      name: name,
      category: _selectedCategory,
      durationMinutes: duration,
      caloriesBurned: calories,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yeni Antrenman Ekle',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _NameInput(controller: _nameController),
          const SizedBox(height: 12),
          _CategorySelector(
            categories: _categories,
            selected: _selectedCategory,
            onSelect: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _NumberInput(
                  controller: _durationController,
                  label: 'Süre (dk)',
                  icon: Icons.timer_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NumberInput(
                  controller: _caloriesController,
                  label: 'Kalori (kcal)',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SubmitButton(onPressed: _submit),
        ],
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  final TextEditingController controller;

  const _NameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Egzersiz Adı (örn: Bacak Günü)',
        labelStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategorySelector({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSel = cat == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSel,
              selectedColor: AppColors.neonOrange,
              backgroundColor: AppColors.surfaceVariant,
              labelStyle: TextStyle(
                color: isSel ? Colors.black : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              onSelected: (_) => onSelect(cat),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _NumberInput({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.neonOrange, size: 20),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonOrange,
          foregroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: const Text('Antrenmanı Kaydet'),
      ),
    );
  }
}
