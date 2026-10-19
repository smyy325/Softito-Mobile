import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reminder_item.dart';

/// Yeni hatırlatıcı ekleme alt sayfası (Bottom Sheet).
class AddReminderSheet extends StatefulWidget {
  const AddReminderSheet({
    required this.onAdd,
    super.key,
  });

  final void Function(ReminderItem item) onAdd;

  static Future<void> show(
    BuildContext context, {
    required void Function(ReminderItem item) onAdd,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.obsidianCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) => AddReminderSheet(onAdd: onAdd),
    );
  }

  @override
  State<AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<AddReminderSheet> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _intervalCtrl = TextEditingController();
  final String _category = 'water';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _intervalCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final String title = _titleCtrl.text.trim();
    final int interval = int.tryParse(_intervalCtrl.text.trim()) ?? 60;

    if (title.isEmpty) return;

    final ReminderItem item = ReminderItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      hour: 0,
      minute: 0,
      intervalMinutes: interval,
      isEnabled: true,
      category: _category,
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
          const _ReminderSheetHeader(),
          const SizedBox(height: 16),
          _ReminderInputs(titleCtrl: _titleCtrl, intervalCtrl: _intervalCtrl),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Hatırlatıcıyı Ekle'),
          ),
        ],
      ),
    );
  }
}

class _ReminderSheetHeader extends StatelessWidget {
  const _ReminderSheetHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Yeni Hatırlatıcı',
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

class _ReminderInputs extends StatelessWidget {
  const _ReminderInputs({
    required this.titleCtrl,
    required this.intervalCtrl,
  });

  final TextEditingController titleCtrl;
  final TextEditingController intervalCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: 'Hatırlatıcı Başlığı (Örn: Su Zamanı)',
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
          controller: intervalCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Tekrar Aralığı (Dakika cinsinden, örn: 60)',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.obsidianSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
