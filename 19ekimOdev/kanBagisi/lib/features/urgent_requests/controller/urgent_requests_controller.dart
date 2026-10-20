import 'package:flutter/foundation.dart';
import '../models/urgent_request_model.dart';

/// Acil kan taleplerini ve filtrelemeyi yöneten controller.
class UrgentRequestsController {
  UrgentRequestsController() {
    _initDefaultRequests();
  }

  /// Tüm acil talepler listesi
  late final ValueNotifier<List<UrgentRequestModel>> requestsNotifier;

  /// Seçili kan grubu filtresi (null ise tümü)
  final ValueNotifier<String?> selectedBloodTypeNotifier =
      ValueNotifier<String?>(null);

  List<UrgentRequestModel> get requests => requestsNotifier.value;
  String? get selectedBloodType => selectedBloodTypeNotifier.value;

  void _initDefaultRequests() {
    requestsNotifier = ValueNotifier<List<UrgentRequestModel>>([
      const UrgentRequestModel(
        id: 'urg-101',
        patientName: 'Merve Aydın',
        hospitalName: 'Çapa Tıp Fakültesi Hastanesi',
        city: 'İstanbul',
        district: 'Fatih',
        bloodType: '0 Rh-',
        requiredUnits: 3,
        collectedUnits: 1,
        urgencyLevel: 'Kritik',
        contactPhone: '+90 532 111 22 33',
        notes: 'Açık kalp ameliyatı için acil 0 Rh- kana ihtiyaç duyulmaktadır.',
        createdAt: '10 dk önce',
      ),
      const UrgentRequestModel(
        id: 'urg-102',
        patientName: 'Ali Kaya',
        hospitalName: 'Kartal Dr. Lütfi Kırdar Şehir Hast.',
        city: 'İstanbul',
        district: 'Kartal',
        bloodType: 'A Rh-',
        requiredUnits: 2,
        collectedUnits: 0,
        urgencyLevel: 'Kritik',
        contactPhone: '+90 544 222 33 44',
        notes: 'Trafik kazası sonrası yoğun bakım ünitesinde takip edilmektedir.',
        createdAt: '25 dk önce',
      ),
      const UrgentRequestModel(
        id: 'urg-103',
        patientName: 'Zeynep Demir',
        hospitalName: 'Ankara Şehir Hastanesi',
        city: 'Ankara',
        district: 'Çankaya',
        bloodType: 'B Rh-',
        requiredUnits: 4,
        collectedUnits: 2,
        urgencyLevel: 'Acil',
        contactPhone: '+90 555 333 44 55',
        notes: 'Hematoloji kliniğinde acil replasman tedavisi için aranıyor.',
        createdAt: '1 saat önce',
      ),
      const UrgentRequestModel(
        id: 'urg-104',
        patientName: 'Mehmet Çelik',
        hospitalName: 'Ege Üniversitesi Hastanesi',
        city: 'İzmir',
        district: 'Bornova',
        bloodType: '0 Rh+',
        requiredUnits: 2,
        collectedUnits: 1,
        urgencyLevel: 'Yüksek',
        contactPhone: '+90 505 444 55 66',
        notes: 'Ortopedi cerrahisi öncesi kan rezervi gerekmektedir.',
        createdAt: '2 saat önce',
      ),
    ]);
  }

  /// Kan grubuna göre filtreleme yapar
  void filterByBloodType(String? bloodType) {
    selectedBloodTypeNotifier.value = bloodType;
  }

  /// Yeni acil talep ekler
  void addRequest(UrgentRequestModel newRequest) {
    requestsNotifier.value = [newRequest, ...requestsNotifier.value];
  }

  /// Talebe bağış desteği sağlar (simülasyon)
  void supportDonation(String id, int units) {
    requestsNotifier.value = requestsNotifier.value.map((req) {
      if (req.id == id) {
        final newCollected = (req.collectedUnits + units).clamp(0, req.requiredUnits);
        final isCompleted = newCollected >= req.requiredUnits;
        return req.copyWith(
          collectedUnits: newCollected,
          isFulfilled: isCompleted,
        );
      }
      return req;
    }).toList();
  }

  void dispose() {
    requestsNotifier.dispose();
    selectedBloodTypeNotifier.dispose();
  }
}
