import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoe/core/constants/app_constants.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/features/settings/providers/locale_provider.dart';
import 'package:zoe/features/settings/providers/theme_provider.dart';
import 'package:zoe/l10n/generated/l10n.dart';
// import 'package:zoe_native/zoe_native.dart';
import 'common/providers/common_providers.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Rust with error handling
  // try {
  //   await RustLib.init();
  // } catch (e) {
  //   debugPrint('Error initializing Rust: $e');
  // }
  //
  // initStorage(
  //   appleKeychainAppGroupName: 'global.acter.zoe',
  // ); // FIXME: needs to be changed to env vars from built
  await PreferencesService().init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    final language = ref.watch(appLocaleProvider);

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
      // builder: (context, child) =>
      //     DeepLinkInitializer(child: child ?? SizedBox.shrink()),
      supportedLocales: L10n.supportedLocales,
      scaffoldMessengerKey: ref.read(snackbarServiceProvider).messengerKey,
    );
  }
}
