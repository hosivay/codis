import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:codis/core/theme/app_theme.dart';
import 'package:codis/features/cipher/presentation/cipher_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'کدیس',
      locale: const Locale('fa', 'IR'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light.copyWith(
        textTheme: GoogleFonts.vazirmatnTextTheme(AppTheme.light.textTheme),
      ),
      darkTheme: AppTheme.dark.copyWith(
        textTheme: GoogleFonts.vazirmatnTextTheme(AppTheme.dark.textTheme),
      ),
      themeMode: _themeMode,
      home: CipherPage(onThemeToggle: _toggleTheme),
    );
  }
}
