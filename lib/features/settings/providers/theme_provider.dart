import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/features/settings/models/theme.dart';

part 'theme_provider.g.dart';

/// Provider for managing app theme settings
@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  AppThemeMode build() {
    // Initialize with system theme and load saved theme
    _loadTheme();
    return AppThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final themeMode = await ref.read(preferencesServiceProvider).getThemeMode();
    state = themeMode;
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    await ref.read(preferencesServiceProvider).setThemeMode(themeMode);
    state = themeMode;
  }
}

/// Provider to check if the app is using system theme
@riverpod
bool isSystemTheme(Ref ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == AppThemeMode.system;
}

/// Provider to check if the app is using dark theme
@riverpod
bool isDarkTheme(Ref ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == AppThemeMode.dark;
}

/// Provider to check if the app is using light theme
@riverpod
bool isLightTheme(Ref ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == AppThemeMode.light;
}