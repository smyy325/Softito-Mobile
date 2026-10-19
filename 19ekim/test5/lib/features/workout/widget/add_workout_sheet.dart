import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_item.dart';

/// Yeni özel egzersiz ekleme alt sayfası (Bottom Sheet).
class AddWorkoutSheet extends StatefulWidget {
  const AddWorkoutSheet({
    required this.onAdd,
    super.key,
  });

  final void Function(WorkoutItem item) onAdd;

  static Future<void> show(
    BuildContext context, {
    required void Function(WorkoutItem item) onAdd,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.obsidianCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) => AddWorkoutSheet(onAdd: onAdd),
    );
  }

  @override
  State<AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends State<AddWorkoutSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final String _selectedCategory = 'Fitness';

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submit() {
    final String title = _titleController.text.trim();
    final int duration = int.tryParse(_durationController.text.trim()) ?? 0;
    final int calories = int.tryParse(_caloriesController.text.trim()) ?? 0;

    if (title.isEmpty || duration <= 0 || calories <= 0) return;

    final WorkoutItem item = WorkoutItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      category: _selectedCategory,
      durationMinutes: duration,
      caloriesBurned: calories,
      timestamp: DateTime.now(),
    );

    widget.onAdd(item);
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
          const _SheetHeader(),
          const SizedBox(height: 16),
          _InputsSection(
            titleCtrl: _titleController,
            durationCtrl: _durationController,
            calCtrl: _caloriesController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Antrenmanı Kaydet'),
          ),
        ],
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Özel Egzersiz Ekle',
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

class _InputsSection extends StatelessWidget {
  const _InputsSection({
    required this.titleCtrl,
    required this.durationCtrl,
    required this.calCtrl,
  });

  final TextEditingController titleCtrl;
  final TextEditingController durationCtrl;
  final TextEditingController calCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: 'Egzersiz Adı (Örn: Bacak & Squat)',
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
              child: TextField(
                controller: durationCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Süre (dk)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.obsidianSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
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
            ),
          ],
        ),
      ],
    );
  }
}
