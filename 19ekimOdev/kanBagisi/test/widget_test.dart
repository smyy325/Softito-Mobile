import 'package:flutter_test/flutter_test.dart';
import 'package:kan_ver/main.dart';

void main() {
  testWidgets('KanVer app smoke test', (WidgetTester tester) async {
    // KanVer uygulamasını başlat ve render et
    await tester.pumpWidget(const KanVerApp());
    await tester.pumpAndSettle();

    // Başlık ve navigasyon butonlarını doğrula
    expect(find.text('Kan Bağışı Takibi'), findsOneWidget);
    expect(find.text('Takip'), findsOneWidget);
    expect(find.text('Stoklar'), findsOneWidget);
    expect(find.text('Acil'), findsOneWidget);
  });
}
