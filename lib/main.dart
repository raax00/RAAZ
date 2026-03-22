import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Global Theme Notifier for System/Light/Dark mode
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const KidlyApp());
}

class KidlyApp extends StatelessWidget {
  const KidlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Kidly Clone',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF6B52D9),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF6B52D9),
            scaffoldBackgroundColor: const Color(0xFF121212),
            useMaterial3: true,
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}

// ==========================================
// 1. MAIN NAVIGATION (BOTTOM TABS)
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DummyPage(title: 'Relax', icon: Icons.spa),
    const DummyPage(title: 'Discover', icon: Icons.explore),
    const DummyPage(title: 'Sleep', icon: Icons.nightlight_round),
    const DummyPage(title: 'RoBoBo', icon: Icons.smart_toy),
    const DummyPage(title: 'Adventure', icon: Icons.landscape),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? Colors.black : Colors.white,
        selectedItemColor: const Color(0xFF6B52D9),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.book_fill), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.spa_outlined), label: 'Relax'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.compass), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.moon_zzz), label: 'Sleep'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: 'RoBoBo'),
          BottomNavigationBarItem(icon: Icon(Icons.landscape_outlined), label: 'Adventure'),
        ],
      ),
    );
  }
}

// ==========================================
// 2. HOME PAGE
// ==========================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'k', style: TextStyle(color: Color(0xFF6B52D9))),
              TextSpan(text: 'idly', style: TextStyle(color: Color(0xFF38B6FF))),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: isDark ? Colors.white : Colors.black, size: 20),
              Switch(
                value: isDark,
                activeColor: const Color(0xFF6B52D9),
                onChanged: (value) {
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
          // LOCAL ASSET IMAGE HERE
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/profile.jpg'), // Ensure this file is in assets folder
            backgroundColor: Colors.grey, // Fallback color
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Go Premium Button (Fixed Icon)
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (_) => const PremiumPaymentPage()));
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B52D9), Color(0xFF38B6FF)],
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.white), // FIXED ICON
                    SizedBox(width: 8),
                    Text('Go Premium', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(CupertinoIcons.search, color: Colors.grey),
                  hintText: 'Books, Categories, Topics and',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('NATURE AND OUR WORLD', style: TextStyle(color: Colors.teal[300], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text('An innocent wish...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF4A4A68))),
            Text('Could it lead to great turmoil?', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 16),
            
            // LOCAL ASSET CARD
            GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (_) => const BookDetailsPage()));
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.purple.withOpacity(0.6),
                  image: const DecorationImage(
                    image: AssetImage('assets/book_bg.jpg'), // Local Asset
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black26)),
                    const Positioned(
                      top: 20, left: 20,
                      child: Text("Zozo's\nWish", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                    Positioned(
                      bottom: 20, left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(color: const Color(0xFF38B6FF), borderRadius: BorderRadius.circular(20)),
                        child: const Text('EXPLORE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)]),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kidly's Badge Awarded\nLeadership Board", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("Remaining time:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                          child: const Text('0 Day 3 Hrs 48 Min', style: TextStyle(color: Colors.white, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                  const Icon(Icons.workspace_premium, color: Colors.amber, size: 60), // FIXED ICON
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. BOOK DETAILS PAGE
// ==========================================
class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  color: Colors.orange[300],
                  // LOCAL ASSET IMAGE HERE
                  child: Image.asset('assets/cover.jpg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                     return const Center(child: Text('Image missing in assets/', style: TextStyle(color: Colors.white)));
                  }),
                ),
                Positioned(
                  top: 50, left: 16,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(backgroundColor: Colors.white70, child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20)),
                  ),
                ),
              ],
            ),
            Container(
              color: const Color(0xFFFBBF24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSettingOption('Language', 'English', Icons.chat_bubble_outline),
                  _buildSettingOption('Read-Aloud', 'On', Icons.volume_up_outlined),
                  _buildSettingOption('Autoplay', 'On', Icons.play_circle_outline),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (_) => const ReadingPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B4D9B),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Start Reading', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionIcon(Icons.add_box_outlined, 'Add to list', isDark),
                _buildActionIcon(Icons.download_outlined, 'Download', isDark),
                _buildActionIcon(CupertinoIcons.heart, 'Like', isDark),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Zozo's Wish", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[800])),
                  const SizedBox(height: 12),
                  Text(
                    "Why do giraffes have such long necks? What would happen if, for one day only, all animals could have necks just as long?\nDo you think they'd be able to continue with their normal lives? Or ...",
                    style: TextStyle(fontSize: 16, height: 1.5, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(width: 4),
            Icon(icon, size: 14, color: Colors.black54),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
            if (label == 'Language') const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87),
          ],
        )
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)],
          ),
          child: Icon(icon, color: isDark ? Colors.white : Colors.grey[700], size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

// ==========================================
// 4. READING PAGE
// ==========================================
class ReadingPage extends StatelessWidget {
  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE28B5E),
      body: Stack(
        children: [
          // LOCAL ASSET IMAGE HERE
          Positioned.fill(
            child: Image.asset(
              'assets/reading_bg.jpg', 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.orange[200]),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.black, size: 30)),
                      const Icon(Icons.menu, color: Colors.black, size: 30),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBE385),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: const Text(
                      "One day, when he was munching the leaves of his favorite tree, Zozo noticed something. He looked at the lion, the zebra, the elephant, the monkey, the hippopotamus, and the rhinoceros. Then, he turned to look at his mom.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.4),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 5. PREMIUM PAYMENT PAGE (QR, UPI INTENT, WEBVIEW)
// ==========================================
class PremiumPaymentPage extends StatefulWidget {
  const PremiumPaymentPage({super.key});

  @override
  State<PremiumPaymentPage> createState() => _PremiumPaymentPageState();
}

class _PremiumPaymentPageState extends State<PremiumPaymentPage> {
  final String upiId = "paynearby.8406962570@indus";
  late String upiUrl;

  @override
  void initState() {
    super.initState();
    upiUrl = "upi://pay?pa=$upiId&pn=Kidly%20Premium&cu=INR";
  }

  // UPI Intent Function using url_launcher
  Future<void> _launchUPIApp() async {
    final Uri uri = Uri.parse(upiUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError("No UPI app found on your phone.");
      }
    } catch (e) {
      _showError("Failed to open UPI app.");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Go Premium'), backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 80), // FIXED ICON
              const SizedBox(height: 20),
              Text('Unlock All Features!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 10),
              const Text('Scan the QR Code below from any UPI App to activate Premium manually.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 30),
              
              // OFFLINE QR CODE GENERATOR (using qr_flutter package)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
                ),
                child: QrImageView(
                  data: upiUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text('UPI ID: $upiId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              
              const SizedBox(height: 40),

              // PAY VIA INSTALLED UPI APPS (Intent)
              ElevatedButton.icon(
                onPressed: _launchUPIApp,
                icon: const Icon(Icons.phone_android, color: Colors.white),
                label: const Text('Pay via installed UPI App', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B52D9),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 16),

              // OPEN WEBVIEW PAGE
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const WebViewScreen()));
                },
                icon: Icon(Icons.language, color: isDark ? Colors.white : Colors.black),
                label: Text('Open Terms via Webview', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. WEBVIEW SCREEN (Using webview_flutter)
// ==========================================
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://flutter.dev')); // Dummy URL, replace with your own
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Webview Page')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

// ==========================================
// 7. DUMMY PAGE
// ==========================================
class DummyPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const DummyPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: const Color(0xFF6B52D9)),
            const SizedBox(height: 20),
            Text('$title Page', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Ye ek dummy page hai.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
