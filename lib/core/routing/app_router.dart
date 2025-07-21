import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/screens/page_not_found_screen.dart';
import 'package:zoey/features/bullets/screens/list_item_detail_screen.dart';
import 'package:zoey/features/events/screens/event_detail_screen.dart';
import 'package:zoey/features/home/screens/home_screen.dart';
import 'package:zoey/features/settings/screens/settings_screen.dart';
import 'package:zoey/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoey/features/todos/screens/task_detail_screen.dart';
import 'package:zoey/features/welcome/screens/welcome_screen.dart';
import 'app_routes.dart';

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
          return SheetDetailScreen(sheetId: sheetId);
        },
      ),

      GoRoute(
        path: AppRoutes.taskDetail.route,
        name: AppRoutes.taskDetail.name,
        builder: (context, state) {
          final taskId = state.pathParameters['taskId'];
          return TaskDetailScreen(taskId: taskId);
        },
      ),

      GoRoute(
        path: AppRoutes.eventDetail.route,
        name: AppRoutes.eventDetail.name,
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'];
          return EventDetailScreen(eventId: eventId);
        },
      ),

      GoRoute(
        path: AppRoutes.bulletItemDetail.route,
        name: AppRoutes.bulletItemDetail.name,
        builder: (context, state) {
          final bulletItemId = state.pathParameters['bulletItemId'];
          return BulletItemDetailScreen(bulletItemId: bulletItemId);
        },
      ),
      // Settings route
      GoRoute(
        path: AppRoutes.settings.route,
        name: AppRoutes.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => const PageNotFoundScreen(),
  );
});
