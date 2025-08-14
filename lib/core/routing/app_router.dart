import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:Zoe/common/screens/page_not_found_screen.dart';
import 'package:Zoe/features/bullets/screens/bullet_detail_screen.dart';
import 'package:Zoe/features/documents/screens/documents_list_screen.dart';
import 'package:Zoe/features/events/screens/event_detail_screen.dart';
import 'package:Zoe/features/events/screens/events_list_screen.dart';
import 'package:Zoe/features/home/screens/home_screen.dart';
import 'package:Zoe/features/link/screens/links_list_screen.dart';
import 'package:Zoe/features/settings/screens/settings_screen.dart';
import 'package:Zoe/features/settings/screens/language_selection_screen.dart';
import 'package:Zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:Zoe/features/sheet/screens/sheet_list_screen.dart';
import 'package:Zoe/features/task/screens/task_detail_screen.dart';
import 'package:Zoe/features/task/screens/tasks_list_screen.dart';
import 'package:Zoe/features/welcome/screens/welcome_screen.dart';
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

      // Sheets list route
      GoRoute(
        path: AppRoutes.sheetsList.route,
        name: AppRoutes.sheetsList.name,
        builder: (context, state) => const SheetListScreen(),
      ),

      // Sheet detail route
      GoRoute(
        path: AppRoutes.sheet.route,
        name: AppRoutes.sheet.name,
        builder: (context, state) {
          final sheetId = state.pathParameters['sheetId'] ?? Uuid().v4();
          return SheetDetailScreen(sheetId: sheetId);
        },
      ),

      // Tasks list route
      GoRoute(
        path: AppRoutes.tasksList.route,
        name: AppRoutes.tasksList.name,
        builder: (context, state) => const TasksListScreen(),
      ),

      // Task detail route
      GoRoute(
        path: AppRoutes.taskDetail.route,
        name: AppRoutes.taskDetail.name,
        builder: (context, state) {
          final taskId = state.pathParameters['taskId'] ?? Uuid().v4();
          return TaskDetailScreen(taskId: taskId);
        },
      ),

      // Events list route
      GoRoute(
        path: AppRoutes.eventsList.route,
        name: AppRoutes.eventsList.name,
        builder: (context, state) => const EventsListScreen(),
      ),

      // Event detail route
      GoRoute(
        path: AppRoutes.eventDetail.route,
        name: AppRoutes.eventDetail.name,
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? Uuid().v4();
          return EventDetailScreen(eventId: eventId);
        },
      ),

      // Bullet detail route
      GoRoute(
        path: AppRoutes.bulletDetail.route,
        name: AppRoutes.bulletDetail.name,
        builder: (context, state) {
          final bulletId = state.pathParameters['bulletId'] ?? Uuid().v4();
          return BulletDetailScreen(bulletId: bulletId);
        },
      ),

      // Settings route
      GoRoute(
        path: AppRoutes.settings.route,
        name: AppRoutes.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Links list route
      GoRoute(
        path: AppRoutes.linksList.route,
        name: AppRoutes.linksList.name,
        builder: (context, state) => const LinksListScreen(),
      ),

      // Documents list route
      GoRoute(
        path: AppRoutes.documentsList.route,
        name: AppRoutes.documentsList.name,
        builder: (context, state) => const DocumentsListScreen(),
      ),

      // Language selection route
      GoRoute(
        path: AppRoutes.settingLanguage.route,
        name: AppRoutes.settingLanguage.name,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
    ],
    errorBuilder: (context, state) => const PageNotFoundScreen(),
  );
});
