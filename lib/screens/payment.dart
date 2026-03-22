import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _txnController = TextEditingController();
  final String upiId = "paynearby.8406962570@indus";
  late String upiUrl;

  @override
  void initState() {
    super.initState();
    upiUrl = "upi://pay?pa=$upiId&pn=Kidly%20Premium&cu=INR";
  }

  void _verifyPayment() {
    String txnId = _txnController.text.trim();
    if(txnId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Transaction ID')));
      return;
    }
    // TODO: Backend API call here to verify TXN ID
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verifying Txn ID: $txnId ...')));
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Go Premium')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.amber, size: 80),
            const SizedBox(height: 20),
            Text('Scan to Pay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: QrImageView(data: upiUrl, version: QrVersions.auto, size: 200.0, backgroundColor: Colors.white),
            ),
            const SizedBox(height: 20),
            Text('UPI ID: $upiId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 40),
            
            // Transaction Verification Section
            const Text('Already paid? Verify your transaction', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: _txnController,
              decoration: InputDecoration(
                hintText: 'Enter 12-digit UTR / Transaction ID',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B52D9),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Verify Payment', style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
