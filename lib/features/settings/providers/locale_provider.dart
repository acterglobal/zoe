import 'dart:ui' as ui;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import 'package:zoe/features/settings/models/language_model.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';

part 'locale_provider.g.dart';

/// Provider for managing app locale/language settings
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  static const languagePrefKey = 'zoe.language';

  @override
  String build() {
    // Initialize with default language
    _initLanguage();
    return 'en';
  }

  Future<void> _initLanguage() async {
    final prefInstance = await sharedPrefs();
    final prefLanguageCode = prefInstance.getString(languagePrefKey);
    final deviceLanguageCode = ui.PlatformDispatcher.instance.locale.languageCode;
    final bool isLanguageContain = LanguageModel.allLanguagesList
        .where((element) => element.languageCode == deviceLanguageCode)
        .toList()
        .isNotEmpty;

    if (prefLanguageCode != null) {
      _localSet(prefLanguageCode);
    } else if (isLanguageContain) {
      _localSet(deviceLanguageCode);
    }
  }

  Future<void> setLanguage(String languageCode) async {
    final prefInstance = await sharedPrefs();
    await prefInstance.setString(languagePrefKey, languageCode);
    _localSet(languageCode);
  }

  void _localSet(String languageCode) {
    state = languageCode;
    Intl.defaultLocale = languageCode;
  }
}

/// Provider for current locale as Locale object
@riverpod
ui.Locale currentLocale(Ref ref) {
  final languageCode = ref.watch(appLocaleProvider);
  return ui.Locale(languageCode);
}

/// Provider to check if the app is using system language
@riverpod
bool isSystemLanguage(Ref ref) {
  final languageCode = ref.watch(appLocaleProvider);
  return languageCode == ui.PlatformDispatcher.instance.locale.languageCode;
}

/// Provider for available languages filtered by current locale
@riverpod
List<LanguageModel> availableLanguages(Ref ref) {
  final currentLanguage = ref.watch(appLocaleProvider);
  return LanguageModel.allLanguagesList
      .where((lang) => lang.languageCode != currentLanguage)
      .toList();
}