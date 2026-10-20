import 'package:flutter/material.dart';

class LayoutStylingScreen extends StatefulWidget {
  const LayoutStylingScreen({super.key});

  @override
  State<LayoutStylingScreen> createState() => _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> {
  bool _isBalanceVisible = true;
  String _lastAction = 'Hazır - Butonlara tıklayabilirsiniz';
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil online rozeti
            _buildProfileHeader(),
            // Cüzdan Kartı
            _buildWalletCard(),
            // Aksiyon butonları
            _buildQuickActions(),
            // İstatistik bölümü
            _buildFlexStatistics(),
            // Notification bildirim banner
            _buildNotificationBanner(),

            // Canlı Durum Bildirimi
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Son İşlem: $_lastAction',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x1F6366F1),
                  border: Border.all(
                    color: const Color(0xFF6366F1),
                    width: 2,
                  ),
                ), // BoxDecoration
              ), // Container
            ],
          ), // Stack
        ],
      ), // Row
    ); // Padding
  }

  Widget _buildWalletCard() {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Cüzdan Kartı Alanı"),
      ),
    );
  }

  Widget _buildQuickActions() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Aksiyon 1"),
          Text("Aksiyon 2"),
          Text("Aksiyon 3"),
        ],
      ),
    );
  }

  Widget _buildFlexStatistics() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text("İstatistik Bölümü"),
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.blue.shade50,
      child: const Text("Bildirim Banner Alanı"),
    );
  }
}