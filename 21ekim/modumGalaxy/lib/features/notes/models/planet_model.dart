import 'package:flutter/material.dart';

/// Gezegen modeli - Duygu Galaksisindeki bir gezegeni ve taşıdığı ruh halini temsil eder.
class PlanetModel {
  final String id;
  final String name;
  String moodLabel;
  final String description;
  final String imagePath;
  final Color primaryColor;
  final Color secondaryColor;

  PlanetModel({
    required this.id,
    required this.name,
    required this.moodLabel,
    required this.description,
    required this.imagePath,
    required this.primaryColor,
    required this.secondaryColor,
  });

  PlanetModel copyWith({
    String? id,
    String? name,
    String? moodLabel,
    String? description,
    String? imagePath,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return PlanetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      moodLabel: moodLabel ?? this.moodLabel,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }

  static List<PlanetModel> get defaultPlanets => [
        PlanetModel(
          id: 'jupiter',
          name: 'Jüpiter',
          moodLabel: 'Mutlu & Coşkulu',
          description: 'Pozitif enerji ve yüksek yaşam sevinci.',
          imagePath: 'assets/images/planets/planet_jupiter.png',
          primaryColor: const Color(0xFFF39C12),
          secondaryColor: const Color(0xFFF1C40F),
        ),
        PlanetModel(
          id: 'neptune',
          name: 'Neptün',
          moodLabel: 'Huzurlu & Sakin',
          description: 'Zihinsel dinginlik, içsel barış ve rahatlama.',
          imagePath: 'assets/images/planets/planet_neptune.png',
          primaryColor: const Color(0xFF2980B9),
          secondaryColor: const Color(0xFF3498DB),
        ),
        PlanetModel(
          id: 'earth',
          name: 'Dünya',
          moodLabel: 'Dengeli & Üretken',
          description: 'Odaklanmış zihin, verimli çalışma ve denge.',
          imagePath: 'assets/images/planets/planet_earth.png',
          primaryColor: const Color(0xFF27AE60),
          secondaryColor: const Color(0xFF2ECC71),
        ),
        PlanetModel(
          id: 'saturn',
          name: 'Satürn',
          moodLabel: 'Melankolik & Dalgın',
          description: 'Derin düşünceler, hüzün ve nostalji.',
          imagePath: 'assets/images/planets/planet_saturn.png',
          primaryColor: const Color(0xFF8E44AD),
          secondaryColor: const Color(0xFF9B59B6),
        ),
        PlanetModel(
          id: 'mars',
          name: 'Mars',
          moodLabel: 'Stresli & Hareketli',
          description: 'Yüksek tempo, gerginlik veya yoğun koşturmaca.',
          imagePath: 'assets/images/planets/planet_mars.png',
          primaryColor: const Color(0xFFC0392B),
          secondaryColor: const Color(0xFFE74C3C),
        ),
        PlanetModel(
          id: 'uranus',
          name: 'Uranüs',
          moodLabel: 'Yaratıcı & İlhamlı',
          description: 'Özgün fikirler, sanat ve ilham kıvılcımları.',
          imagePath: 'assets/images/planets/planet_uranus.png',
          primaryColor: const Color(0xFF16A085),
          secondaryColor: const Color(0xFF1ABC9C),
        ),
        PlanetModel(
          id: 'venus',
          name: 'Venüs',
          moodLabel: 'Sevgi Dolu & Umutlu',
          description: 'Sıcak ilişkiler, şefkat ve geleceğe inanç.',
          imagePath: 'assets/images/planets/planet_venus.png',
          primaryColor: const Color(0xFFE84393),
          secondaryColor: const Color(0xFFFD79A8),
        ),
        PlanetModel(
          id: 'mercury',
          name: 'Merkür',
          moodLabel: 'Meraklı & Hızlı',
          description: 'Yeni şeyler öğrenme arzusu ve hareketlilik.',
          imagePath: 'assets/images/planets/planet_mercury.png',
          primaryColor: const Color(0xFF7F8C8D),
          secondaryColor: const Color(0xFFBDC3C7),
        ),
      ];
}
