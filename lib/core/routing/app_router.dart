import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import '../../features/sheet/providers/sheet_list_provider.dart';
import 'app_routes.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/sheet/screens/sheet_detail_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/welcome/screens/welcome_screen.dart';

// Global navigator key for accessing the router
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Router provider that always starts with welcome screen
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.welcome.route,
    routes: [
      // Welcome route
      GoRoute(
        path: AppRoutes.welcome.route,
        name: AppRoutes.welcome.name,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Home route
      GoRoute(
        path: AppRoutes.home.route,
        name: AppRoutes.home.name,
        builder: (context, state) => const HomeScreen(),
      ),

      // Sheet detail route
      GoRoute(
        path: AppRoutes.sheet.route,
        name: AppRoutes.sheet.name,
        builder: (context, state) {
          final sheetId = state.pathParameters['sheetId'];

          return Consumer(
            builder: (context, ref, child) {
              final sheetListNotifier = ref.read(sheetListProvider.notifier);

              // Find the sheet by ID
              ZoeSheetModel? sheet;
              if (sheetId != null && sheetId != 'new') {
                sheet = sheetListNotifier.getSheetById(sheetId);
                // If sheet not found, create a fallback
                sheet ??= ZoeSheetModel(
                  title: 'Sheet Not Found',
                  description: '',
                );
              }

              return SheetDetailScreen(page: sheet);
            },
          );
        },
      ),

      // Settings route
      GoRoute(
        path: AppRoutes.settings.route,
        name: AppRoutes.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Sheet Not Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.home.route),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Sheet Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The sheet you requested could not be found.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home.route),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Helper provider to access the root navigator key if needed
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return _rootNavigatorKey;
});
