import 'package:flutter/material.dart';
import 'package:asset_mdel/models/transation_model.dart';
class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  double _balance = 148950.00;
  
  final List<TransactionItem> _history = [
    const TransactionItem(
      id: "tx_init_1",
      title: 'Ahmet Yılmaz',
      category: 'Hızlı Transfer',
      date: 'bugün 11.30',
      amount: 1500.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
    const TransactionItem(
      id: "tx_init_2",
      title: 'Merve Demir',
      category: 'Hızlı Transfer',
      date: 'dün 15.45',
      amount: 2400.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
  ];

  void _openTransferModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        // ÇÖZÜM: Formu ayrı bir Widget'a taşıdık ve sadece gerekli verileri gönderiyoruz.
        return TransferBottomSheet(
          currentBalance: _balance,
          onTransfer: (name, amount) {
            setState(() {
              _balance -= amount;
              _history.insert(
                0,
                TransactionItem(
                  id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
                  title: name,
                  category: 'Hızlı Transfer',
                  date: 'Şimdi',
                  amount: amount,
                  isExpense: true,
                  icon: Icons.send_rounded,
                ),
              );
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$name kişisine ₺$amount başarıyla gönderildi!'),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Güncel Bakiye: ₺${_balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openTransferModal,
              child: const Text("Yeni Transfer Yap"),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// YENİ EKLENEN BÖLÜM: FORM İÇİN İZOLE EDİLMİŞ STATEFUL WIDGET
// ============================================================================
class TransferBottomSheet extends StatefulWidget {
  final double currentBalance;
  final Function(String, double) onTransfer;

  const TransferBottomSheet({
    super.key,
    required this.currentBalance,
    required this.onTransfer,
  });

  @override
  State<TransferBottomSheet> createState() => _TransferBottomSheetState();
}

class _TransferBottomSheetState extends State<TransferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    // RAM'de gereksiz yer kaplamaması için denetleyicileri yok ediyoruz
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Yeni Transfer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next, // Klavyede "ileri" butonunu çıkarır
                decoration: InputDecoration(
                  labelText: 'Alıcı Adı',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Alıcı adı boş olamaz' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done, // Klavyede "tamamla" butonunu çıkarır
                decoration: InputDecoration(
                  labelText: 'Tutar (₺)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Tutar giriniz';
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) return 'Geçerli bir tutar giriniz';
                  if (amount > widget.currentBalance) return 'Yetersiz bakiye. Mevcut: ₺${widget.currentBalance}';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final amount = double.parse(_amountController.text);
                    final name = _nameController.text;

                    Navigator.pop(context); // Önce modalı kapat
                    widget.onTransfer(name, amount); // Sonra ana sayfadaki fonksiyonu tetikle (bakiye düşme ve mesaj)
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Transferi Tamamla', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}