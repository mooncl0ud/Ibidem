import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.dayBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.dayBackground,
        onPrimary: AppColors.dayText,
        secondary: AppColors.brandOrange,
        onSecondary: Colors.white,
        surface: AppColors.dayBackground,
        onSurface: AppColors.dayText,
        error: AppColors.warningRed,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.h1,
        headlineMedium: AppTypography.h2,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.dayBackground,
        foregroundColor: AppColors.dayText,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.nightBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.nightBackground,
        onPrimary: AppColors.nightText,
        secondary: AppColors.brandOrange,
        onSecondary: Colors.white,
        surface: AppColors.nightBackground,
        onSurface: AppColors.nightText,
        error: AppColors.warningRed,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.h1Dark,
        headlineMedium: AppTypography.h2Dark,
        bodyMedium: AppTypography.bodyDark,
        bodySmall: AppTypography.captionDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.nightBackground,
        foregroundColor: AppColors.nightText,
        elevation: 0,
      ),
    );
  }
}
