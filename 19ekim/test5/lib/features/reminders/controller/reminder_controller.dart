import 'package:flutter/foundation.dart';
import '../models/reminder_item.dart';

/// Flutter çekirdek ChangeNotifier API'si ile hatırlatıcılar durum yöneticisi.
class ReminderController extends ChangeNotifier {
  ReminderController() {
    _reminders.addAll(<ReminderItem>[
      const ReminderItem(
        id: '1',
        title: 'Düzenli Su İçme Molası',
        hour: 0,
        minute: 0,
        intervalMinutes: 60,
        isEnabled: true,
        category: 'water',
      ),
      const ReminderItem(
        id: '2',
        title: 'Öğle Suyu & Hidrasyon',
        hour: 13,
        minute: 0,
        isEnabled: true,
        category: 'water',
      ),
      const ReminderItem(
        id: '3',
        title: 'Akşam Antrenman Saati',
        hour: 18,
        minute: 30,
        isEnabled: true,
        category: 'workout',
      ),
    ]);
  }

  final List<ReminderItem> _reminders = <ReminderItem>[];

  List<ReminderItem> get reminders => List<ReminderItem>.unmodifiable(_reminders);

  int get activeCount =>
      _reminders.where((ReminderItem r) => r.isEnabled).length;

  void toggleReminder(String id) {
    final int index = _reminders.indexWhere((ReminderItem r) => r.id == id);
    if (index != -1) {
      final ReminderItem item = _reminders[index];
      _reminders[index] = item.copyWith(isEnabled: !item.isEnabled);
      notifyListeners();
    }
  }

  void addReminder(ReminderItem item) {
    _reminders.add(item);
    notifyListeners();
  }

  void removeReminder(String id) {
    _reminders.removeWhere((ReminderItem r) => r.id == id);
    notifyListeners();
  }
}
