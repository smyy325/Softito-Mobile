import 'package:flutter/material.dart';

/// Uygulamanın tema modunu (Sistem / Karanlık / Aydınlık)
/// `ValueNotifier<ThemeMode>` kullanarak reaktif olarak yöneten denetleyici.
class ThemeController {
  ThemeController._();

  /// Tekil (singleton) denetleyici örneği
  static final ThemeController instance = ThemeController._();

  /// Tema modunu tutan reaktif ValueNotifier
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  /// Geçerli tema modu
  ThemeMode get currentMode => themeModeNotifier.value;

  /// Tema modunu günceller
  void setThemeMode(ThemeMode mode) {
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
    }
  }

  /// Karanlık ve aydınlık mod arasında hızlı geçiş yapar
  void toggleTheme() {
    if (themeModeNotifier.value == ThemeMode.dark) {
      themeModeNotifier.value = ThemeMode.light;
    } else {
      themeModeNotifier.value = ThemeMode.dark;
    }
  }

  /// Sistem temasına ayarlar
  void setSystem() => setThemeMode(ThemeMode.system);

  /// Karanlık moda ayarlar
  void setDark() => setThemeMode(ThemeMode.dark);

  /// Aydınlık moda ayarlar
  void setLight() => setThemeMode(ThemeMode.light);

  /// Kaynakları serbest bırakır
  void dispose() {
    themeModeNotifier.dispose();
  }
}
