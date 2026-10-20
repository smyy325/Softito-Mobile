import 'package:flutter/foundation.dart';
import '../models/blood_stats_model.dart';

/// Kan stokları ve genel istatistik verilerini yöneten controller.
class BloodStatsController {
  BloodStatsController() {
    _initDefaultStocks();
  }

  /// Kan stok durumunu tutan reaktif ValueNotifier
  late final ValueNotifier<BloodStatsModel> stateNotifier;

  BloodStatsModel get state => stateNotifier.value;

  void _initDefaultStocks() {
    const initialStocks = [
      BloodGroupStock(
        bloodType: '0 Rh-',
        currentUnits: 3,
        minRequiredUnits: 15,
        capacityUnits: 50,
        status: 'Kritik',
      ),
      BloodGroupStock(
        bloodType: '0 Rh+',
        currentUnits: 28,
        minRequiredUnits: 30,
        capacityUnits: 60,
        status: 'Uyarı',
      ),
      BloodGroupStock(
        bloodType: 'A Rh-',
        currentUnits: 5,
        minRequiredUnits: 15,
        capacityUnits: 50,
        status: 'Kritik',
      ),
      BloodGroupStock(
        bloodType: 'A Rh+',
        currentUnits: 48,
        minRequiredUnits: 25,
        capacityUnits: 60,
        status: 'İdeal',
      ),
      BloodGroupStock(
        bloodType: 'B Rh-',
        currentUnits: 4,
        minRequiredUnits: 12,
        capacityUnits: 40,
        status: 'Kritik',
      ),
      BloodGroupStock(
        bloodType: 'B Rh+',
        currentUnits: 34,
        minRequiredUnits: 20,
        capacityUnits: 50,
        status: 'İdeal',
      ),
      BloodGroupStock(
        bloodType: 'AB Rh-',
        currentUnits: 2,
        minRequiredUnits: 8,
        capacityUnits: 30,
        status: 'Kritik',
      ),
      BloodGroupStock(
        bloodType: 'AB Rh+',
        currentUnits: 22,
        minRequiredUnits: 15,
        capacityUnits: 35,
        status: 'İdeal',
      ),
    ];

    final total = initialStocks.fold(0, (sum, item) => sum + item.currentUnits);
    final critical = initialStocks.where((s) => s.isCritical).length;

    stateNotifier = ValueNotifier<BloodStatsModel>(
      BloodStatsModel(
        totalUnits: total,
        criticalGroupCount: critical,
        dailyNeed: 45,
        donationsToday: 18,
        stockList: initialStocks,
      ),
    );
  }

  /// Yalnızca kritik stokları filtreleme durumunu değiştirir
  void toggleFilterCritical() {
    stateNotifier.value = state.copyWith(
      showCriticalOnly: !state.showCriticalOnly,
    );
  }

  /// Belirli bir kan grubuna stok ekler (simülasyon)
  void simulateDonation(String bloodType, int amount) {
    final updatedList = state.stockList.map((item) {
      if (item.bloodType == bloodType) {
        final newUnits = (item.currentUnits + amount).clamp(0, item.capacityUnits);
        final newStatus = newUnits <= item.minRequiredUnits
            ? 'Kritik'
            : (newUnits < item.minRequiredUnits + 5 ? 'Uyarı' : 'İdeal');
        return item.copyWith(currentUnits: newUnits, status: newStatus);
      }
      return item;
    }).toList();

    _updateState(updatedList, addedUnits: amount);
  }

  /// Belirli bir kan grubundan acil çıkış yapar (simülasyon)
  void simulateDispatch(String bloodType, int amount) {
    final updatedList = state.stockList.map((item) {
      if (item.bloodType == bloodType) {
        final newUnits = (item.currentUnits - amount).clamp(0, item.capacityUnits);
        final newStatus = newUnits <= item.minRequiredUnits
            ? 'Kritik'
            : (newUnits < item.minRequiredUnits + 5 ? 'Uyarı' : 'İdeal');
        return item.copyWith(currentUnits: newUnits, status: newStatus);
      }
      return item;
    }).toList();

    _updateState(updatedList, addedUnits: -amount);
  }

  void _updateState(List<BloodGroupStock> updatedList, {required int addedUnits}) {
    final total = updatedList.fold(0, (sum, item) => sum + item.currentUnits);
    final critical = updatedList.where((s) => s.isCritical).length;

    stateNotifier.value = state.copyWith(
      totalUnits: total,
      criticalGroupCount: critical,
      donationsToday: addedUnits > 0 ? state.donationsToday + addedUnits : state.donationsToday,
      stockList: updatedList,
    );
  }

  void dispose() {
    stateNotifier.dispose();
  }
}
