import 'package:flutter/material.dart';
import '../models/urgent_request_model.dart';

/// Yeni acil kan talebi oluşturma diyaloğu.
class NewRequestDialog extends StatelessWidget {
  final ValueChanged<UrgentRequestModel> onAdd;

  NewRequestDialog({super.key, required this.onAdd});

  final TextEditingController _patientController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _cityController = TextEditingController(text: 'İstanbul');
  final ValueNotifier<String> _bloodTypeNotifier = ValueNotifier<String>('0 Rh-');
  final ValueNotifier<int> _unitsNotifier = ValueNotifier<int>(2);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Acil Talep Aç'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _patientController,
              decoration: const InputDecoration(labelText: 'Hasta Adı Soyadı'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(labelText: 'Hastane Adı'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Şehir / İlçe'),
            ),
            const SizedBox(height: 12),
            _BloodTypeSelector(notifier: _bloodTypeNotifier),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () => _handleSubmit(context),
          child: const Text('Yayınla'),
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context) {
    final patient = _patientController.text.trim();
    final hospital = _hospitalController.text.trim();
    if (patient.isEmpty || hospital.isEmpty) return;

    final newReq = UrgentRequestModel(
      id: 'urg-${DateTime.now().millisecondsSinceEpoch}',
      patientName: patient,
      hospitalName: hospital,
      city: _cityController.text.trim(),
      district: 'Merkez',
      bloodType: _bloodTypeNotifier.value,
      requiredUnits: _unitsNotifier.value,
      collectedUnits: 0,
      urgencyLevel: 'Kritik',
      contactPhone: '+90 532 999 88 77',
      notes: 'Acil operasyon için kan ihtiyacı bulunmaktadır.',
      createdAt: 'Az önce',
    );

    onAdd(newReq);
    Navigator.of(context).pop();
  }
}

class _BloodTypeSelector extends StatelessWidget {
  final ValueNotifier<String> notifier;

  const _BloodTypeSelector({required this.notifier});

  static const List<String> _types = [
    '0 Rh-', '0 Rh+', 'A Rh-', 'A Rh+', 'B Rh-', 'B Rh+', 'AB Rh-', 'AB Rh+'
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: notifier,
      builder: (context, selected, _) {
        return DropdownButtonFormField<String>(
          initialValue: selected,
          decoration: const InputDecoration(labelText: 'İhtiyaç Duyulan Kan Grubu'),
          items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) {
            if (val != null) notifier.value = val;
          },
        );
      },
    );
  }
}
