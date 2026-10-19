import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/calorie_tracker/controller/calorie_tracker_controller.dart';
import 'package:susadim/features/reminders/controller/reminder_controller.dart';
import 'package:susadim/features/reminders/models/reminder_item.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/main.dart';

void main() {
  group('WaterTrackerController Birim Testleri', () {
    test('Başlangıç durumu varsayılan hedefleri doğru ayarlamalıdır', () {
      final WaterTrackerController controller = WaterTrackerController();
      expect(controller.targetMl, 2500);
      expect(controller.totalConsumedMl, 0);
      expect(controller.logs.isEmpty, isTrue);
      expect(controller.goal.progressPercentage, 0.0);
    });

    test('Su ekleme işlemi toplam tüketimi ve kayıtları artırmalıdır', () {
      final WaterTrackerController controller = WaterTrackerController();
      controller.addWater(250, beverageType: 'Su');

      expect(controller.totalConsumedMl, 250);
      expect(controller.logs.length, 1);
      expect(controller.logs.first.amountMl, 250);
      expect(controller.goal.remainingMl, 2250);
    });

    test('Kayıt silme işlemi toplam tüketimi güncellemelidir', () {
      final WaterTrackerController controller = WaterTrackerController();
      controller.addWater(250, beverageType: 'Su');
      final String logId = controller.logs.first.id;

      controller.removeLog(logId);
      expect(controller.totalConsumedMl, 0);
      expect(controller.logs.isEmpty, isTrue);
    });

    test('Sıfırlama işlemi tüm kayıtları temizlemelidir', () {
      final WaterTrackerController controller = WaterTrackerController();
      controller.addWater(250);
      controller.addWater(500);
      expect(controller.totalConsumedMl, 750);

      controller.resetToday();
      expect(controller.totalConsumedMl, 0);
      expect(controller.logs.isEmpty, isTrue);
    });
  });

  group('WorkoutController Birim Testleri', () {
    test('Başlangıç durumu varsayılan kalori hedefini doğru ayarlamalıdır', () {
      final WorkoutController controller = WorkoutController();
      expect(controller.targetCalories, 500);
      expect(controller.totalBurnedCalories, 0);
      expect(controller.totalDurationMinutes, 0);
      expect(controller.workouts.isEmpty, isTrue);
    });

    test('Egzersiz ekleme işlemi yakılan kaloriyi artırmalıdır', () {
      final WorkoutController controller = WorkoutController();
      controller.addQuickWorkout(
        title: 'Koşu',
        category: 'Kardiyo',
        durationMinutes: 20,
        caloriesBurned: 180,
      );

      expect(controller.totalBurnedCalories, 180);
      expect(controller.totalDurationMinutes, 20);
      expect(controller.workouts.length, 1);
      expect(controller.goal.remainingCalories, 320);
    });

    test('Antrenman silme işlemi toplamları güncellemelidir', () {
      final WorkoutController controller = WorkoutController();
      controller.addQuickWorkout(
        title: 'Koşu',
        category: 'Kardiyo',
        durationMinutes: 20,
        caloriesBurned: 180,
      );
      final String id = controller.workouts.first.id;

      controller.removeWorkout(id);
      expect(controller.totalBurnedCalories, 0);
      expect(controller.workouts.isEmpty, isTrue);
    });
  });

  group('CalorieTrackerController Birim Testleri', () {
    test('Başlangıç durumu varsayılan değerleri doğru olmalıdır', () {
      final CalorieTrackerController controller = CalorieTrackerController();
      expect(controller.targetCalories, 2000);
      expect(controller.totalConsumedCalories, 0);
      expect(controller.totalProtein, 0);
      expect(controller.meals.isEmpty, isTrue);
    });

    test('Öğün ekleme kalori ve makroları doğru toplamalıdır', () {
      final CalorieTrackerController controller = CalorieTrackerController();
      controller.addQuickMeal(
        name: 'Yulaf',
        mealType: 'Kahvaltı',
        calories: 300,
        protein: 15,
        carbs: 45,
        fat: 5,
      );

      expect(controller.totalConsumedCalories, 300);
      expect(controller.totalProtein, 15);
      expect(controller.totalCarbs, 45);
      expect(controller.totalFat, 5);
      expect(controller.meals.length, 1);
    });

    test('Öğün silme işlemi listeyi ve toplamları güncellemelidir', () {
      final CalorieTrackerController controller = CalorieTrackerController();
      controller.addQuickMeal(
        name: 'Tavuk',
        mealType: 'Öğle',
        calories: 400,
        protein: 40,
      );
      final String id = controller.meals.first.id;

      controller.removeMeal(id);
      expect(controller.totalConsumedCalories, 0);
      expect(controller.meals.isEmpty, isTrue);
    });
  });

  group('ReminderController Birim Testleri', () {
    test('Varsayılan hatırlatıcılar yüklenmiş olmalıdır', () {
      final ReminderController controller = ReminderController();
      expect(controller.reminders.length, greaterThanOrEqualTo(2));
      expect(controller.activeCount, greaterThanOrEqualTo(2));
    });

    test('Hatırlatıcı aktif/pasif durumu değiştirilebilmelidir', () {
      final ReminderController controller = ReminderController();
      final String firstId = controller.reminders.first.id;
      final bool initialStatus = controller.reminders.first.isEnabled;

      controller.toggleReminder(firstId);
      expect(
        controller.reminders.firstWhere((r) => r.id == firstId).isEnabled,
        !initialStatus,
      );
    });

    test('Yeni hatırlatıcı eklenebilmeli ve silinebilmelidir', () {
      final ReminderController controller = ReminderController();
      final int initialCount = controller.reminders.length;

      const ReminderItem newItem = ReminderItem(
        id: 'test_123',
        title: 'Test Hatırlatıcı',
        hour: 10,
        minute: 0,
      );
      controller.addReminder(newItem);
      expect(controller.reminders.length, initialCount + 1);

      controller.removeReminder('test_123');
      expect(controller.reminders.length, initialCount);
    });
  });

  group('SusadimApp Arayüz ve Entegrasyon Testleri', () {
    testWidgets('Uygulama açılır ve tüm sekmeler arasında geçiş yapılır',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SusadimApp());
      await tester.pumpAndSettle();

      // Su Takip Sekmesi
      expect(find.text('SUSADIM'), findsOneWidget);
      expect(find.text('0 ml'), findsOneWidget);

      // +250 ml butonuna dokunulması
      await tester.tap(find.text('+250 ml'));
      await tester.pumpAndSettle();
      expect(find.text('250 ml'), findsOneWidget);

      // Egzersiz Sekmesine geçiş
      await tester.tap(find.text('Egzersiz'));
      await tester.pumpAndSettle();
      expect(find.text('GÜÇ & ENERJİ'), findsOneWidget);

      // Kalori Sekmesine geçiş
      await tester.tap(find.text('Kalori'));
      await tester.pumpAndSettle();
      expect(find.text('BESLENME & MAKRO'), findsOneWidget);

      // Hatırlatıcı Sekmesine geçiş
      await tester.tap(find.text('Hatırlatıcı'));
      await tester.pumpAndSettle();
      expect(find.text('BİLDİRİM & ALIŞKANLIK'), findsOneWidget);
    });
  });
}
