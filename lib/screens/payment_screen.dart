import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/popularity_package.dart';

class PaymentScreen extends StatelessWidget {
  final PopularityPackage package;
  final String gameId;
  final String characterName;

  const PaymentScreen({super.key, required this.package, required this.gameId, required this.characterName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Payment', style: TextStyle(color: isDark ? CupertinoColors.white : CupertinoColors.black)),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? CupertinoColors.systemGrey6 : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _summaryRow('Package', package.title, isDark),
                    _summaryRow('Popularity', '+${package.popularityAmount}', isDark),
                    _summaryRow('Game ID', gameId, isDark),
                    if (characterName.isNotEmpty) _summaryRow('Character', characterName, isDark),
                    const Divider(height: 24),
                    _summaryRow('Total', '₹${package.price}', isDark, isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? CupertinoColors.white : CupertinoColors.black)),
              const SizedBox(height: 16),
              _paymentTile(CupertinoIcons.money_dollar, 'Wallet', 'Balance: ₹0.00', isDark),
              _paymentTile(CupertinoIcons.qrcode, 'UPI / QR', 'Google Pay, PhonePe, Paytm', isDark),
              _paymentTile(CupertinoIcons.creditcard, 'Card', 'Visa, Mastercard', isDark),
              const Spacer(),
              CupertinoButton.filled(
                onPressed: () => showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text('Demo Payment'),
                    content: const Text('This is a demo. No actual payment processed.'),
                    actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.popUntil(context, (route) => route.isFirst))],
                  ),
                ),
                child: const Text('Pay Now'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isDark, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2)),
          Text(value, style: TextStyle(color: isTotal ? const Color(0xFFE23E57) : (isDark ? CupertinoColors.white : CupertinoColors.black), fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _paymentTile(IconData icon, String title, String subtitle, bool isDark) {
    return CupertinoListTile(
      leading: Icon(icon, color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const CupertinoListTileChevron(),
      onTap: () {},
    );
  }
}