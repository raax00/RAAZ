import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/popularity_package.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final PopularityPackage package;
  const CheckoutScreen({super.key, required this.package});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _gameIdController = TextEditingController();
  final _characterNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void dispose() {
    _gameIdController.dispose();
    _characterNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Enter Details', style: TextStyle(color: isDark ? CupertinoColors.white : CupertinoColors.black)),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Package Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? CupertinoColors.systemGrey6 : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey5),
                ),
                child: Row(
                  children: [
                    Icon(widget.package.icon, size: 30, color: const Color(0xFF667eea)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.package.title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? CupertinoColors.white : CupertinoColors.black)),
                          Text('+${widget.package.popularityAmount} Popularity', style: const TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Text('₹${widget.package.price}', style: const TextStyle(color: Color(0xFFE23E57), fontWeight: FontWeight.w900, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text('Player Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? CupertinoColors.white : CupertinoColors.black)),
              const SizedBox(height: 12),
              // Game ID
              CupertinoTextFormFieldRow(
                controller: _gameIdController,
                keyboardType: TextInputType.number,
                placeholder: 'BGMI / PUBG Game ID *',
                prefix: const Icon(CupertinoIcons.game_controller, size: 20),
                validator: (v) => v == null || v.isEmpty ? 'Required' : (int.tryParse(v) == null ? 'Numeric only' : null),
              ),
              const SizedBox(height: 16),
              // Character Name
              CupertinoTextFormFieldRow(
                controller: _characterNameController,
                placeholder: 'Character Name (Optional)',
                prefix: const Icon(CupertinoIcons.person, size: 20),
              ),
              const SizedBox(height: 40),
              CupertinoButton.filled(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => PaymentScreen(
                          package: widget.package,
                          gameId: _gameIdController.text,
                          characterName: _characterNameController.text,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}