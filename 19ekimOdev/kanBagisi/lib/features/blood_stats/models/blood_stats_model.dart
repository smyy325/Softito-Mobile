import 'package:flutter/foundation.dart';

/// Tek bir kan grubunun stok durum bilgisi
@immutable
class BloodGroupStock {
  final String bloodType;
  final int currentUnits;
  final int minRequiredUnits;
  final int capacityUnits;
  final String status;

  const BloodGroupStock({
    required this.bloodType,
    required this.currentUnits,
    required this.minRequiredUnits,
    required this.capacityUnits,
    required this.status,
  });

  double get occupancyRate =>
      capacityUnits > 0 ? (currentUnits / capacityUnits).clamp(0.0, 1.0) : 0.0;

  bool get isCritical => currentUnits <= minRequiredUnits;

  BloodGroupStock copyWith({
    String? bloodType,
    int? currentUnits,
    int? minRequiredUnits,
    int? capacityUnits,
    String? status,
  }) {
    return BloodGroupStock(
      bloodType: bloodType ?? this.bloodType,
      currentUnits: currentUnits ?? this.currentUnits,
      minRequiredUnits: minRequiredUnits ?? this.minRequiredUnits,
      capacityUnits: capacityUnits ?? this.capacityUnits,
      status: status ?? this.status,
    );
  }

  factory BloodGroupStock.fromJson(Map<String, dynamic> json) {
    return BloodGroupStock(
      bloodType: json['bloodType'] as String? ?? '',
      currentUnits: (json['currentUnits'] as num?)?.toInt() ?? 0,
      minRequiredUnits: (json['minRequiredUnits'] as num?)?.toInt() ?? 10,
      capacityUnits: (json['capacityUnits'] as num?)?.toInt() ?? 50,
      status: json['status'] as String? ?? 'Normal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodType': bloodType,
      'currentUnits': currentUnits,
      'minRequiredUnits': minRequiredUnits,
      'capacityUnits': capacityUnits,
      'status': status,
    };
  }
}

/// Kan bankası istatistikleri ana durum modeli
@immutable
class BloodStatsModel {
  final int totalUnits;
  final int criticalGroupCount;
  final int dailyNeed;
  final int donationsToday;
  final List<BloodGroupStock> stockList;
  final bool showCriticalOnly;

  const BloodStatsModel({
    required this.totalUnits,
    required this.criticalGroupCount,
    required this.dailyNeed,
    required this.donationsToday,
    required this.stockList,
    this.showCriticalOnly = false,
  });

  BloodStatsModel copyWith({
    int? totalUnits,
    int? criticalGroupCount,
    int? dailyNeed,
    int? donationsToday,
    List<BloodGroupStock>? stockList,
    bool? showCriticalOnly,
  }) {
    return BloodStatsModel(
      totalUnits: totalUnits ?? this.totalUnits,
      criticalGroupCount: criticalGroupCount ?? this.criticalGroupCount,
      dailyNeed: dailyNeed ?? this.dailyNeed,
      donationsToday: donationsToday ?? this.donationsToday,
      stockList: stockList ?? this.stockList,
      showCriticalOnly: showCriticalOnly ?? this.showCriticalOnly,
    );
  }

  factory BloodStatsModel.fromJson(Map<String, dynamic> json) {
    final rawStocks = json['stockList'] as List<dynamic>? ?? [];

    return BloodStatsModel(
      totalUnits: (json['totalUnits'] as num?)?.toInt() ?? 0,
      criticalGroupCount: (json['criticalGroupCount'] as num?)?.toInt() ?? 0,
      dailyNeed: (json['dailyNeed'] as num?)?.toInt() ?? 0,
      donationsToday: (json['donationsToday'] as num?)?.toInt() ?? 0,
      stockList: rawStocks
          .map((e) => BloodGroupStock.fromJson(e as Map<String, dynamic>))
          .toList(),
      showCriticalOnly: json['showCriticalOnly'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUnits': totalUnits,
      'criticalGroupCount': criticalGroupCount,
      'dailyNeed': dailyNeed,
      'donationsToday': donationsToday,
      'stockList': stockList.map((e) => e.toJson()).toList(),
      'showCriticalOnly': showCriticalOnly,
    };
  }
}
