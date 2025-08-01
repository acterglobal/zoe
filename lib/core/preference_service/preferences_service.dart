import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoey/core/preference_service/preference_constants.dart';
import 'package:zoey/features/settings/models/theme.dart';

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
}

Future<SharedPreferences> sharedPrefs() async {
  return await PreferencesService.getSharedPreferences();
}
