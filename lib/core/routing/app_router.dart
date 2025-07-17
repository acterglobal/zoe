import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/models/page.dart';
import '../../common/providers/app_state_provider.dart';
import 'app_routes.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/sheet/page_detail_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/welcome/screens/welcome_screen.dart';

// Global navigator key for accessing the router
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Router provider that watches app state for dynamic routing
final routerProvider = Provider<GoRouter>((ref) {
  final appState = ref.watch(appStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: appState.isFirstLaunch
        ? AppRoutes.welcome.route
        : AppRoutes.home.route,
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

      // Page detail route
      GoRoute(
        path: AppRoutes.page.route,
        name: AppRoutes.page.name,
        builder: (context, state) {
          final pageId = state.pathParameters['pageId'];

          return Consumer(
            builder: (context, ref, child) {
              final appState = ref.read(appStateProvider);

              // Find the page by ID
              ZoePage? page;
              if (pageId != null && pageId != 'new') {
                page = appState.pages.firstWhere(
                  (p) => p.id == pageId,
                  orElse: () =>
                      ZoePage(title: 'Page Not Found', description: ''),
                );
              }

              return PageDetailScreen(page: page);
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
        title: const Text('Page Not Found'),
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
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The page you requested could not be found.',
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
