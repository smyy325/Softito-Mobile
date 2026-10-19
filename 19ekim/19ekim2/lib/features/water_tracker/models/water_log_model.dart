class WaterLog {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String drinkType;

  const WaterLog({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    required this.drinkType,
  });

  WaterLog copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? drinkType,
  }) {
    return WaterLog(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      drinkType: drinkType ?? this.drinkType,
    );
  }

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id'] as String? ?? '',
      amountMl: (json['amountMl'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      drinkType: json['drinkType'] as String? ?? 'Su',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'drinkType': drinkType,
    };
  }
}
