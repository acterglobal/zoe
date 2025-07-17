import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/providers/app_state_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/app_routes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const HomeScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with app name and settings
              _buildHeader(context),

              const SizedBox(height: 24),

              // Greeting section
              _buildGreetingSection(context),

              const SizedBox(height: 32),

              // Simple pages list
              _buildSimplePagesList(context, appState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Zoey',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
        ),
        // Settings button
        IconButton(
          onPressed: () => context.go(AppRoutes.settings.route),
          icon: Icon(
            Icons.settings_rounded,
            color: AppTheme.getTextSecondary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getFormattedDate(),
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.getTextSecondary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSimplePagesList(BuildContext context, AppState appState) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Pages',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getTextPrimary(context),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => context.go(
                  AppRoutes.sheet.route.replaceAll(':sheetId', 'new'),
                ),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Create New Page',
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (appState.sheets.isEmpty)
            _buildEmptyState(context)
          else
            Expanded(
              child: ListView.builder(
                itemCount: appState.sheets.length,
                itemBuilder: (context, index) {
                  final page = appState.sheets[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Text(
                        page.emoji ?? '📄',
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(
                        page.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.getTextPrimary(context),
                        ),
                      ),
                      subtitle: page.description.isNotEmpty
                          ? Text(
                              page.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.getTextSecondary(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      onTap: () => context.go(
                        AppRoutes.sheet.route.replaceAll(':sheetId', page.id),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add_rounded,
              size: 64,
              color: AppTheme.getTextSecondary(context),
            ),
            const SizedBox(height: 16),
            Text(
              'No pages yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first page to get started',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getTextSecondary(context),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(
                AppRoutes.sheet.route.replaceAll(':sheetId', 'new'),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Page'),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning!';
    } else if (hour < 17) {
      return 'Good afternoon!';
    } else {
      return 'Good evening!';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}
