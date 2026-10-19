import 'package:flutter/material.dart';

/// Gece spor salonu paleti - Dark Obsidian & Neon renk sabitleri
abstract final class AppColors {
  // Arka Plan ve Zemin Renkleri (Obsidian)
  static const Color background = Color(0xFF080C10);
  static const Color surface = Color(0xFF101720);
  static const Color surfaceVariant = Color(0xFF182230);
  static const Color card = Color(0xFF131B26);
  static const Color cardBorder = Color(0xFF1F2E40);

  // Neon Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00F0FF); // Su ve hidrasyon
  static const Color neonCyanDark = Color(0xFF0099B8);
  static const Color neonLime = Color(0xFF25F482); // Hedef tamamlandı & canlılık
  static const Color neonOrange = Color(0xFFFF6B00); // Egzersiz & kalori
  static const Color neonFlame = Color(0xFFFF2E63); // Yüksek yoğunluk
  static const Color neonPurple = Color(0xFF9D4EDD); // Hatırlatıcılar & rozetler

  // Metin Renkleri (Koyu Tema)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Aydınlık Tema Zemin ve Yüzey Renkleri
  static const Color lightBackground = Color(0xFFF4F6F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEAEFF5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  // Aydınlık Tema Metin Renkleri
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Aydınlık Tema Vurgu Renkleri (Yüksek Kontrast & Okunabilirlik)
  static const Color lightCyan = Color(0xFF0284C7);
  static const Color lightLime = Color(0xFF16A34A);
  static const Color lightOrange = Color(0xFFEA580C);
  static const Color lightFlame = Color(0xFFE11D48);
  static const Color lightPurple = Color(0xFF7E22CE);

  // Gradyanlar
  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonCyan, Color(0xFF0088CC)],
  );

  static const LinearGradient limeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonLime, Color(0xFF00B4D8)],
  );

  static const LinearGradient flameGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonOrange, neonFlame],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonPurple, Color(0xFF5A189A)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF16212E), Color(0xFF0E151F)],
  );
}
