import 'package:flutter/material.dart';

/// BuildContext üzerinde tema, renk şeması ve ekran boyutu
/// kısayolları sağlayan extension.
extension ContextExtensions on BuildContext {
  // ==========================================
  // Tema ve Renk Kısayolları
  // ==========================================

  /// Geçerli Theme nesnesi
  ThemeData get theme => Theme.of(this);

  /// Geçerli ColorScheme nesnesi
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Geçerli TextTheme nesnesi
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Cihaz veya uygulama karanlık modda mı?
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ==========================================
  // Ekran Boyutu ve MediaQuery Kısayolları
  // ==========================================

  /// MediaQueryData nesnesi
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Ekran boyut bilgisi
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Ekran genişliği
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Ekran yüksekliği
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Ekran çentik ve sistem padding bilgisi
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);

  // ==========================================
  // Bildirim ve Snackbar Kısayolları
  // ==========================================

  /// Hızlı bildirim göstermek için yardımcı fonksiyon
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
      ),
    );
  }
}
