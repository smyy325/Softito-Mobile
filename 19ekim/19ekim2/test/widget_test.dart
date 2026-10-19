import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/core/theme/widget/theme_mode_switch_button.dart';
import 'package:susadim/main.dart';

void main() {
  group('ThemeController Birim Testleri', () {
    test('Varsayılan tema modu ThemeMode.system olmalıdır', () {
      final controller = ThemeController();
      expect(controller.currentMode, ThemeMode.system);
      expect(controller.isSystemMode, isTrue);
      expect(controller.isDarkMode, isFalse);
      expect(controller.isLightMode, isFalse);
      controller.dispose();
    });

    test('Tema modları başarıyla değiştirilebilmelidir', () {
      final controller = ThemeController();

      controller.setDarkMode();
      expect(controller.currentMode, ThemeMode.dark);
      expect(controller.isDarkMode, isTrue);

      controller.setLightMode();
      expect(controller.currentMode, ThemeMode.light);
      expect(controller.isLightMode, isTrue);

      controller.setSystemMode();
      expect(controller.currentMode, ThemeMode.system);
      expect(controller.isSystemMode, isTrue);

      controller.dispose();
    });

    test('toggleTheme sırasıyla system -> dark -> light -> system geçişi yapmalıdır', () {
      final controller = ThemeController();

      controller.toggleTheme();
      expect(controller.currentMode, ThemeMode.dark);

      controller.toggleTheme();
      expect(controller.currentMode, ThemeMode.light);

      controller.toggleTheme();
      expect(controller.currentMode, ThemeMode.system);

      controller.dispose();
    });
  });

  group('Arayüz ve Tema Entegrasyon Testleri', () {
    testWidgets('Susadım v1 temel arayüz ve modül geçiş testi',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SusadimApp());
      await tester.pumpAndSettle();

      // Su Takibi ekranının açıldığını doğrula
      expect(find.text('Su Takibi'), findsWidgets);
      expect(find.text('Hızlı Ekle'), findsOneWidget);

      // Egzersiz sekmesine geçiş yap
      await tester.tap(find.text('Egzersiz'));
      await tester.pumpAndSettle();
      expect(find.text('Egzersiz & Antrenman'), findsOneWidget);

      // Kalori sekmesine geçiş yap
      await tester.tap(find.text('Kalori'));
      await tester.pumpAndSettle();
      expect(find.text('Kalori & Beslenme'), findsOneWidget);

      // Hatırlatıcı sekmesine geçiş yap
      await tester.tap(find.text('Hatırlatıcı'));
      await tester.pumpAndSettle();
      expect(find.text('Akıllı Hatırlatıcılar'), findsOneWidget);
    });

    testWidgets('Tema seçim menüsü açılmalı ve tema modu güncellenmelidir',
        (WidgetTester tester) async {
      final themeController = ThemeController();

      await tester.pumpWidget(SusadimApp(themeController: themeController));
      await tester.pumpAndSettle();

      // Tema butonunun ekranda olduğunu doğrula
      expect(find.byType(ThemeModeSwitchButton), findsOneWidget);

      // Tema butonuna dokun
      await tester.tap(find.byType(ThemeModeSwitchButton));
      await tester.pumpAndSettle();

      // Alt sayfanın açıldığını ve seçenekleri doğrula
      expect(find.text('Tema Seçimi'), findsOneWidget);
      expect(find.text('Karanlık Mod'), findsOneWidget);
      expect(find.text('Aydınlık Mod'), findsOneWidget);
      expect(find.text('Sistem Varsayılanı'), findsOneWidget);

      // 'Karanlık Mod' seçeneğine tıkla
      await tester.tap(find.text('Karanlık Mod'));
      await tester.pumpAndSettle();

      expect(themeController.currentMode, ThemeMode.dark);

      // Tekrar aç ve 'Aydınlık Mod' seç
      await tester.tap(find.byType(ThemeModeSwitchButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aydınlık Mod'));
      await tester.pumpAndSettle();

      expect(themeController.currentMode, ThemeMode.light);

      themeController.dispose();
    });
  });
}
