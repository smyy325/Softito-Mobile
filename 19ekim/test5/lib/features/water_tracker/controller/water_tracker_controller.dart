import 'package:flutter/foundation.dart';
import '../models/water_log.dart';

/// Flutter çekirdek ChangeNotifier API'si ile su takibi durum yöneticisi.
class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({int initialTargetMl = 2500})
      : _targetMl = initialTargetMl;

  int _targetMl;
  final List<WaterLog> _logs = <WaterLog>[];

  int get targetMl => _targetMl;

  List<WaterLog> get logs => List<WaterLog>.unmodifiable(_logs);

  int get totalConsumedMl =>
      _logs.fold<int>(0, (int sum, WaterLog item) => sum + item.amountMl);

  DailyWaterGoal get goal => DailyWaterGoal(
        targetMl: _targetMl,
        consumedMl: totalConsumedMl,
      );

  void addWater(int amountMl, {String beverageType = 'Su'}) {
    if (amountMl <= 0) return;

    final WaterLog newLog = WaterLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      beverageType: beverageType,
    );

    _logs.insert(0, newLog);
    notifyListeners();
  }

  void removeLog(String id) {
    _logs.removeWhere((WaterLog log) => log.id == id);
    notifyListeners();
  }

  void setTarget(int newTargetMl) {
    if (newTargetMl < 500) return;
    _targetMl = newTargetMl;
    notifyListeners();
  }

  void resetToday() {
    _logs.clear();
    notifyListeners();
  }
}
