import 'package:flutter/material.dart';
import '../controller/donation_tracker_controller.dart';
import '../models/donation_tracker_model.dart';
import '../widget/donation_history_list.dart';
import '../widget/donation_tracker_card.dart';
import '../widget/monthly_donation_chart.dart';

/// Kan bağış takip modülü ana ekranı.
class DonationTrackerView extends StatelessWidget {
  final DonationTrackerController controller;

  DonationTrackerView({
    super.key,
    DonationTrackerController? controller,
  }) : controller = controller ?? DonationTrackerController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DonationTrackerModel>(
      valueListenable: controller.stateNotifier,
      builder: (context, state, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DonationTrackerCard(
              donorName: state.donorName,
              bloodType: state.bloodType,
              currentUnits: state.currentUnits,
              goalUnits: state.yearlyGoalUnits,
              totalUnits: state.totalUnits,
              savedLives: state.savedLives,
              onAddDonation: controller.addDonation,
              onReset: controller.resetDonation,
            ),
            const SizedBox(height: 16),
            MonthlyDonationChart(monthlyData: state.monthlyDonations),
            const SizedBox(height: 16),
            DonationHistoryList(records: state.history),
          ],
        );
      },
    );
  }
}
