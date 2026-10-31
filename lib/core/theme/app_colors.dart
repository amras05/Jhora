import 'package:flutter/material.dart';

/// Premium celestial and temple parchment color palettes for Vedic Astrology.
/// Supports both Night/Dark Mode and Day/Light Mode.
class AppColors {
  AppColors._();

  // ─── Primary Gold Palette ───
  static const Color gold = Color(0xFFD4A843);
  static const Color goldLight = Color(0xFFE8C76A);
  static const Color goldDark = Color(0xFFB8892E);
  static const Color amber = Color(0xFFF5C842);
  static const Color templeGold = Color(0xFFB8860B);

  // ─── Night / Dark Palette ───
  static const Color bgDark = Color(0xFF0A0E1A);
  static const Color bgCard = Color(0xFF111827);
  static const Color bgCardLight = Color(0xFF1A2332);
  static const Color bgSurface = Color(0xFF0F1724);
  static const Color bgElevated = Color(0xFF1E293B);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textGold = Color(0xFFD4A843);

  static const Color chartBorder = Color(0xFF334155);
  static const Color chartLine = Color(0xFF475569);
  static const Color chartHighlight = Color(0x33D4A843);

  // ─── Day / Light Palette ───
  static const Color bgLight = Color(0xFFFBF9F4);
  static const Color bgLightCard = Color(0xFFFFFFFF);
  static const Color bgLightCardLight = Color(0xFFF5F1E8);
  static const Color bgLightSurface = Color(0xFFF7F3EB);
  static const Color bgLightElevated = Color(0xFFEDE7DC);

  static const Color textLightPrimary = Color(0xFF1E293B);
  static const Color textLightSecondary = Color(0xFF475569);
  static const Color textLightMuted = Color(0xFF64748B);
  static const Color textLightGold = Color(0xFF996515);

  static const Color chartBorderLight = Color(0xFFD5CCBC);
  static const Color chartLineLight = Color(0xFFB8AE9D);
  static const Color chartHighlightLight = Color(0x22D4A843);

  // ─── Accent Colors (Consistent in both modes) ───
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentCyan = Color(0xFF06B6D4);

  // ─── Planet Astrological Colors ───
  static const Color sunColor = Color(0xFFF59E0B);
  static const Color moonColor = Color(0xFF818CF8);
  static const Color marsColor = Color(0xFFEF4444);
  static const Color mercuryColor = Color(0xFF10B981);
  static const Color jupiterColor = Color(0xFFF59E0B);
  static const Color venusColor = Color(0xFFEC4899);
  static const Color saturnColor = Color(0xFF6366F1);
  static const Color rahuColor = Color(0xFF64748B);
  static const Color ketuColor = Color(0xFF78716C);
  static const Color ascColor = Color(0xFFD4A843);

  // ─── Gradients ───
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

  static const LinearGradient bgLightGradient = LinearGradient(
    colors: [Color(0xFFFBF9F4), Color(0xFFF2ECE0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2332), Color(0xFF111827)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardLightGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F5EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Theme-Aware Resolvers ───
  static LinearGradient getBgGradient(bool isDark) => isDark ? bgGradient : bgLightGradient;
  static LinearGradient getCardGradient(bool isDark) => isDark ? cardGradient : cardLightGradient;

  static Color getBackgroundColor(bool isDark) => isDark ? bgDark : bgLight;
  static Color getCardColor(bool isDark) => isDark ? bgCard : bgLightCard;
  static Color getCardLightColor(bool isDark) => isDark ? bgCardLight : bgLightCardLight;
  static Color getElevatedColor(bool isDark) => isDark ? bgElevated : bgLightElevated;
  static Color getBorderColor(bool isDark) => isDark ? chartBorder : chartBorderLight;
  static Color getLineColor(bool isDark) => isDark ? chartLine : chartLineLight;

  static Color getTextPrimary(bool isDark) => isDark ? textPrimary : textLightPrimary;
  static Color getTextSecondary(bool isDark) => isDark ? textSecondary : textLightSecondary;
  static Color getTextMuted(bool isDark) => isDark ? textMuted : textLightMuted;
  static Color getGold(bool isDark) => isDark ? gold : templeGold;
}
