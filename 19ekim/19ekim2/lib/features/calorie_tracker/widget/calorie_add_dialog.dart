import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CalorieAddBottomSheet extends StatefulWidget {
  final void Function({
    required String name,
    required String mealType,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
  }) onAdd;

  const CalorieAddBottomSheet({super.key, required this.onAdd});

  @override
  State<CalorieAddBottomSheet> createState() => _CalorieAddBottomSheetState();
}

class _CalorieAddBottomSheetState extends State<CalorieAddBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController =
      TextEditingController(text: '350');
  final TextEditingController _proteinController =
      TextEditingController(text: '25');
  final TextEditingController _carbsController =
      TextEditingController(text: '40');
  final TextEditingController _fatController =
      TextEditingController(text: '10');
  String _selectedType = 'Öğle Yemeği';

  final List<String> _mealTypes = const [
    'Kahvaltı',
    'Öğle Yemeği',
    'Akşam Yemeği',
    'Ara Öğün',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final calories = int.tryParse(_caloriesController.text) ?? 200;
    final protein = int.tryParse(_proteinController.text) ?? 10;
    final carbs = int.tryParse(_carbsController.text) ?? 20;
    final fat = int.tryParse(_fatController.text) ?? 5;

    widget.onAdd(
      name: name,
      mealType: _selectedType,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
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
            'Öğün & Kalori Ekle',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _MealNameField(controller: _nameController),
          const SizedBox(height: 12),
          _MealTypeChips(
            types: _mealTypes,
            selected: _selectedType,
            onSelect: (type) => setState(() => _selectedType = type),
          ),
          const SizedBox(height: 12),
          _MacroInputsRow(
            calories: _caloriesController,
            protein: _proteinController,
            carbs: _carbsController,
            fat: _fatController,
          ),
          const SizedBox(height: 20),
          _AddMealButton(onPressed: _submit),
        ],
      ),
    );
  }
}

class _MealNameField extends StatelessWidget {
  final TextEditingController controller;

  const _MealNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Öğün / Yiyecek Adı',
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

class _MealTypeChips extends StatelessWidget {
  final List<String> types;
  final String selected;
  final ValueChanged<String> onSelect;

  const _MealTypeChips({
    required this.types,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          final isSel = type == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(type),
              selected: isSel,
              selectedColor: AppColors.neonLime,
              backgroundColor: AppColors.surfaceVariant,
              labelStyle: TextStyle(
                color: isSel ? Colors.black : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              onSelected: (_) => onSelect(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MacroInputsRow extends StatelessWidget {
  final TextEditingController calories;
  final TextEditingController protein;
  final TextEditingController carbs;
  final TextEditingController fat;

  const _MacroInputsRow({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SmallNumberField(
          controller: calories,
          label: 'Toplam Kalori (kcal)',
          color: AppColors.neonLime,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SmallNumberField(
                controller: protein,
                label: 'Protein (g)',
                color: AppColors.neonCyan,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SmallNumberField(
                controller: carbs,
                label: 'Karb (g)',
                color: AppColors.neonOrange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SmallNumberField(
                controller: fat,
                label: 'Yağ (g)',
                color: AppColors.neonFlame,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color color;

  const _SmallNumberField({
    required this.controller,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color, fontSize: 11),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _AddMealButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddMealButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonLime,
          foregroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: const Text('Öğünü Kaydet'),
      ),
    );
  }
}
