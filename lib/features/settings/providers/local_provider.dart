import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/settings/notifiers/local_notifier.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, String>(
  (ref) {
    final notifier = LocaleNotifier();
    // Initialize language from preferences when provider is created
    notifier.initLanguage();
    return notifier;
  },
);