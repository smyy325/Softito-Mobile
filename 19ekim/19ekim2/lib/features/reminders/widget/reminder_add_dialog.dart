import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ReminderAddBottomSheet extends StatefulWidget {
  final void Function({
    required String title,
    required String timeStr,
    required String category,
  }) onAdd;

  const ReminderAddBottomSheet({super.key, required this.onAdd});

  @override
  State<ReminderAddBottomSheet> createState() => _ReminderAddBottomSheetState();
}

class _ReminderAddBottomSheetState extends State<ReminderAddBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(text: '14:00');
  String _selectedCategory = 'Su';

  final List<String> _categories = const [
    'Su',
    'Egzersiz',
    'Takviye',
    'Öğün',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    final timeStr = _timeController.text.trim();

    widget.onAdd(
      title: title,
      timeStr: timeStr,
      category: _selectedCategory,
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
            'Yeni Hatırlatıcı Ekle',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _TitleField(controller: _titleController),
          const SizedBox(height: 12),
          _TimeField(controller: _timeController),
          const SizedBox(height: 12),
          _CategoryChips(
            categories: _categories,
            selected: _selectedCategory,
            onSelect: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 20),
          _SubmitReminderButton(onPressed: _submit),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  final TextEditingController controller;

  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Hatırlatıcı Başlığı (örn: Akşam Suyu)',
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

class _TimeField extends StatelessWidget {
  final TextEditingController controller;

  const _TimeField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Saat (örn: 14:30)',
        prefixIcon: const Icon(Icons.access_time_rounded,
            color: AppColors.neonPurple, size: 20),
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

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategoryChips({
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
              selectedColor: AppColors.neonPurple,
              backgroundColor: AppColors.surfaceVariant,
              labelStyle: TextStyle(
                color: isSel ? Colors.white : AppColors.textPrimary,
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

class _SubmitReminderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitReminderButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonPurple,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: const Text('Hatırlatıcıyı Kur'),
      ),
    );
  }
}
