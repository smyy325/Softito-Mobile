import 'package:flutter/foundation.dart';

/// Hatırlatıcı veri modeli.
@immutable
class ReminderItem {
  const ReminderItem({
    required this.id,
    required this.title,
    required this.hour,
    required this.minute,
    this.intervalMinutes = 0,
    this.isEnabled = true,
    this.category = 'water',
  });

  final String id;
  final String title;
  final int hour;
  final int minute;
  final int intervalMinutes;
  final bool isEnabled;
  final String category; // 'water', 'workout', 'general'

  String get formattedTime {
    if (intervalMinutes > 0) {
      return 'Her $intervalMinutes dakikada bir';
    }
    final String h = hour.toString().padLeft(2, '0');
    final String m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  ReminderItem copyWith({
    String? id,
    String? title,
    int? hour,
    int? minute,
    int? intervalMinutes,
    bool? isEnabled,
    String? category,
  }) {
    return ReminderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      isEnabled: isEnabled ?? this.isEnabled,
      category: category ?? this.category,
    );
  }
}
