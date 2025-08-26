import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zoe/common/screens/page_not_found_screen.dart';
import 'package:zoe/features/bullets/screens/bullet_detail_screen.dart';
import 'package:zoe/features/documents/screens/documents_list_screen.dart';
import 'package:zoe/features/events/screens/event_detail_screen.dart';
import 'package:zoe/features/events/screens/events_list_screen.dart';
import 'package:zoe/features/home/screens/home_screen.dart';
import 'package:zoe/features/link/screens/links_list_screen.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';
import 'package:zoe/features/polls/screens/polls_list_screen.dart';
import 'package:zoe/features/settings/screens/settings_screen.dart';
import 'package:zoe/features/settings/screens/language_selection_screen.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoe/features/sheet/screens/sheet_list_screen.dart';
import 'package:zoe/features/task/screens/task_detail_screen.dart';
import 'package:zoe/features/task/screens/tasks_list_screen.dart';
import 'package:zoe/features/welcome/screens/welcome_screen.dart';
import 'package:zoe/features/whatsapp_connect/screens/whatsapp_group_connect_screen.dart';
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

      // Polls list route
      GoRoute(
        path: AppRoutes.pollsList.route,
        name: AppRoutes.pollsList.name,
        builder: (context, state) => const PollsListScreen(),
      ),

      // Poll details route
      GoRoute(
        path: AppRoutes.pollDetails.route,
        name: AppRoutes.pollDetails.name,
        builder: (context, state) {
          final pollId = state.pathParameters['pollId'] ?? Uuid().v4();
          return PollDetailsScreen(pollId: pollId);
        },
      ),

      // Language selection route
      GoRoute(
        path: AppRoutes.settingLanguage.route,
        name: AppRoutes.settingLanguage.name,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),

      // WhatsApp group connect route
      GoRoute(
        path: AppRoutes.whatsappGroupConnect.route,
        name: AppRoutes.whatsappGroupConnect.name,
        builder: (context, state) => const WhatsAppGroupConnectScreen(),
      ),
    ],
    errorBuilder: (context, state) => const PageNotFoundScreen(),
  );
});
