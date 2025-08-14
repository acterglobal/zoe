import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Storage Service Provider
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});
