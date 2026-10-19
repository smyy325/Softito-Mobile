import 'package:flutter/material.dart';

/// Sistem ve kullanıcı tema tercihlerini yöneten reaktif kontrolcü.
/// [SKILL.md] ve [project.md] mimari standartlarına uygun olarak [ValueNotifier] kullanır.
class ThemeController {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  ThemeController({ThemeMode initialMode = ThemeMode.system})
      : themeModeNotifier = ValueNotifier<ThemeMode>(initialMode);

  ThemeMode get currentMode => themeModeNotifier.value;

  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;
  bool get isLightMode => themeModeNotifier.value == ThemeMode.light;
  bool get isSystemMode => themeModeNotifier.value == ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
    }
  }

  void setDarkMode() => setThemeMode(ThemeMode.dark);
  void setLightMode() => setThemeMode(ThemeMode.light);
  void setSystemMode() => setThemeMode(ThemeMode.system);

  void toggleTheme() {
    switch (themeModeNotifier.value) {
      case ThemeMode.system:
        themeModeNotifier.value = ThemeMode.dark;
      case ThemeMode.dark:
        themeModeNotifier.value = ThemeMode.light;
      case ThemeMode.light:
        themeModeNotifier.value = ThemeMode.system;
    }
  }

  void dispose() {
    themeModeNotifier.dispose();
  }
}
