import 'package:flutter/material.dart';

import 'package:codis/core/theme/app_theme.dart';
import 'package:codis/features/cipher/presentation/cipher_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('fa', 'IR');

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'fa' ? const Locale('en') : const Locale('fa', 'IR');
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontFamily = _locale.languageCode == 'fa' ? 'Vazirmatn' : null;
    return MaterialApp(
      title: 'Codis',
      locale: _locale,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light.copyWith(
        textTheme: fontFamily != null
            ? AppTheme.light.textTheme.apply(fontFamily: fontFamily)
            : AppTheme.light.textTheme,
      ),
      darkTheme: AppTheme.dark.copyWith(
        textTheme: fontFamily != null
            ? AppTheme.dark.textTheme.apply(fontFamily: fontFamily)
            : AppTheme.dark.textTheme,
      ),
      themeMode: _themeMode,
      home: CipherPage(
        onThemeToggle: _toggleTheme,
        onLocaleToggle: _toggleLocale,
        locale: _locale,
      ),
    );
  }
}
