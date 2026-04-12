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
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final double _walletBalance = 0.00;
  final int _userPopularity = 3420;

  static const String adminPhone = "918406962570";
  static const String adminEmail = "raaxbhaii@gmail.com";

  // ─── Color Palette ───────────────────────────────────────────────────────────
  static const Color _gold   = Color(0xFFF9A826);
  static const Color _red    = Color(0xFFE23E57);
  static const Color _purple = Color(0xFF764ba2);
  static const Color _violet = Color(0xFF667eea);

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
      icon: CupertinoIcons.airplane,
      isPremium: true,
    ),
  ];

  // ─── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  /// Responsive: compact on phones < 380 px wide
  double get _hPad {
    final w = MediaQuery.of(context).size.width;
    return w < 380 ? 12 : 16;
  }

  bool get _isTablet => MediaQuery.of(context).size.width >= 600;

  Future<void> _sendToWhatsApp(String message) async {
    final url = Uri.parse(
        'https://wa.me/$adminPhone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showSnackbar('WhatsApp not installed');
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  // ─── AppBar ──────────────────────────────────────────────────────────────────
  ObstructingPreferredSizeWidget _buildAppBar(ThemeNotifier themeNotifier) {
    return CupertinoNavigationBar(
      backgroundColor: (isDark
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.lightBackgroundGray)
          .withOpacity(0.92),
      border: null,
      leading: const SizedBox.shrink(),
      middle: const Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
          ),
          children: [
            TextSpan(text: 'POP', style: TextStyle(color: _gold)),
            TextSpan(text: 'STORE', style: TextStyle(color: _red)),
          ],
        ),
      ),
      trailing: _AppBarTrailing(
        isDark: isDark,
        walletBalance: _walletBalance,
        onThemeToggle: themeNotifier.toggleTheme,
      ),
    );
  }

  // ─── Popularity Hero Card ─────────────────────────────────────────────────
  Widget _buildPopularityCard() {
    final size = MediaQuery.of(context).size;
    final iconBox = size.width < 380 ? 56.0 : 68.0;
    final statFontSize = size.width < 380 ? 24.0 : 30.0;

    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: _hPad + 4,
          vertical: _isTablet ? 28 : 22,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_violet, _purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: _purple.withOpacity(0.38),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon bubble
            Container(
              height: iconBox,
              width: iconBox,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                CupertinoIcons.star_fill,
                color: CupertinoColors.systemYellow,
                size: iconBox * 0.50,
              ),
            ),
            const SizedBox(width: 18),
            // Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Total Popularity',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.80),
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_userPopularity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: statFontSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Progress pill
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_userPopularity % 5000) / 5000,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${((_userPopularity % 5000) / 5000 * 100).toStringAsFixed(0)}% to next tier',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.70),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Package Card ─────────────────────────────────────────────────────────
  Widget _buildPackageCard(PopularityPackage pkg, int index) {
    final delay = Duration(milliseconds: 100 * index);

    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        final visible = snapshot.connectionState == ConnectionState.done;
        return AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, 0.15),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: _PackageCardContent(
              pkg: pkg,
              isDark: isDark,
              isTablet: _isTablet,
              onBuy: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => CheckoutScreen(package: pkg)),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Support Center ───────────────────────────────────────────────────────
  Widget _buildSupportCenter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_hPad + 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemYellow.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.headphones,
                  color: CupertinoColors.systemYellow,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'SUPPORT CENTER',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 1.5,
                  color:
                      isDark ? CupertinoColors.white : CupertinoColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.08),
            height: 1,
          ),
          const SizedBox(height: 18),
          // Rows
          _supportRow(
            CupertinoIcons.person_solid,
            "Owner",
            "RAJA OWNER",
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => _sendToWhatsApp("Hello Support! I need help."),
            child: _supportRow(
              CupertinoIcons.chat_bubble_fill,
              "WhatsApp",
              "+91 8406962570",
              isLink: true,
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Chat now',
                  style: TextStyle(
                    color: CupertinoColors.systemGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _supportRow(
            CupertinoIcons.mail_solid,
            "Email",
            adminEmail,
          ),
        ],
      ),
    );
  }

  Widget _supportRow(
    IconData icon,
    String label,
    String value, {
    bool isLink = false,
    Widget? trailing,
  }) {
    final iconColor = isLink
        ? CupertinoColors.systemGreen
        : (isDark
            ? CupertinoColors.systemGrey
            : CupertinoColors.systemGrey2);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 17),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? CupertinoColors.systemGrey
                      : CupertinoColors.systemGrey2,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: isLink
                      ? CupertinoColors.systemGreen
                      : (isDark
                          ? CupertinoColors.white
                          : CupertinoColors.black),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  // ─── Section Header ───────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: isDark ? CupertinoColors.white : CupertinoColors.black,
          ),
        ),
      ],
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: _buildAppBar(themeNotifier),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              _hPad,
              16,
              _hPad,
              40,
            ),
            child: _isTablet
                ? _buildTabletLayout(screenWidth)
                : _buildPhoneLayout(),
          ),
        ),
      ),
    );
  }

  // ─── Phone Layout (single column) ────────────────────────────────────────
  Widget _buildPhoneLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPopularityCard(),
        const SizedBox(height: 28),
        _buildSectionHeader('Buy Popularity', CupertinoIcons.gift_fill, _red),
        const SizedBox(height: 16),
        ...List.generate(
          _popularityPackages.length,
          (i) => _buildPackageCard(_popularityPackages[i], i),
        ),
        const SizedBox(height: 10),
        _buildSupportCenter(),
      ],
    );
  }

  // ─── Tablet Layout (two-column) ───────────────────────────────────────────
  Widget _buildTabletLayout(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPopularityCard(),
        const SizedBox(height: 32),
        _buildSectionHeader('Buy Popularity', CupertinoIcons.gift_fill, _red),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _popularityPackages
              .asMap()
              .entries
              .map((e) => SizedBox(
                    width: (width - _hPad * 2 - 16) / 2,
                    child: _buildPackageCard(e.value, e.key),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        _buildSupportCenter(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets (extracted for clean rebuild scoping)
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarTrailing extends StatelessWidget {
  const _AppBarTrailing({
    required this.isDark,
    required this.walletBalance,
    required this.onThemeToggle,
  });

  final bool isDark;
  final double walletBalance;
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Theme toggle
        CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 36,
          onPressed: onThemeToggle,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isDark
                  ? CupertinoIcons.moon_fill
                  : CupertinoIcons.sun_max_fill,
              key: ValueKey(isDark),
              color: isDark
                  ? CupertinoColors.systemYellow
                  : CupertinoColors.systemOrange,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Wallet badge
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF9A826), Color(0xFFE23E57)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE23E57).withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.plus_app_fill,
                color: Colors.white,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                '₹${walletBalance.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PackageCardContent extends StatefulWidget {
  const _PackageCardContent({
    required this.pkg,
    required this.isDark,
    required this.isTablet,
    required this.onBuy,
  });

  final PopularityPackage pkg;
  final bool isDark;
  final bool isTablet;
  final VoidCallback onBuy;

  @override
  State<_PackageCardContent> createState() => _PackageCardContentState();
}

class _PackageCardContentState extends State<_PackageCardContent> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final pkg = widget.pkg;
    final isDark = widget.isDark;

    final List<Color> iconGradient = pkg.isPremium
        ? [Colors.amber.shade600, Colors.deepOrange.shade400]
        : [Colors.blue.shade400, Colors.indigo.shade600];

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1C1C1E)
                : CupertinoColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: pkg.isPremium
                  ? Colors.amber.withOpacity(isDark ? 0.35 : 0.45)
                  : (isDark
                      ? Colors.white.withOpacity(0.09)
                      : Colors.black.withOpacity(0.07)),
              width: pkg.isPremium ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (pkg.isPremium
                        ? Colors.amber
                        : Colors.indigo)
                    .withOpacity(isDark ? 0.12 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                height: 76,
                width: 76,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: iconGradient),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.last.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(pkg.icon, size: 36, color: Colors.white),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pkg.title,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                              color: isDark
                                  ? CupertinoColors.white
                                  : CupertinoColors.black,
                            ),
                          ),
                        ),
                        if (pkg.isPremium) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFF9A826),
                                  Color(0xFFE23E57)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pkg.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? CupertinoColors.systemGrey
                            : CupertinoColors.systemGrey2,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Popularity badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9A826).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                CupertinoIcons.star_fill,
                                color: Color(0xFFF9A826),
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+${pkg.popularityAmount}',
                                style: const TextStyle(
                                  color: Color(0xFFF9A826),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Buy button
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 9),
                          color: const Color(0xFFE23E57),
                          borderRadius: BorderRadius.circular(14),
                          onPressed: widget.onBuy,
                          child: Text(
                            '₹${pkg.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              letterSpacing: 0.2,
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
    );
  }
}
