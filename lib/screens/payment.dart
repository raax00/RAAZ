import 'dart:async';
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
  
  int _timeLeft = 59; // 59 Second Timer
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    upiUrl = "upi://pay?pa=$upiId&pn=BGMI%20Tournament&cu=INR";
    _startTimer();
    _autoDetectPayment(); // Auto detect simulate karne ke liye
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⏳ Time expired! Please try again.')),
          );
          Navigator.pop(context); // Time khatam hone pe wapas bhej dega
        }
      }
    });
  }

  // Backend ki jagah auto-detection mock
  void _autoDetectPayment() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _timeLeft > 0) {
        // Asli app mein yahan API call hogi payment status check karne ke liye
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Detected!')));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _txnController.dispose();
    super.dispose();
  }

  void _verifyPayment() {
    String txnId = _txnController.text.trim();
    if (txnId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter Transaction ID')));
      return;
    }
    
    setState(() {
      _isVerifying = true;
    });

    // API Call simulate kar raha hai 2 seconds ke liye
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
        _timer?.cancel(); // Payment ho gaya toh timer rok do
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Payment Verified for: $txnId')));
        Navigator.pop(context); // Success hone pe wapas bhej do
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Wallet Funds')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Timer UI
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _timeLeft < 10 
                    ? Colors.red.withOpacity(0.1) 
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _timeLeft < 10 ? Colors.red : Colors.orange,
                  width: 1,
                )
              ),
              child: Text(
                'Time remaining: 00:${_timeLeft.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: _timeLeft < 10 ? Colors.red : Colors.orange.shade700
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Scan to Pay', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 20),
            
            // QR Code Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)
                ]
              ),
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
              onPressed: _isVerifying ? null : _verifyPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B52D9),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: _isVerifying 
                  ? const SizedBox(
                      height: 24, width: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Verify Payment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
