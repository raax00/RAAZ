import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';
import 'utils/theme_notifier.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return CupertinoApp(
            title: 'PopStore',
            debugShowCheckedModeBanner: false,
            theme: const CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: Color(0xFFE23E57),
              scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
            ),
            darkTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
              primaryColor: Color(0xFFE23E57),
              scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
            ),
            themeMode: themeNotifier.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}