import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/urgent_requests_controller.dart';
import '../models/urgent_request_model.dart';
import '../widget/new_request_dialog.dart';
import '../widget/urgent_filter_bar.dart';
import '../widget/urgent_request_card.dart';

/// Acil kan talepleri listesi ve yönetim ekranı.
class UrgentRequestsView extends StatelessWidget {
  final UrgentRequestsController controller;

  UrgentRequestsView({
    super.key,
    UrgentRequestsController? controller,
  }) : controller = controller ?? UrgentRequestsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<String?>(
        valueListenable: controller.selectedBloodTypeNotifier,
        builder: (context, selectedFilter, _) {
          return ValueListenableBuilder<List<UrgentRequestModel>>(
            valueListenable: controller.requestsNotifier,
            builder: (context, requests, _) {
              final filtered = selectedFilter == null
                  ? requests
                  : requests.where((r) => r.bloodType == selectedFilter).toList();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  UrgentFilterBar(
                    selectedBloodType: selectedFilter,
                    onSelect: controller.filterByBloodType,
                  ),
                  const SizedBox(height: 16),
                  if (filtered.isEmpty)
                    const _EmptyRequests()
                  else
                    ...filtered.map((req) => _buildCard(req)),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Acil Talep Bildir',
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add_alert_rounded),
      ),
    );
  }

  Widget _buildCard(UrgentRequestModel req) {
    return UrgentRequestCard(
      request: req,
      onSupport: () => controller.supportDonation(req.id, 1),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewRequestDialog(onAdd: controller.addRequest),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          'Seçilen kan grubunda aktif acil talep bulunmuyor.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
