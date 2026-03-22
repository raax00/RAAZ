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
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'k', style: TextStyle(color: Color(0xFF6B52D9))),
              TextSpan(text: 'idly', style: TextStyle(color: Color(0xFF38B6FF))),
            ],
          ),
        ),
        actions: [
          // Theme Switcher (Saves state)
          Icon(isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill, 
               color: isDark ? Colors.white : Colors.black, size: 20),
          Switch(
            value: isDark,
            activeColor: const Color(0xFF6B52D9),
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
          
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/profile.jpg'),
            backgroundColor: Colors.grey,
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
            InkWell(
              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const PaymentPage())),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [Color(0xFF6B52D9), Color(0xFF38B6FF)]),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.white),
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
                  hintText: 'Books, Categories, Topics...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('NATURE AND OUR WORLD', style: TextStyle(color: Colors.teal[300], fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('An innocent wish...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const BookDetailsPage())),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF4A148C),
                  image: const DecorationImage(image: AssetImage('assets/book_bg.jpg'), fit: BoxFit.cover, opacity: 0.4),
                ),
                child: Stack(
                  children: [
                    const Positioned(top: 20, left: 20, child: Text("Zozo's\nWish", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white))),
                    Positioned(bottom: 20, left: 20, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), decoration: BoxDecoration(color: const Color(0xFF38B6FF), borderRadius: BorderRadius.circular(20)), child: const Text('EXPLORE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
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
