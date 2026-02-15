import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:Codis/core/theme/app_palette.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppPalette.surfaceLight,
      colorScheme: const ColorScheme.light(
        surface: AppPalette.surfaceLight,
        onSurface: AppPalette.textPrimaryLight,
        primary: AppPalette.accentLight,
        onPrimary: Colors.white,
        error: AppPalette.errorLight,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: AppPalette.textPrimaryLight),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        outlineBorder: BorderSide.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.textSecondaryLight,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppPalette.surfaceOverlayLight,
        contentTextStyle: const TextStyle(color: AppPalette.textPrimaryLight),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppPalette.radiusMd)),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.surfaceDark,
      colorScheme: const ColorScheme.dark(
        surface: AppPalette.surfaceDark,
        onSurface: AppPalette.textPrimaryDark,
        primary: AppPalette.accentDark,
        onPrimary: Colors.white,
        error: AppPalette.errorDark,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppPalette.textPrimaryDark),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        outlineBorder: BorderSide.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.textSecondaryDark,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppPalette.surfaceOverlayDark,
        contentTextStyle: const TextStyle(color: AppPalette.textPrimaryDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppPalette.radiusMd)),
      ),
    );
  }
}
