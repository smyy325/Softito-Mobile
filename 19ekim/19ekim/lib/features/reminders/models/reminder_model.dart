class ReminderItem {
  final String id;
  final String title;
  final String timeStr;
  final String category;
  final bool isEnabled;

  const ReminderItem({
    required this.id,
    required this.title,
    required this.timeStr,
    required this.category,
    this.isEnabled = true,
  });

  ReminderItem copyWith({
    String? id,
    String? title,
    String? timeStr,
    String? category,
    bool? isEnabled,
  }) {
    return ReminderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      timeStr: timeStr ?? this.timeStr,
      category: category ?? this.category,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  factory ReminderItem.fromJson(Map<String, dynamic> json) {
    return ReminderItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      timeStr: json['timeStr'] as String? ?? '08:00',
      category: json['category'] as String? ?? 'Su',
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timeStr': timeStr,
      'category': category,
      'isEnabled': isEnabled,
    };
  }
}
