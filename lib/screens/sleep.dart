import 'package:flutter/material.dart';

class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep')),
      body: Center(
        child: Text(
          'Sleep Page (Backend Ready)', 
          style: TextStyle(fontSize: 24, color: isDark ? Colors.white : Colors.black87)
        )
      )
    );
  }
}
