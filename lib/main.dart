import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoey/src/rust/frb_generated.dart';
import 'common/providers/app_state_provider.dart';
import 'common/providers/navigation_provider.dart';
import 'common/providers/settings_provider.dart';
import 'features/welcome/welcome_screen.dart';
import 'widgets/responsive_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          // Initialize settings on first build
          if (!settings.isInitialized) {
            settings.initializeSettings();
          }

          return MaterialApp(
            title: 'Zoe',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6366F1),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily:
                  'SF Pro Display', // Use system font on Apple platforms
              scaffoldBackgroundColor: const Color(0xFFF8F9FE),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF8F9FE),
                foregroundColor: Color(0xFF1F2937),
                elevation: 0,
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                shadowColor: Colors.black.withValues(alpha: 0.05),
                elevation: 2,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6366F1),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily:
                  'SF Pro Display', // Use system font on Apple platforms
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0F172A),
                foregroundColor: Color(0xFFF1F5F9),
                elevation: 0,
              ),
              cardTheme: CardThemeData(
                color: const Color(0xFF1E293B),
                shadowColor: Colors.black.withValues(alpha: 0.3),
                elevation: 2,
              ),
              drawerTheme: const DrawerThemeData(
                backgroundColor: Color(0xFF1E293B),
              ),
            ),
            home: Consumer<AppStateProvider>(
              builder: (context, appState, child) {
                return appState.isFirstLaunch
                    ? const WelcomeScreen()
                    : const ResponsiveLayout();
              },
            ),
          );
        },
      ),
    );
  }
}
