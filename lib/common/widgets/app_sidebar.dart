import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  final bool isPersistent;

  const AppSidebar({super.key, required this.isPersistent});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.getSurface(context),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Pages Section
            Expanded(
              child: Consumer<AppStateProvider>(
                builder: (context, appState, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPagesHeader(context),
                      Expanded(child: _buildPagesList(context, appState)),
                    ],
                  );
                },
              ),
            ),

            // Bottom Actions
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
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
                          style: const TextStyle(
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
    );
  }

  Widget _buildPagesHeader(BuildContext context) {
    return Padding(
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
              final navProvider = Provider.of<NavigationProvider>(
                context,
                listen: false,
              );
              if (!isPersistent) {
                Navigator.of(context).pop(); // Close drawer on mobile
              }
              navProvider.navigateToNewPage();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPagesList(BuildContext context, AppStateProvider appState) {
    return ListView.builder(
      itemCount: appState.pages.length,
      itemBuilder: (context, index) {
        final page = appState.pages[index];
        return Consumer<NavigationProvider>(
          builder: (context, navProvider, child) {
            final isSelected =
                navProvider.currentScreen == AppScreen.page &&
                navProvider.currentPage?.id == page.id;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                    : null,
                border: isSelected
                    ? Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: ListTile(
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                        : const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.4),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      page.emoji ?? '📄',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                title: Text(
                  page.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? const Color(
                                  0xFF818CF8,
                                ) // Lighter blue for dark theme
                              : const Color(
                                  0xFF6366F1,
                                )) // Original blue for light theme
                        : AppTheme.getTextPrimary(context),
                  ),
                ),
                subtitle: page.description.isNotEmpty
                    ? Text(
                        page.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.getTextSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,

                onTap: () {
                  if (!isPersistent) {
                    Navigator.of(context).pop(); // Close drawer on mobile
                  }
                  navProvider.navigateToPage(page);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.getBorder(context))),
      ),
      child: Column(
        children: [
          Consumer<NavigationProvider>(
            builder: (context, navProvider, child) {
              final isSettingsSelected =
                  navProvider.currentScreen == AppScreen.settings;
              final isProfileSelected =
                  navProvider.currentScreen == AppScreen.profile;

              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isSettingsSelected
                          ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.settings_rounded, size: 20),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSettingsSelected
                              ? const Color(0xFF6366F1)
                              : AppTheme.getTextPrimary(context),
                        ),
                      ),
                      onTap: () {
                        if (!isPersistent) {
                          Navigator.of(context).pop(); // Close drawer on mobile
                        }
                        navProvider.navigateToSettings();
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isProfileSelected
                          ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person_rounded, size: 20),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isProfileSelected
                              ? const Color(0xFF6366F1)
                              : AppTheme.getTextPrimary(context),
                        ),
                      ),
                      onTap: () {
                        if (!isPersistent) {
                          Navigator.of(context).pop(); // Close drawer on mobile
                        }
                        navProvider.navigateToProfile();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
