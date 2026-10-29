import 'package:flutter/material.dart';

/// Premium color palette for the Vedic astrology app.
/// Gold + deep navy dark theme inspired by celestial aesthetics.
class AppColors {
  AppColors._();

  // Primary palette
  static const Color gold = Color(0xFFD4A843);
  static const Color goldLight = Color(0xFFE8C76A);
  static const Color goldDark = Color(0xFFB8892E);
  static const Color amber = Color(0xFFF5C842);

  // Background palette
  static const Color bgDark = Color(0xFF0A0E1A);
  static const Color bgCard = Color(0xFF111827);
  static const Color bgCardLight = Color(0xFF1A2332);
  static const Color bgSurface = Color(0xFF0F1724);
  static const Color bgElevated = Color(0xFF1E293B);

  // Text palette
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textGold = Color(0xFFD4A843);

  // Accent colors
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentCyan = Color(0xFF06B6D4);

  // Planet colors
  static const Color sunColor = Color(0xFFF59E0B);
  static const Color moonColor = Color(0xFFC7D2FE);
  static const Color marsColor = Color(0xFFEF4444);
  static const Color mercuryColor = Color(0xFF22C55E);
  static const Color jupiterColor = Color(0xFFF59E0B);
  static const Color venusColor = Color(0xFFEC4899);
  static const Color saturnColor = Color(0xFF6366F1);
  static const Color rahuColor = Color(0xFF64748B);
  static const Color ketuColor = Color(0xFF78716C);
  static const Color ascColor = Color(0xFFD4A843);

  // Chart colors
  static const Color chartBorder = Color(0xFF334155);
  static const Color chartLine = Color(0xFF475569);
  static const Color chartHighlight = Color(0x33D4A843);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4A843), Color(0xFFB8892E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF111827)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2332), Color(0xFF111827)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
