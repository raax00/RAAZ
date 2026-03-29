import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';
import 'settings.dart';
import 'payment.dart';
import 'book_details.dart';

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
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
            children: [
              TextSpan(text: 'E-', style: TextStyle(color: Color(0xFFF9A826))),
              TextSpan(text: 'SPORTS', style: TextStyle(color: Color(0xFFE23E57))),
            ],
          ),
        ),
        actions: [
          // Theme Switcher (Saves state)
          Icon(isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill, 
               color: isDark ? Colors.white : Colors.black, size: 20),
          Switch(
            value: isDark,
            activeColor: const Color(0xFFE23E57),
            onChanged: (value) {
              themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              prefs.setBool('isDark', value); // Save to local storage
            },
          ),
          const SizedBox(width: 8),

          // iOS Settings Icon
          IconButton(
            icon: Icon(CupertinoIcons.gear_alt_fill, color: isDark ? Colors.white : Colors.black),
            onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const SettingsPage())),
          ),

          // Payment Page linked to Profile for adding wallet funds
          GestureDetector(
            onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const PaymentPage())),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/profile.jpg'),
              backgroundColor: Colors.grey,
            ),
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
            
            // Clean iOS style search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(CupertinoIcons.search, color: Colors.grey),
                  hintText: 'Search Tournaments, Scrims...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('UPCOMING MATCHES', style: TextStyle(color: Colors.redAccent[400], fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const Text('See All', style: TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Erangel Squad (T3)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 16),
            
            // BGMI Tournament Card (Replaces the Book card but keeps route intact)
            GestureDetector(
              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const BookDetailsPage())),
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF1E1E1E),
                  image: const DecorationImage(
                    image: AssetImage('assets/book_bg.jpg'), // Aap isko baad me BGMI image se replace kar lena
                    fit: BoxFit.cover, 
                    opacity: 0.5
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                  ]
                ),
                child: Stack(
                  children: [
                    // Prize Pool Text
                    const Positioned(
                      top: 20, left: 20, 
                      child: Text("PRIZE POOL\n₹5,000", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1))
                    ),
                    
                    // Entry Fee Badge
                    Positioned(
                      top: 20, right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Entry: ₹50', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    ),
                    
                    // Time Left
                    const Positioned(
                      bottom: 30, left: 20, 
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.time, color: Colors.white70, size: 16),
                          SizedBox(width: 4),
                          Text('Starts in: 02:45:00', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ),
                    
                    // Join Now Button
                    Positioned(
                      bottom: 20, right: 20, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), 
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFF9A826), Color(0xFFE23E57)]), 
                          borderRadius: BorderRadius.circular(20)
                        ), 
                        child: const Text('JOIN NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2))
                      )
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
