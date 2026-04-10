import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

// NOTE: Apni paths ke hisab se adjust kar lein
import '../main.dart'; // Make sure themeNotifier is defined here
import 'payment.dart'; // Aapka payment screen

// ==================== MODELS ====================

class PopularityPackage {
  final String id;
  final String title;
  final String description;
  final int popularityAmount;
  final double price;
  final IconData icon;
  final bool isPremium;

  PopularityPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.popularityAmount,
    required this.price,
    required this.icon,
    this.isPremium = false,
  });
}

// ==================== HOME PAGE ====================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final double _walletBalance = 0.00;
  final int _userPopularity = 3420;

  // Admin Details for Support
  final String adminPhone = "918406962570";
  final String adminEmail = "raaxbhaii@gmail.com";

  final List<PopularityPackage> _popularityPackages = [
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

  // ==================== WHATSAPP LAUNCHER ====================
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

  // ==================== UI BUILDERS ====================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: RichText(
        text: const TextSpan(
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic),
          children: [
            TextSpan(text: 'POP', style: TextStyle(color: Color(0xFFF9A826))),
            TextSpan(text: 'STORE', style: TextStyle(color: Color(0xFFE23E57))),
          ],
        ),
      ),
      actions: [
        // Dark/Light Theme Switch
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
                  color: isDark ? Colors.amber : Colors.orange, size: 16),
              Switch(
                value: isDark,
                activeColor: const Color(0xFFE23E57),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  // Apne main.dart ke hisab se ise adjust karein
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ],
          ),
        ),
        // Wallet Button
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
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.grey[900]!, Colors.grey[850]!]
                  : [Colors.white, Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
                // Icon
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
                  child: Center(
                    child: Icon(package.icon, size: 40, color: Colors.white),
                  ),
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
                          // BUY BUTTON -> GOES TO CHECKOUT PAGE
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => CheckoutPage(package: package),
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
          child: Icon(icon, color: isLink ? Colors.green : (isDark ? Colors.grey[400] : Colors.grey[700]), size: 18),
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
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[950] : Colors.grey[50],
      appBar: _buildAppBar(),
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
              ..._popularityPackages.map((package) => _buildPopularityPackageCard(package)),
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

// ==================== CHECKOUT PAGE (PAY PAGE) ====================
class CheckoutPage extends StatefulWidget {
  final PopularityPackage package;

  const CheckoutPage({super.key, required this.package});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _gameIdController = TextEditingController();
  final TextEditingController _characterNameController = TextEditingController();

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void dispose() {
    _gameIdController.dispose();
    _characterNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[950] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          'Enter Details',
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Item Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(widget.package.icon, size: 30, color: const Color(0xFF667eea)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.package.title, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('+${widget.package.popularityAmount} Popularity', style: const TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Text('₹${widget.package.price}', style: const TextStyle(color: Color(0xFFE23E57), fontWeight: FontWeight.w900, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            Text('Player Information', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Game ID Input
            TextField(
              controller: _gameIdController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter BGMI / PUBG Game ID',
                prefixIcon: const Icon(CupertinoIcons.game_controller),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            // Character Name Input
            TextField(
              controller: _characterNameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter Character Name (Optional)',
                prefixIcon: const Icon(CupertinoIcons.person),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 40),

            // Proceed Button -> Goes to payment.dart
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_gameIdController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Game ID')));
                    return;
                  }
                  
                  // Yahan se aapke payment.dart screen par jayega
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const PaymentPage(), // Aapka payment screen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE23E57),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Proceed to Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
