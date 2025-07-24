import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/settings/notifiers/local_notifier.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, String>(
  (ref) => LocaleNotifier(),
);