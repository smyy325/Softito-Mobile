import 'package:flutter/foundation.dart';

/// Tek bir kan bağışı kaydı
@immutable
class DonationRecord {
  final String id;
  final String date;
  final String location;
  final int units;
  final String bloodComponent;

  const DonationRecord({
    required this.id,
    required this.date,
    required this.location,
    required this.units,
    required this.bloodComponent,
  });

  DonationRecord copyWith({
    String? id,
    String? date,
    String? location,
    int? units,
    String? bloodComponent,
  }) {
    return DonationRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      location: location ?? this.location,
      units: units ?? this.units,
      bloodComponent: bloodComponent ?? this.bloodComponent,
    );
  }

  factory DonationRecord.fromJson(Map<String, dynamic> json) {
    return DonationRecord(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      units: (json['units'] as num?)?.toInt() ?? 1,
      bloodComponent: json['bloodComponent'] as String? ?? 'Tam Kan',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'location': location,
      'units': units,
      'bloodComponent': bloodComponent,
    };
  }
}

/// Kan bağış takip modülü ana durum modeli
@immutable
class DonationTrackerModel {
  final String donorName;
  final String bloodType;
  final int currentUnits;
  final int yearlyGoalUnits;
  final int totalUnits;
  final int savedLives;
  final List<int> monthlyDonations;
  final List<DonationRecord> history;

  const DonationTrackerModel({
    required this.donorName,
    required this.bloodType,
    required this.currentUnits,
    required this.yearlyGoalUnits,
    required this.totalUnits,
    required this.savedLives,
    required this.monthlyDonations,
    required this.history,
  });

  DonationTrackerModel copyWith({
    String? donorName,
    String? bloodType,
    int? currentUnits,
    int? yearlyGoalUnits,
    int? totalUnits,
    int? savedLives,
    List<int>? monthlyDonations,
    List<DonationRecord>? history,
  }) {
    return DonationTrackerModel(
      donorName: donorName ?? this.donorName,
      bloodType: bloodType ?? this.bloodType,
      currentUnits: currentUnits ?? this.currentUnits,
      yearlyGoalUnits: yearlyGoalUnits ?? this.yearlyGoalUnits,
      totalUnits: totalUnits ?? this.totalUnits,
      savedLives: savedLives ?? this.savedLives,
      monthlyDonations: monthlyDonations ?? this.monthlyDonations,
      history: history ?? this.history,
    );
  }

  factory DonationTrackerModel.fromJson(Map<String, dynamic> json) {
    final rawMonthly = json['monthlyDonations'] as List<dynamic>? ?? [];
    final rawHistory = json['history'] as List<dynamic>? ?? [];

    return DonationTrackerModel(
      donorName: json['donorName'] as String? ?? '',
      bloodType: json['bloodType'] as String? ?? '0 Rh+',
      currentUnits: (json['currentUnits'] as num?)?.toInt() ?? 0,
      yearlyGoalUnits: (json['yearlyGoalUnits'] as num?)?.toInt() ?? 4,
      totalUnits: (json['totalUnits'] as num?)?.toInt() ?? 0,
      savedLives: (json['savedLives'] as num?)?.toInt() ?? 0,
      monthlyDonations:
          rawMonthly.map((e) => (e as num).toInt()).toList(),
      history: rawHistory
          .map((e) => DonationRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donorName': donorName,
      'bloodType': bloodType,
      'currentUnits': currentUnits,
      'yearlyGoalUnits': yearlyGoalUnits,
      'totalUnits': totalUnits,
      'savedLives': savedLives,
      'monthlyDonations': monthlyDonations,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }
}
