import 'package:flutter/material.dart';

class RelaxPage extends StatelessWidget {
  const RelaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Relax')),
      body: Center(
        child: Text(
          'Relax Page (Backend Ready)', 
          style: TextStyle(fontSize: 24, color: isDark ? Colors.white : Colors.black87)
        )
      )
    );
  }
}
