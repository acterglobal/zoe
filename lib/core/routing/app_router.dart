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
import 'package:zoe/features/list/screens/list_details_screen.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';
import 'package:zoe/features/polls/screens/poll_results_screen.dart';
import 'package:zoe/features/polls/screens/polls_list_screen.dart';
import 'package:zoe/features/profile/screens/edit_profile_screen.dart';
import 'package:zoe/features/quick-search/screens/quick_search_screen.dart';
import 'package:zoe/features/settings/screens/settings_screen.dart';
import 'package:zoe/features/settings/screens/language_selection_screen.dart';
import 'package:zoe/features/settings/screens/developer_tools_screen.dart';
import 'package:zoe/features/settings/screens/systems_test_screen.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoe/features/sheet/screens/sheet_list_screen.dart';
import 'package:zoe/features/task/screens/task_detail_screen.dart';
import 'package:zoe/features/task/screens/tasks_list_screen.dart';
import 'package:zoe/features/text/screens/text_block_details_screen.dart';
import 'package:zoe/features/welcome/screens/welcome_screen.dart';
import 'package:zoe/features/whatsapp/screens/whatsapp_group_connect_screen.dart';
import 'package:zoe/features/documents/screens/document_preview_screen.dart';
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

      // List detail route
      GoRoute(
        path: AppRoutes.listDetail.route,
        name: AppRoutes.listDetail.name,
        builder: (context, state) {
          final listId = state.pathParameters['listId'] ?? Uuid().v4();
          return ListDetailsScreen(listId: listId);
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

      // Document preview route
      GoRoute(
        path: AppRoutes.documentPreview.route,
        name: AppRoutes.documentPreview.name,
        builder: (context, state) {
          final documentId = state.pathParameters['documentId'] ?? Uuid().v4();
          return DocumentPreviewScreen(documentId: documentId);
        },
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

      // Poll results route
      GoRoute(
        path: AppRoutes.pollResults.route,
        name: AppRoutes.pollResults.name,
        builder: (context, state) {
          final pollId = state.pathParameters['pollId'] ?? Uuid().v4();
          return PollResultsScreen(pollId: pollId);
        },
      ),

      // Text Block Details route
      GoRoute(
        path: AppRoutes.textBlockDetails.route,
        name: AppRoutes.textBlockDetails.name,
        builder: (context, state) {
          final textBlockId =
              state.pathParameters['textBlockId'] ?? Uuid().v4();
          return TextBlockDetailsScreen(textBlockId: textBlockId);
        },
      ),

      // Quick search route
      GoRoute(
        path: AppRoutes.quickSearch.route,
        name: AppRoutes.quickSearch.name,
        builder: (context, state) => const QuickSearchScreen(),
      ),

      // Language selection route
      GoRoute(
        path: AppRoutes.settingLanguage.route,
        name: AppRoutes.settingLanguage.name,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),

      // Developer tools route
      GoRoute(
        path: AppRoutes.developerTools.route,
        name: AppRoutes.developerTools.name,
        builder: (context, state) => const DeveloperToolsScreen(),
      ),

      // Systems test route
      GoRoute(
        path: AppRoutes.systemsTest.route,
        name: AppRoutes.systemsTest.name,
        builder: (context, state) => const SystemsTestScreen(),
      ),
      // Profile route
      GoRoute(
        path: AppRoutes.settingsProfile.route,
        name: AppRoutes.settingsProfile.name,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // WhatsApp group connect route
      GoRoute(
        path: AppRoutes.whatsappGroupConnect.route,
        name: AppRoutes.whatsappGroupConnect.name,
        builder: (context, state) {
          final sheetId = state.pathParameters['sheetId'] ?? Uuid().v4();
          return WhatsAppGroupConnectScreen(sheetId: sheetId);
        },
      ),
    ],
    errorBuilder: (context, state) => const PageNotFoundScreen(),
  );
});
