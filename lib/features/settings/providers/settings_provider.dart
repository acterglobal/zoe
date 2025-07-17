import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

enum AppLanguage { english, spanish, french, german, japanese }

class SettingsState {
  final AppThemeMode theme;
  final AppLanguage language;
  final bool isInitialized;

  const SettingsState({
    required this.theme,
    required this.language,
    required this.isInitialized,
  });

  SettingsState copyWith({
    AppThemeMode? theme,
    AppLanguage? language,
    bool? isInitialized,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  // Theme getters
  bool get isDarkMode {
    switch (theme) {
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
    switch (theme) {
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
    switch (language) {
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
    switch (language) {
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
    switch (theme) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
    : super(
        const SettingsState(
          theme: AppThemeMode.system,
          language: AppLanguage.english,
          isInitialized: false,
        ),
      );

  // Initialize settings from shared preferences
  Future<void> initializeSettings() async {
    if (state.isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    // Load theme preference
    final themeIndex = prefs.getInt('theme') ?? AppThemeMode.system.index;
    final theme = AppThemeMode.values[themeIndex];

    // Load language preference
    final languageIndex = prefs.getInt('language') ?? AppLanguage.english.index;
    final language = AppLanguage.values[languageIndex];

    state = state.copyWith(
      theme: theme,
      language: language,
      isInitialized: true,
    );
  }

  // Update theme
  Future<void> updateTheme(AppThemeMode newTheme) async {
    if (state.theme == newTheme) return;

    state = state.copyWith(theme: newTheme);

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', newTheme.index);
  }

  // Update language
  Future<void> updateLanguage(AppLanguage newLanguage) async {
    if (state.language == newLanguage) return;

    state = state.copyWith(language: newLanguage);

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', newLanguage.index);
  }
}

// Riverpod providers
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);

// Convenience providers for frequently accessed data
final themeProvider = Provider<AppThemeMode>((ref) {
  return ref.watch(settingsProvider).theme;
});

final languageProvider = Provider<AppLanguage>((ref) {
  return ref.watch(settingsProvider).language;
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isDarkMode;
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

final languageCodeProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).languageCode;
});

final isInitializedProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isInitialized;
});
