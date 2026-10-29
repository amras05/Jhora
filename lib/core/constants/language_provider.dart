import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language.dart';

/// Manages the application language and persists preference.
class LanguageProvider extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langIndex = prefs.getInt('app_language');
    if (langIndex != null && langIndex < AppLanguage.values.length) {
      _currentLanguage = AppLanguage.values[langIndex];
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_language', language.index);
  }

  String l(String key) => AppStrings.label(_currentLanguage, key);

  String rashi(int index) => AppStrings.rashi(_currentLanguage, index);

  String planet(String key) => AppStrings.planet(_currentLanguage, key);

  String chartAbbr(String key) => AppStrings.chartAbbrev(_currentLanguage, key);

  String nakshatra(int index) => AppStrings.nakshatra(_currentLanguage, index);
}
