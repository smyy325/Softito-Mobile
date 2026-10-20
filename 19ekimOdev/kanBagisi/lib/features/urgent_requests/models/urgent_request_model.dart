import 'package:flutter/foundation.dart';

/// Acil kan bağışı talebi veri modeli
@immutable
class UrgentRequestModel {
  final String id;
  final String patientName;
  final String hospitalName;
  final String city;
  final String district;
  final String bloodType;
  final int requiredUnits;
  final int collectedUnits;
  final String urgencyLevel;
  final String contactPhone;
  final String notes;
  final String createdAt;
  final bool isFulfilled;

  const UrgentRequestModel({
    required this.id,
    required this.patientName,
    required this.hospitalName,
    required this.city,
    required this.district,
    required this.bloodType,
    required this.requiredUnits,
    required this.collectedUnits,
    required this.urgencyLevel,
    required this.contactPhone,
    required this.notes,
    required this.createdAt,
    this.isFulfilled = false,
  });

  double get progressRatio =>
      requiredUnits > 0 ? (collectedUnits / requiredUnits).clamp(0.0, 1.0) : 0.0;

  int get remainingUnits =>
      (requiredUnits - collectedUnits).clamp(0, requiredUnits);

  UrgentRequestModel copyWith({
    String? id,
    String? patientName,
    String? hospitalName,
    String? city,
    String? district,
    String? bloodType,
    int? requiredUnits,
    int? collectedUnits,
    String? urgencyLevel,
    String? contactPhone,
    String? notes,
    String? createdAt,
    bool? isFulfilled,
  }) {
    return UrgentRequestModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      hospitalName: hospitalName ?? this.hospitalName,
      city: city ?? this.city,
      district: district ?? this.district,
      bloodType: bloodType ?? this.bloodType,
      requiredUnits: requiredUnits ?? this.requiredUnits,
      collectedUnits: collectedUnits ?? this.collectedUnits,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      contactPhone: contactPhone ?? this.contactPhone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isFulfilled: isFulfilled ?? this.isFulfilled,
    );
  }

  factory UrgentRequestModel.fromJson(Map<String, dynamic> json) {
    return UrgentRequestModel(
      id: json['id'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      hospitalName: json['hospitalName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      bloodType: json['bloodType'] as String? ?? '0 Rh+',
      requiredUnits: (json['requiredUnits'] as num?)?.toInt() ?? 1,
      collectedUnits: (json['collectedUnits'] as num?)?.toInt() ?? 0,
      urgencyLevel: json['urgencyLevel'] as String? ?? 'Acil',
      contactPhone: json['contactPhone'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      isFulfilled: json['isFulfilled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'hospitalName': hospitalName,
      'city': city,
      'district': district,
      'bloodType': bloodType,
      'requiredUnits': requiredUnits,
      'collectedUnits': collectedUnits,
      'urgencyLevel': urgencyLevel,
      'contactPhone': contactPhone,
      'notes': notes,
      'createdAt': createdAt,
      'isFulfilled': isFulfilled,
    };
  }
}
