import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/providers/app_state_provider.dart';
import '../common/theme/app_theme.dart';
import '../screens/page_detail_screen.dart';
import '../screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.getSurface(context),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<AppStateProvider>(
                              builder: (context, appState, child) {
                                return Text(
                                  appState.userName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                            Text(
                              'Organize • Plan • Create',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pages Section
            Expanded(
              child: Consumer<AppStateProvider>(
                builder: (context, appState, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Pages',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.getTextPrimary(context),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.add_rounded, size: 20),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close drawer
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PageDetailScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: appState.pages.length,
                          itemBuilder: (context, index) {
                            final page = appState.pages[index];
                            return ListTile(
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    page.emoji ?? '📄',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              title: Text(
                                page.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.getTextPrimary(context),
                                ),
                              ),
                              subtitle: page.description.isNotEmpty
                                  ? Text(
                                      page.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.getTextSecondary(
                                          context,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              onTap: () {
                                Navigator.of(context).pop(); // Close drawer
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PageDetailScreen(page: page),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Bottom Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.getBorder(context)),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings_rounded, size: 20),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.getTextPrimary(context),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(); // Close drawer
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_rounded, size: 20),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.getTextPrimary(context),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(); // Close drawer
                      // TODO: Navigate to profile
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
