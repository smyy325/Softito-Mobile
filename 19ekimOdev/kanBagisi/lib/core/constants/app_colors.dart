import 'package:flutter/material.dart';

/// KanVer uygulaması renk paleti.
/// Dark Obsidian & Crimson Neon (karanlık mod) ve Modern Medikal (aydınlık mod)
/// renk tanımlarını içerir.
abstract final class AppColors {
  // ==========================================
  // Dark Obsidian & Crimson Neon (Karanlık Mod)
  // ==========================================

  /// Derin Obsidiyen arka plan (#0B0E14)
  static const Color darkBackground = Color(0xFF0B0E14);

  /// Koyu panel ve kart yüzeyi (#131722)
  static const Color darkSurface = Color(0xFF131722);

  /// İkincil panel ve vurgulu kart yüzeyi (#1B2232)
  static const Color darkSurfaceVariant = Color(0xFF1B2232);

  /// İnce sınır ve ayraç rengi (#263044)
  static const Color darkBorder = Color(0xFF263044);

  /// Canlı Crimson Neon ana vurgusu (#FF1E46)
  static const Color darkPrimary = Color(0xFFFF1E46);

  /// Koyu Crimson Neon varyantı (#E00034)
  static const Color darkPrimaryVariant = Color(0xFFE00034);

  /// Neon kırmızı-pembe geçiş tonu (#FF4D6D)
  static const Color darkSecondary = Color(0xFFFF4D6D);

  /// Soğuk medikal siyan (Plazma & Trombosit vurguları) (#00E5FF)
  static const Color darkTertiary = Color(0xFF00E5FF);

  /// Karanlık mod birincil metin rengi (#F1F5F9)
  static const Color darkTextPrimary = Color(0xFFF1F5F9);

  /// Karanlık mod ikincil metin rengi (#94A3B8)
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  /// Karanlık mod pasif/açıklama metin rengi (#64748B)
  static const Color darkTextMuted = Color(0xFF64748B);

  // ==========================================
  // Modern Medikal (Aydınlık Mod)
  // ==========================================

  /// Ferah klinik arka plan (#F8FAFC)
  static const Color lightBackground = Color(0xFFF8FAFC);

  /// Saf beyaz panel ve kart yüzeyi (#FFFFFF)
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Yumuşak medikal kart yüzeyi (#EFF4F9)
  static const Color lightSurfaceVariant = Color(0xFFEFF4F9);

  /// Temiz medikal sınır ve ayraç (#E2E8F0)
  static const Color lightBorder = Color(0xFFE2E8F0);

  /// Canlı medikal kırmızı (#D32F2F)
  static const Color lightPrimary = Color(0xFFD32F2F);

  /// Derin cerrahi kırmızı varyantı (#9A0007)
  static const Color lightPrimaryVariant = Color(0xFF9A0007);

  /// İkincil medikal mercan tonu (#E53935)
  static const Color lightSecondary = Color(0xFFE53935);

  /// Klinik plazma mavisi (#0288D1)
  static const Color lightTertiary = Color(0xFF0288D1);

  /// Aydınlık mod birincil metin rengi (#0F172A)
  static const Color lightTextPrimary = Color(0xFF0F172A);

  /// Aydınlık mod ikincil metin rengi (#475569)
  static const Color lightTextSecondary = Color(0xFF475569);

  /// Aydınlık mod pasif metin rengi (#94A3B8)
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // ==========================================
  // Durum Renkleri (Medical Statuses)
  // ==========================================

  /// Kritik / Acil durum rengi (#FF1744)
  static const Color statusCritical = Color(0xFFFF1744);

  /// Uyarı / Düşük stok seviyesi (#FF9100)
  static const Color statusWarning = Color(0xFFFF9100);

  /// İdeal / Başarılı stok seviyesi (#00C853)
  static const Color statusSuccess = Color(0xFF00C853);

  /// Bilgilendirme / Randevu rengi (#2979FF)
  static const Color statusInfo = Color(0xFF2979FF);
}
