import 'package:flutter/foundation.dart';
import '../models/water_log_model.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(1250);
  final ValueNotifier<int> dailyGoal = ValueNotifier<int>(2500);
  final ValueNotifier<List<WaterLog>> logs = ValueNotifier<List<WaterLog>>([
    WaterLog(
      id: '1',
      amountMl: 500,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      drinkType: 'Su',
    ),
    WaterLog(
      id: '2',
      amountMl: 250,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      drinkType: 'Maden Suyu',
    ),
    WaterLog(
      id: '3',
      amountMl: 500,
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      drinkType: 'Su',
    ),
  ]);

  void addWater(int amount, {String drinkType = 'Su'}) {
    currentWater.value += amount;
    final newLog = WaterLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: amount,
      timestamp: DateTime.now(),
      drinkType: drinkType,
    );
    logs.value = [newLog, ...logs.value];
  }

  void removeLog(String id) {
    final target = logs.value.firstWhere(
      (element) => element.id == id,
      orElse: () => WaterLog(
        id: '',
        amountMl: 0,
        timestamp: DateTime.now(),
        drinkType: '',
      ),
    );
    if (target.id.isNotEmpty) {
      currentWater.value = (currentWater.value - target.amountMl).clamp(0, 99999);
      logs.value = logs.value.where((element) => element.id != id).toList();
    }
  }

  void resetWater() {
    currentWater.value = 0;
    logs.value = [];
  }

  void dispose() {
    currentWater.dispose();
    dailyGoal.dispose();
    logs.dispose();
  }
}
