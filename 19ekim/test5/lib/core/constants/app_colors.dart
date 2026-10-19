import 'package:flutter/material.dart';

/// Gece spor salonu paleti (Dark Obsidian & Neon) sabit renk tanımları.
abstract final class AppColors {
  // Arka Plan ve Yüzeyler (Obsidian)
  static const Color obsidianBlack = Color(0xFF0B0E14);
  static const Color obsidianCard = Color(0xFF141923);
  static const Color obsidianSurface = Color(0xFF1B2230);
  static const Color obsidianElevated = Color(0xFF242E40);
  static const Color obsidianBorder = Color(0xFF2B374C);

  // Neon Su Vurguları (Cyan & Mavi)
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonCyanGlow = Color(0x3300E5FF);
  static const Color cyanDark = Color(0xFF0077B6);
  static const Color cyanLight = Color(0xFF90E0EF);

  // Neon Egzersiz Vurguları (Lime & Zümrüt)
  static const Color neonLime = Color(0xFFCCFF00);
  static const Color neonLimeGlow = Color(0x33CCFF00);
  static const Color neonEmerald = Color(0xFF00F5A0);

  // Neon Kalori ve Ateş Vurguları (Coral & Amber)
  static const Color neonCoral = Color(0xFFFF5252);
  static const Color neonCoralGlow = Color(0x33FF5252);
  static const Color neonAmber = Color(0xFFFFB703);

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Gradyanlar
  static const LinearGradient cyanWaterGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF00E5FF), Color(0xFF0077B6)],
  );

  static const LinearGradient limeWorkoutGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFCCFF00), Color(0xFF00F5A0)],
  );

  static const LinearGradient coralCalorieGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFFF5252), Color(0xFFFFB703)],
  );

  static const LinearGradient obsidianCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF161D2B), Color(0xFF0F141E)],
  );
}
