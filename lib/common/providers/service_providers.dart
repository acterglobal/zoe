import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';

part 'service_providers.g.dart';

/// Provider for PreferencesService
@riverpod
PreferencesService preferencesService(Ref ref) {
  return PreferencesService();
}