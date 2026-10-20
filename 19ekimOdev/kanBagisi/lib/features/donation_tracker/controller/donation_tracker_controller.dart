import 'package:flutter/foundation.dart';
import '../models/donation_tracker_model.dart';

/// Kan bağış takip modülünün iş mantığını ve durumunu yöneten controller.
class DonationTrackerController {
  DonationTrackerController() {
    _initDefaultState();
  }

  /// Modül durumunu temsil eden reaktif ValueNotifier
  late final ValueNotifier<DonationTrackerModel> stateNotifier;

  DonationTrackerModel get state => stateNotifier.value;

  void _initDefaultState() {
    stateNotifier = ValueNotifier<DonationTrackerModel>(
      const DonationTrackerModel(
        donorName: 'Sümeyye',
        bloodType: '0 Rh+',
        currentUnits: 2,
        yearlyGoalUnits: 4,
        totalUnits: 7,
        savedLives: 21,
        monthlyDonations: [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        history: [
          DonationRecord(
            id: 'don-01',
            date: '15 Mart 2026',
            location: 'Kızılay Kadıköy Kan Merkezi',
            units: 1,
            bloodComponent: 'Tam Kan',
          ),
          DonationRecord(
            id: 'don-02',
            date: '10 Ocak 2026',
            location: 'Çapa Kan Bağış Noktası',
            units: 1,
            bloodComponent: 'Tam Kan',
          ),
        ],
      ),
    );
  }

  /// Yeni bir bağış kaydı ekler ve hedefe doğru ilerletir
  void addDonation({
    String location = 'Kızılay Kan Bağış Merkezi',
    String bloodComponent = 'Tam Kan',
  }) {
    final current = state;
    final newCurrentUnits = (current.currentUnits + 1).clamp(0, current.yearlyGoalUnits);
    final newTotalUnits = current.totalUnits + 1;
    final newSavedLives = newTotalUnits * 3;

    // Geçerli ay endeksini artır (Örnek: Ekim = 9)
    final currentMonthIndex = DateTime.now().month - 1;
    final updatedMonthly = List<int>.from(current.monthlyDonations);
    if (currentMonthIndex < updatedMonthly.length) {
      updatedMonthly[currentMonthIndex] += 1;
    }

    final newRecord = DonationRecord(
      id: 'don-${DateTime.now().millisecondsSinceEpoch}',
      date: _formatCurrentDate(),
      location: location,
      units: 1,
      bloodComponent: bloodComponent,
    );

    stateNotifier.value = current.copyWith(
      currentUnits: newCurrentUnits,
      totalUnits: newTotalUnits,
      savedLives: newSavedLives,
      monthlyDonations: updatedMonthly,
      history: [newRecord, ...current.history],
    );
  }

  /// Yıllık hedef sayacını sıfırlar
  void resetDonation() {
    final current = state;
    stateNotifier.value = current.copyWith(currentUnits: 0);
  }

  /// Yıllık hedefi günceller
  void setGoal(int goal) {
    if (goal < 1) return;
    final current = state;
    stateNotifier.value = current.copyWith(yearlyGoalUnits: goal);
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  void dispose() {
    stateNotifier.dispose();
  }
}
