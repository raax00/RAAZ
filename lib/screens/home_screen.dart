import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/popularity_package.dart';
import '../utils/theme_notifier.dart';
import 'checkout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final double _walletBalance = 0.00;
  final int _userPopularity = 3420;

  static const String adminPhone = "918406962570";
  static const String adminEmail = "raaxbhaii@gmail.com";

  final List<PopularityPackage> _popularityPackages = const [
    PopularityPackage(
      id: 'POP_BIKE',
      title: 'Motorcycle',
      description: 'Classic popularity booster',
      popularityAmount: 200,
      price: 49,
      icon: Icons.two_wheeler, // FIXED: CupertinoIcons.bicycle does not exist
    ),
    PopularityPackage(
      id: 'POP_CAR',
      title: 'Sports Car',
      description: 'Premium ride for special friends',
      popularityAmount: 1000,
      price: 249,
      icon: CupertinoIcons.car_detailed,
      isPremium: true,
    ),
    PopularityPackage(
      id: 'POP_PLANE',
      title: 'Airplane',
      description: 'The ultimate popularity flex',
      popularityAmount: 5000,
      price: 999,
      icon: CupertinoIcons.airplane,
      isPremium: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Future<void> _sendToWhatsApp(String message) async {
    final url = Uri.parse('https://wa.me/$adminPhone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showSnackbar('WhatsApp not installed');
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  // FIXED: Return type changed to ObstructingPreferredSizeWidget
  ObstructingPreferredSizeWidget _buildAppBar(ThemeNotifier themeNotifier) {
    return CupertinoNavigationBar(
      backgroundColor: isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.lightBackgroundGray,
      border: null,
      leading: const SizedBox(),
      middle: const Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
          children: [
            TextSpan(text: 'POP', style: TextStyle(color: Color(0xFFF9A826))),
            TextSpan(text: 'STORE', style: TextStyle(color: Color(0xFFE23E57))),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: themeNotifier.toggleTheme,
            child: Icon(
              isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
              color: isDark ? CupertinoColors.systemYellow : CupertinoColors.systemOrange,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFF9A826), Color(0xFFE23E57)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.plus_app_fill, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text('₹${_walletBalance.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF764ba2).withOpacity(0.3), blurRadius: 15)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
            child: const Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Total Popularity', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 4),
                Text('$_userPopularity', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(PopularityPackage pkg) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey5),
          ),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: pkg.isPremium ? [Colors.amber.shade600, Colors.orange.shade500] : [Colors.blue.shade400, Colors.indigo.shade500],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(pkg.icon, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pkg.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: isDark ? CupertinoColors.white : CupertinoColors.black)),
                    const SizedBox(height: 4),
                    Text(pkg.description, style: TextStyle(fontSize: 12, color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(CupertinoIcons.star_fill, color: Color(0xFFF9A826), size: 16),
                            const SizedBox(width: 4),
                            Text('+${pkg.popularityAmount}', style: const TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.w800)),
                          ],
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          color: const Color(0xFFE23E57),
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => CheckoutScreen(package: pkg))),
                          child: Text('Buy ₹${pkg.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCenter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? CupertinoColors.systemGrey6 : CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(CupertinoIcons.headphones, color: CupertinoColors.systemYellow, size: 32),
          const SizedBox(height: 12),
          Text('SUPPORT CENTER', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: isDark ? CupertinoColors.white : CupertinoColors.black)),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _supportRow(CupertinoIcons.person_solid, "Owner", "RAJA OWNER"),
          const SizedBox(height: 12),
          GestureDetector(onTap: () => _sendToWhatsApp("Hello Support!"), child: _supportRow(CupertinoIcons.chat_bubble, "WhatsApp", "+91 8406962570", isLink: true)),
          const SizedBox(height: 12),
          _supportRow(CupertinoIcons.mail_solid, "Email", adminEmail),
        ],
      ),
    );
  }

  Widget _supportRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: isLink ? CupertinoColors.systemGreen : (isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2), size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2, fontSize: 12)),
            Text(value, style: TextStyle(color: isLink ? CupertinoColors.systemGreen : (isDark ? CupertinoColors.white : CupertinoColors.black), fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return CupertinoPageScaffold(
      navigationBar: _buildAppBar(themeNotifier),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPopularityCard(),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(CupertinoIcons.gift_fill, color: Color(0xFFE23E57), size: 20),
                  const SizedBox(width: 8),
                  Text('Buy Popularity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: isDark ? CupertinoColors.white : CupertinoColors.black)),
                ],
              ),
              const SizedBox(height: 16),
              ..._popularityPackages.map(_buildPackageCard),
              const SizedBox(height: 16),
              _buildSupportCenter(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}