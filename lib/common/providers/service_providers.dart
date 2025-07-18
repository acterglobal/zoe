import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/preference_service/preferences_service.dart';

// Storage Service Provider
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});
