import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

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

class PopularityExchange {
  final String title;
  final String description;
  final int requiredPopularity;
  final String reward;
  final IconData icon;

  PopularityExchange({
    required this.title,
    required this.description,
    required this.requiredPopularity,
    required this.reward,
    required this.icon,
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
  int _userPopularity = 3420;

  // Admin Details
  final String adminPhone = "918406962570";
  final String adminEmail = "raaxbhaii@gmail.com";
  final String adminUpiId = "rajaowner@ybl"; // Change this to your real UPI ID

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

  final List<PopularityExchange> _exchangeOffers = [
    PopularityExchange(
      title: 'UC Bonus Pack',
      description: 'Get 600 UC + 100 Bonus',
      requiredPopularity: 500,
      reward: '600 UC',
      icon: CupertinoIcons.gift,
    ),
    PopularityExchange(
      title: 'Name Change Card',
      description: 'Change your in-game name',
      requiredPopularity: 800,
      reward: '1x Card',
      icon: CupertinoIcons.pencil_circle,
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
        // Wallet Button
        GestureDetector(
          onTap: () => _showTopUpDialog(),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF9A826), Color(0xFFE23E57)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE23E57).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.plus_app_fill,
                    color: Colors.white, size: 16),
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
        ),
      ],
    );
  }

  Widget _buildPopularityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF764ba2).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(CupertinoIcons.star_fill,
                color: Colors.amber, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Total Popularity',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$_userPopularity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
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
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
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
                          ? [Colors.amber.shade700, Colors.orange.shade600]
                          : [Colors.blue.shade400, Colors.indigo.shade600],
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
                          ElevatedButton(
                            onPressed: () => _showPurchaseDialog(package),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23E57),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Buy ₹${package.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
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
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          const Icon(CupertinoIcons.headphones, color: Colors.amber, size: 32),
          const SizedBox(height: 12),
          const Text(
            'SUPPORT CENTER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          
          // Name
          _supportRow(CupertinoIcons.person_solid, "Owner", "RAJA OWNER"),
          const SizedBox(height: 12),
          
          // Phone / WhatsApp
          GestureDetector(
            onTap: () => _sendToWhatsApp("Hello Support!"),
            child: _supportRow(Icons.chat, "WhatsApp", "+91 8406962570", isLink: true),
          ),
          const SizedBox(height: 12),
          
          // Email
          _supportRow(CupertinoIcons.mail_solid, "Email", "raaxbhaii@gmail.com"),
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
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isLink ? Colors.greenAccent : Colors.grey[400], size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            Text(
              value,
              style: TextStyle(
                color: isLink ? Colors.greenAccent : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== MODALS & ACTIONS ====================

  // Method to buy item using UTR
  void _showPurchaseDialog(PopularityPackage package) {
    final TextEditingController gameIdCtrl = TextEditingController();
    final TextEditingController utrCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE23E57).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(CupertinoIcons.star_fill,
                  color: Color(0xFFE23E57), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Buy ${package.title}',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  '1. Pay ₹${package.price} to UPI: $adminUpiId\n2. Enter Game ID & UTR below.',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              
              // Game ID Input
              TextField(
                controller: gameIdCtrl,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Enter Game ID',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // UTR Input
              TextField(
                controller: utrCtrl,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Enter 12-Digit UTR No.',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (gameIdCtrl.text.isEmpty || utrCtrl.text.isEmpty) {
                _showSnackbar("Please fill both Game ID and UTR.");
                return;
              }
              Navigator.pop(context);
              
              // Formatting WhatsApp Message
              String msg = "🔥 *NEW POPULARITY ORDER* 🔥\n\n"
                  "📦 *Item:* ${package.title}\n"
                  "💎 *Popularity:* +${package.popularityAmount}\n"
                  "💰 *Price:* ₹${package.price}\n"
                  "🎮 *Game ID:* ${gameIdCtrl.text}\n"
                  "✅ *UTR No:* ${utrCtrl.text}\n\n"
                  "Please verify payment and send popularity.";
                  
              _sendToWhatsApp(msg);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE23E57),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Submit Payment',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  // Method to Add Money to Wallet using UTR
  void _showTopUpDialog() {
    final TextEditingController amountCtrl = TextEditingController();
    final TextEditingController utrCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Money to Wallet',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send money to UPI: $adminUpiId and enter details to get wallet balance.',
                style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Amount Paid (₹)',
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: utrCtrl,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Enter 12-Digit UTR',
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountCtrl.text.isEmpty || utrCtrl.text.isEmpty) {
                _showSnackbar("Please fill all details.");
                return;
              }
              Navigator.pop(context);
              
              // Formatting WhatsApp Message
              String msg = "💳 *WALLET TOP-UP REQUEST* 💳\n\n"
                  "💰 *Amount Sent:* ₹${amountCtrl.text}\n"
                  "✅ *UTR No:* ${utrCtrl.text}\n\n"
                  "Please verify payment and add to my wallet.";
                  
              _sendToWhatsApp(msg);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9A826),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Send Details', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[900],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ==================== MAIN BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[950] : Colors.grey[50],
      appBar: _buildAppBar(),
      // Removed Bottom Navigation to keep the UI clean as requested.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildPopularityCard(),
              
              const SizedBox(height: 24),
              _buildSectionTitle('🎁 Buy Popularity'),
              const SizedBox(height: 12),
              ..._popularityPackages
                  .map((package) => _buildPopularityPackageCard(package)),
                  
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
