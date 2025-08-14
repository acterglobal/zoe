import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:Zoe/features/settings/models/language_model.dart';
import 'package:Zoe/core/preference_service/preferences_service.dart';

class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super('en');

  static const languagePrefKey = 'zoey.language';

  Future<void> initLanguage() async {
    final prefInstance = await sharedPrefs();
    final prefLanguageCode = prefInstance.getString(languagePrefKey);
    final deviceLanguageCode = PlatformDispatcher.instance.locale.languageCode;
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