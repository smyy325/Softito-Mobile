import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transation_model.dart'; 

class MarketsGridListScreen extends StatelessWidget {
  const MarketsGridListScreen({super.key});

  static const List<Asset> assets = [
    Asset(
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 67420.00,
      change24h: 4.20,
      balance: 0.4,
    ),
    Asset(
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3500.00,
      change24h: -1.80,
      balance: 4.20,
    ),
    Asset(
      symbol: 'SOL',
      name: 'Solana',
      price: 200.00,
      change24h: 0.5,
      balance: 85.00,
    ),
  ];

  static const List<TransactionItem> transations = [
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_2',
        title: 'Kodusta Danışmanlık Hakediş',
        category: 'Kurumsal Gelir',
        date: 'Dün 09:00',
        amount: 125000.00,
        isExpense: false,
        icon: Icons.account_balance),
    TransactionItem(
        id: 'tx_3',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_4',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Piyasalar (Grid) Başlığı
          const Text(
            'Piyasalar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // 2. Varlıklar GridView Alanı
          GridView.builder(
            shrinkWrap: true, // ScrollView içinde hata vermemesi için şart
            physics: const NeverScrollableScrollPhysics(), // Kaydırmayı ana ScrollView'a bırakır
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Yan yana 2 kart
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1, // Kartların en-boy oranı
            ),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              return AssetCard(asset: assets[index]);
            },
          ),
          
          const SizedBox(height: 32),

          // 3. Son İşlemler (List) Başlığı
          const Text(
            'Son İşlemler',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 4. İşlemler ListView Alanı
          ListView.builder(
            shrinkWrap: true, // ScrollView içinde hata vermemesi için şart
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transations.length,
            itemBuilder: (context, index) {
              return TransactionTile(transaction: transations[index]);
            },
          ),
        ],
      ),
    );
  }
}

// --- MODÜLER WIDGET'LAR ---

// Varlıklar için Grid Kartı Widget'ı
class AssetCard extends StatelessWidget {
  final Asset asset;

  const AssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    // Yüzdelik değişime göre renk belirleme
    final isPositive = asset.change24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                asset.symbol,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "${isPositive ? '+' : ''}${asset.change24h}%",
                style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            asset.name,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const Spacer(),
          Text(
            "\$${asset.price.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            "Bakiye: ${asset.balance}",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Son İşlemler için Liste Elemanı Widget'ı
class TransactionTile extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Gelir/Gider durumuna göre tutar rengi ve formatı
    final amountColor = transaction.isExpense ? Colors.red.shade700 : Colors.green.shade700;
    final amountPrefix = transaction.isExpense ? "-" : "+";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0x1F6366F1),
          child: Icon(transaction.icon, color: const Color(0xFF6366F1)),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${transaction.category} • ${transaction.date}"),
        trailing: Text(
          "$amountPrefix ₺${transaction.amount.toStringAsFixed(0)}",
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}