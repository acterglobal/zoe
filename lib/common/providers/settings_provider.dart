import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

enum AppLanguage { english, spanish, french, german, japanese }

class SettingsProvider extends ChangeNotifier {
  AppThemeMode _theme = AppThemeMode.system;
  AppLanguage _language = AppLanguage.english;
  bool _isInitialized = false;

  // Getters
  AppThemeMode get theme => _theme;
  AppLanguage get language => _language;
  bool get isInitialized => _isInitialized;

  // Theme getters
  bool get isDarkMode {
    switch (_theme) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    }
  }

  ThemeMode get themeMode {
    switch (_theme) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  // Language getters
  String get languageCode {
    switch (_language) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.spanish:
        return 'es';
      case AppLanguage.french:
        return 'fr';
      case AppLanguage.german:
        return 'de';
      case AppLanguage.japanese:
        return 'ja';
    }
  }

  String get languageName {
    switch (_language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.german:
        return 'Deutsch';
      case AppLanguage.japanese:
        return '日本語';
    }
  }

  String get themeName {
    switch (_theme) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  // Initialize settings from shared preferences
  Future<void> initializeSettings() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    // Load theme preference
    final themeIndex = prefs.getInt('theme') ?? AppThemeMode.system.index;
    _theme = AppThemeMode.values[themeIndex];

    // Load language preference
    final languageIndex = prefs.getInt('language') ?? AppLanguage.english.index;
    _language = AppLanguage.values[languageIndex];

    _isInitialized = true;
    notifyListeners();
  }

  // Update theme
  Future<void> updateTheme(AppThemeMode newTheme) async {
    if (_theme == newTheme) return;

    _theme = newTheme;
    notifyListeners();

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', newTheme.index);
  }

  // Update language
  Future<void> updateLanguage(AppLanguage newLanguage) async {
    if (_language == newLanguage) return;

    _language = newLanguage;
    notifyListeners();

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', newLanguage.index);
  }
}
