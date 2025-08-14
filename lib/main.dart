import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:Zoe/core/constants/app_constants.dart';
import 'package:Zoe/core/preference_service/preferences_service.dart';
import 'package:Zoe/features/settings/providers/local_provider.dart';
import 'package:Zoe/features/settings/providers/theme_provider.dart';
import 'package:Zoe/l10n/generated/l10n.dart';
import 'core/routing/app_router.dart';
import 'core/rust/frb_generated.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await PreferencesService().init();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    final language = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme.themeMode,
      routerConfig: router,
      locale: Locale(language),
      localizationsDelegates: [
        ...L10n.localizationsDelegates,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
    );
  }
}
