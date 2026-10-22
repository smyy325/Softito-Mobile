import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:modum_galaxy/core/theme/theme_provider.dart';
import 'package:modum_galaxy/features/auth/providers/auth_provider.dart';
import 'package:modum_galaxy/features/notes/providers/notes_provider.dart';
import 'package:modum_galaxy/main.dart';

void main() {
  testWidgets('Modum Galaxy smoke test and initial load', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => NotesProvider()),
        ],
        child: const ModumGalaxyApp(),
      ),
    );

    // SplashScreen'in yüklendiğini doğrula
    expect(find.text('Modum Galaxy'), findsOneWidget);
    expect(find.text('Galaksiye Giriş Yap'), findsOneWidget);
  });
}
