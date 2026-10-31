import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Night / Dark Theme — Cosmic Navy & Celestial Gold
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      primaryColor: AppColors.gold,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.goldLight,
        surface: AppColors.bgCard,
        error: AppColors.accentRed,
        onPrimary: AppColors.bgDark,
        onSecondary: AppColors.bgDark,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: _darkTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.gold),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.chartBorder, width: 0.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.bgDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.chartBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.chartBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIconColor: AppColors.gold,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.chartBorder,
        thickness: 0.6,
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.gold,
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.textMuted,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  /// Day / Light Theme — Sacred Temple Ivory & Warm Ochre Gold
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgLight,
      primaryColor: AppColors.templeGold,
      colorScheme: const ColorScheme.light(
        primary: AppColors.templeGold,
        secondary: AppColors.goldDark,
        surface: AppColors.bgLightCard,
        error: AppColors.accentRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textLightPrimary,
        onError: Colors.white,
      ),
      textTheme: _lightTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textLightPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.templeGold),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgLightCard,
        elevation: 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.chartBorderLight, width: 0.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.templeGold,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgLightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.chartBorderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.chartBorderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.templeGold, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textLightSecondary),
        hintStyle: const TextStyle(color: AppColors.textLightMuted),
        prefixIconColor: AppColors.templeGold,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.chartBorderLight,
        thickness: 0.6,
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.templeGold,
        labelColor: AppColors.templeGold,
        unselectedLabelColor: AppColors.textLightMuted,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
  );

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textLightPrimary, letterSpacing: -0.5),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary),
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textLightPrimary),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textLightPrimary),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textLightSecondary),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textLightMuted),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLightSecondary),
  );
}
