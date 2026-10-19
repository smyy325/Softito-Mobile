import 'package:flutter/foundation.dart';
import '../models/reminder_model.dart';

class ReminderController {
  final ValueNotifier<bool> smartReminders = ValueNotifier<bool>(true);

  final ValueNotifier<List<ReminderItem>> reminders =
      ValueNotifier<List<ReminderItem>>([
    const ReminderItem(
      id: 'r1',
      title: 'Güne Başlangıç Suyu',
      timeStr: '08:00',
      category: 'Su',
      isEnabled: true,
    ),
    const ReminderItem(
      id: 'r2',
      title: 'Antrenman Öncesi Hidrasyon',
      timeStr: '11:30',
      category: 'Egzersiz',
      isEnabled: true,
    ),
    const ReminderItem(
      id: 'r3',
      title: 'Öğleden Sonra Canlanma',
      timeStr: '15:00',
      category: 'Su',
      isEnabled: true,
    ),
    const ReminderItem(
      id: 'r4',
      title: 'Akşam Elektrolit / Maden Suyu',
      timeStr: '20:00',
      category: 'Takviye',
      isEnabled: true,
    ),
  ]);

  void toggleReminder(String id) {
    reminders.value = reminders.value.map((r) {
      if (r.id == id) {
        return r.copyWith(isEnabled: !r.isEnabled);
      }
      return r;
    }).toList();
  }

  void toggleSmartReminders() {
    smartReminders.value = !smartReminders.value;
  }

  void addReminder({
    required String title,
    required String timeStr,
    required String category,
  }) {
    final item = ReminderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      timeStr: timeStr,
      category: category,
      isEnabled: true,
    );
    reminders.value = [...reminders.value, item];
  }

  void removeReminder(String id) {
    reminders.value = reminders.value.where((r) => r.id != id).toList();
  }

  void dispose() {
    smartReminders.dispose();
    reminders.dispose();
  }
}
