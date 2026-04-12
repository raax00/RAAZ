import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

  // Admin contact details
  static const String adminPhone = "918406962570";
  static const String adminEmail = "raaxbhaii@gmail.com";

  final List<PopularityPackage> _popularityPackages = const [
    PopularityPackage(
      id: 'POP_BIKE',
      title: 'Motorcycle',
      description: 'Classic popularity booster',
      popularityAmount: 200,
      price: 49,
      icon: Icons.two_wheeler,
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
      icon: Icons.flight,
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
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
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

  // ==================== WhatsApp Launcher ====================
  Future<void> _sendToWhatsApp(String message) async {
    final String encodedMessage = Uri.encodeComponent(message);
    final Uri url = Uri.parse('https://wa.me/$adminPhone?text=$encodedMessage');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showSnackbar('Could not open WhatsApp. Please install it.');
      }
    } catch (e) {
      _showSnackbar('Error opening WhatsApp: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[900],
      ),
    );
  }

  // ==================== UI Builders ====================
  PreferredSizeWidget _buildAppBar(ThemeNotifier themeNotifier) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
          children: [
            TextSpan(text: 'POP', style: TextStyle(color: Color(0xFFF9A826))),
            TextSpan(text: 'STORE', style: TextStyle(color: Color(0xFFE23E57))),
          ],
        ),
      ),
      actions: [
        // Theme Toggle
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(
                isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
                color: isDark ? Colors.amber : Colors.orange,
                size: 16,
              ),
              Switch(
                value: isDark,
                activeColor: const Color(0xFFE23E57),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (_) => themeNotifier.toggleTheme(),
              ),
            ],
          ),
        ),
        // Wallet Balance
        Container(
          margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF9A826), Color(0xFFE23E57)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.plus_app_fill, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                '₹${_walletBalance.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF764ba2).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(CupertinoIcons.star_fill,
                color: Colors.amber, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Total Popularity',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_userPopularity',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularityPackageCard(PopularityPackage package) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? Colors.grey[900] : Colors.white,
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: package.isPremium
                          ? [Colors.amber.shade600, Colors.orange.shade500]
                          : [Colors.blue.shade400, Colors.indigo.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(package.icon, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.title,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.description,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(CupertinoIcons.star_fill,
                                  color: Color(0xFFF9A826), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '+${package.popularityAmount}',
                                style: const TextStyle(
                                  color: Color(0xFFF9A826),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          // Buy Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => CheckoutScreen(package: package),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23E57),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Buy ₹${package.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildSupportCenter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
      ),
      child: Column(
        children: [
          const Icon(CupertinoIcons.headphones, color: Colors.amber, size: 32),
          const SizedBox(height: 12),
          Text(
            'SUPPORT CENTER',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.white24 : Colors.black12),
          const SizedBox(height: 16),
          _supportRow(CupertinoIcons.person_solid, "Owner", "RAJA OWNER"),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _sendToWhatsApp("Hello Support!"),
            child: _supportRow(Icons.chat, "WhatsApp", "+91 8406962570", isLink: true),
          ),
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
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isLink ? Colors.green : (isDark ? Colors.grey[400] : Colors.grey[700]),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
            ),
            Text(
              value,
              style: TextStyle(
                color: isLink ? Colors.green : (isDark ? Colors.white : Colors.black87),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[950] : Colors.grey[50],
      appBar: _buildAppBar(themeNotifier),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildPopularityCard(),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(CupertinoIcons.gift_fill, color: Color(0xFFE23E57), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Buy Popularity',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._popularityPackages.map(_buildPopularityPackageCard),
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