import 'package:flutter/foundation.dart';

/// Su ve sıvı tüketim kaydı veri modeli.
@immutable
class WaterLog {
  const WaterLog({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.beverageType = 'Su',
  });

  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String beverageType;

  WaterLog copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? beverageType,
  }) {
    return WaterLog(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      beverageType: beverageType ?? this.beverageType,
    );
  }
}

/// Günlük su hedefini ve ilerlemeyi hesaplayan model.
@immutable
class DailyWaterGoal {
  const DailyWaterGoal({
    required this.targetMl,
    required this.consumedMl,
  });

  final int targetMl;
  final int consumedMl;

  int get remainingMl {
    final int diff = targetMl - consumedMl;
    return diff < 0 ? 0 : diff;
  }

  double get progressPercentage {
    if (targetMl <= 0) return 0.0;
    return (consumedMl / targetMl).clamp(0.0, 1.0);
  }

  bool get isCompleted => consumedMl >= targetMl;
}
