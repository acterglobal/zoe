import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zoe/features/bullets/screens/bullet_detail_screen.dart';
import 'package:zoe/features/documents/screens/document_preview_screen.dart';
import 'package:zoe/features/documents/screens/documents_list_screen.dart';
import 'package:zoe/features/events/screens/event_detail_screen.dart';
import 'package:zoe/features/events/screens/events_list_screen.dart';
import 'package:zoe/features/link/screens/links_list_screen.dart';
import 'package:zoe/features/list/screens/list_details_screen.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';
import 'package:zoe/features/polls/screens/poll_results_screen.dart';
import 'package:zoe/features/polls/screens/polls_list_screen.dart';
import 'package:zoe/features/quick-search/screens/quick_search_screen.dart';
import 'package:zoe/features/settings/screens/settings_screen.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoe/features/sheet/screens/sheet_list_screen.dart';
import 'package:zoe/features/task/screens/task_detail_screen.dart';
import 'package:zoe/features/task/screens/tasks_list_screen.dart';
import 'package:zoe/features/text/screens/text_block_details_screen.dart';
import 'package:zoe/features/whatsapp/screens/whatsapp_group_connect_screen.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class ZoePreview extends StatelessWidget {
  final Widget child;

  const ZoePreview({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
  final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => child,
        ),
        GoRoute(
          path: '/task/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: TaskDetailScreen(taskId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/sheet/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: SheetDetailScreen(sheetId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/poll/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: PollDetailsScreen(pollId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/event/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: EventDetailScreen(eventId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/bullet/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: BulletDetailScreen(bulletId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/list/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: ListDetailsScreen(listId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/document/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: DocumentPreviewScreen(documentId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/poll-results/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: PollResultsScreen(pollId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/text-block/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: TextBlockDetailsScreen(textBlockId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/quick-search',
          builder: (context, state) => Scaffold(
            body: Center(child: QuickSearchScreen()),
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => Scaffold(
            body: Center(child: SettingsScreen()),
          ),
        ),
        GoRoute(
          path: '/whatsapp-group-connect/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: WhatsAppGroupConnectScreen(sheetId: state.pathParameters['id'] ?? '')),
          ),
        ),
        GoRoute(
          path: '/links-list',
          builder: (context, state) => Scaffold(
            body: Center(child: LinksListScreen()),
          ),
        ),
        GoRoute(
          path: '/documents-list',
          builder: (context, state) => Scaffold(
            body: Center(child: DocumentsListScreen()),
          ),
        ),
        GoRoute(
          path: '/polls-list',
          builder: (context, state) => Scaffold(
            body: Center(child: PollsListScreen()),
          ),
        ),
        GoRoute(
          path: '/tasks-list',
          builder: (context, state) => Scaffold(
            body: Center(child: TasksListScreen()),
          ),
        ),
        GoRoute(
          path: '/events-list',
          builder: (context, state) => Scaffold(
            body: Center(child: EventsListScreen()),
          ),
        ),
        GoRoute(
          path: '/sheets-list',
          builder: (context, state) => Scaffold(
            body: Center(child: SheetListScreen()),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: const Locale('en'), // Force English locale for preview
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
    );
  }
}
