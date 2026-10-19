import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/meal_entry.dart';

/// Yeni özel öğün ve besin ekleme alt sayfası (Bottom Sheet).
class AddMealSheet extends StatefulWidget {
  const AddMealSheet({
    required this.onAdd,
    super.key,
  });

  final void Function(MealEntry item) onAdd;

  static Future<void> show(
    BuildContext context, {
    required void Function(MealEntry item) onAdd,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.obsidianCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) => AddMealSheet(onAdd: onAdd),
    );
  }

  @override
  State<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends State<AddMealSheet> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _calCtrl = TextEditingController();
  final TextEditingController _proteinCtrl = TextEditingController();
  final TextEditingController _carbsCtrl = TextEditingController();
  final TextEditingController _fatCtrl = TextEditingController();
  final String _selectedMealType = 'Öğle Yemeği';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _calCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _nameCtrl.text.trim();
    final int cal = int.tryParse(_calCtrl.text.trim()) ?? 0;
    final int p = int.tryParse(_proteinCtrl.text.trim()) ?? 0;
    final int c = int.tryParse(_carbsCtrl.text.trim()) ?? 0;
    final int f = int.tryParse(_fatCtrl.text.trim()) ?? 0;

    if (name.isEmpty || cal <= 0) return;

    final MealEntry entry = MealEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      mealType: _selectedMealType,
      calories: cal,
      proteinGrams: p,
      carbsGrams: c,
      fatGrams: f,
      timestamp: DateTime.now(),
    );

    widget.onAdd(entry);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _MealSheetHeader(),
          const SizedBox(height: 16),
          _MealInputSection(
            nameCtrl: _nameCtrl,
            calCtrl: _calCtrl,
            proteinCtrl: _proteinCtrl,
            carbsCtrl: _carbsCtrl,
            fatCtrl: _fatCtrl,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonAmber,
            ),
            onPressed: _submit,
            child: const Text('Öğünü Kaydet'),
          ),
        ],
      ),
    );
  }
}

class _MealSheetHeader extends StatelessWidget {
  const _MealSheetHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Özel Öğün Ekle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _MealInputSection extends StatelessWidget {
  const _MealInputSection({
    required this.nameCtrl,
    required this.calCtrl,
    required this.proteinCtrl,
    required this.carbsCtrl,
    required this.fatCtrl,
  });

  final TextEditingController nameCtrl;
  final TextEditingController calCtrl;
  final TextEditingController proteinCtrl;
  final TextEditingController carbsCtrl;
  final TextEditingController fatCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Öğün / Yemek Adı',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.obsidianSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: calCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Kalori (kcal)',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.obsidianSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _MacroField(controller: proteinCtrl, label: 'Protein (g)'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MacroField(controller: carbsCtrl, label: 'Karb (g)'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MacroField(controller: fatCtrl, label: 'Yağ (g)'),
            ),
          ],
        ),
      ],
    );
  }
}

class _MacroField extends StatelessWidget {
  const _MacroField({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        filled: true,
        fillColor: AppColors.obsidianSurface,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
