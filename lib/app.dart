import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Codis/core/theme/app_theme.dart';
import 'package:Codis/core/providers/app_providers.dart';
import 'package:Codis/features/cipher/presentation/cipher_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final fontFamily = locale.languageCode == 'fa' ? 'Vazirmatn' : null;
    return MaterialApp(
      title: 'Codis',
      locale: locale,
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
      themeMode: themeMode,
      home: const CipherPage(),
    );
  }
}
