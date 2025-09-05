import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/settings/models/theme.dart';
import 'package:zoe/features/settings/providers/theme_provider.dart';

class MockThemeNotifier extends ThemeNotifier {
  MockThemeNotifier(super.ref);

  @override
  Future<void> setTheme(AppThemeMode themeMode) async {
    state = themeMode;
  }
}

final mockThemeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>(
  (ref) => MockThemeNotifier(ref),
);
