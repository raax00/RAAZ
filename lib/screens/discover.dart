import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: Center(
        child: Text(
          'Discover Page (Backend Ready)', 
          style: TextStyle(fontSize: 24, color: isDark ? Colors.white : Colors.black87)
        )
      )
    );
  }
}
