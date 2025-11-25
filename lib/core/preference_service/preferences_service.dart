import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoe/core/preference_service/preference_constants.dart';
import 'package:zoe/features/settings/models/theme.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Get SharedPreferences instance
  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // Theme Mode
  Future<AppThemeMode> getThemeMode() async {
    await init();
    final themeModeIndex = _prefs?.getInt(PreferenceConstants.keyThemeMode);
    if (themeModeIndex != null) {
      return AppThemeMode.values[themeModeIndex];
    }
    return AppThemeMode.system; // Default to system theme
  }

  Future<bool> setThemeMode(AppThemeMode themeMode) async {
    await init();
    return await _prefs?.setInt(
          PreferenceConstants.keyThemeMode,
          themeMode.index,
        ) ??
        false;
  }

  // Login User
  Future<String?> getLoginUserId() async {
    await init();
    return _prefs?.getString(PreferenceConstants.keyLoginUserId);
  }

  Future<bool> setLoginUserId(String userId) async {
    await init();
    return await _prefs?.setString(
          PreferenceConstants.keyLoginUserId,
          userId,
        ) ??
        false;
  }

  Future<bool> clearLoginUserId() async {
    await init();
    return await _prefs?.remove(PreferenceConstants.keyLoginUserId) ?? false;
  }

  // Theme Colors
  Future<Color?> getPrimaryColor() async {
    await init();
    final colorValue = _prefs?.getInt(PreferenceConstants.keyPrimaryColor);
    if (colorValue != null) {
      return Color(colorValue);
    }
    return null;
  }

  Future<bool> setPrimaryColor(Color color) async {
    await init();
    return await _prefs?.setInt(
          PreferenceConstants.keyPrimaryColor,
          color.value,
        ) ??
        false;
  }

  Future<Color?> getSecondaryColor() async {
    await init();
    final colorValue = _prefs?.getInt(PreferenceConstants.keySecondaryColor);
    if (colorValue != null) {
      return Color(colorValue);
    }
    return null;
  }

  Future<bool> setSecondaryColor(Color color) async {
    await init();
    return await _prefs?.setInt(
          PreferenceConstants.keySecondaryColor,
          color.value,
        ) ??
        false;
  }

  Future<bool> clearThemeColors() async {
    await init();
    final primaryRemoved =
        await _prefs?.remove(PreferenceConstants.keyPrimaryColor) ?? false;
    final secondaryRemoved =
        await _prefs?.remove(PreferenceConstants.keySecondaryColor) ?? false;
    return primaryRemoved && secondaryRemoved;
  }
}

Future<SharedPreferences> sharedPrefs() async {
  return await PreferencesService.getSharedPreferences();
}
