
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/settings/notifiers/local_notifier.dart';

class MockLocaleNotifier extends LocaleNotifier {
  MockLocaleNotifier() : super();

  void setLocale(String languageCode) {
    state = languageCode;
  }
}

final mockLocaleProvider = StateNotifierProvider<LocaleNotifier, String>(
  (ref) => MockLocaleNotifier(),
);
