import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages and persists application theme mode (Day / Light vs Night / Dark).
class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'jhora_theme_mode';

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = prefs.getString(_prefKey);
      if (modeStr != null) {
        _themeMode = modeStr == 'light' ? ThemeMode.light : ThemeMode.dark;
        notifyListeners();
      }
    } catch (_) {
      // Fallback to default dark
    }
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, _themeMode == ThemeMode.light ? 'light' : 'dark');
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, mode == ThemeMode.light ? 'light' : 'dark');
    } catch (_) {}
  }
}

