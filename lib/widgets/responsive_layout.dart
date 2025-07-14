import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/providers/navigation_provider.dart';
import '../common/theme/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/page_detail_screen.dart';
import '../screens/settings_screen.dart';
import 'app_sidebar.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Update screen size in navigation provider
    final width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).updateScreenSize(width);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        final isDesktop = navigationProvider.shouldShowPersistentSidebar;

        if (isDesktop) {
          return _buildDesktopLayout(navigationProvider);
        } else {
          return _buildMobileLayout(navigationProvider);
        }
      },
    );
  }

  Widget _buildDesktopLayout(NavigationProvider navigationProvider) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      body: Row(
        children: [
          // Persistent Sidebar
          const SizedBox(width: 280, child: AppSidebar(isPersistent: true)),

          // Divider
          Container(width: 1, color: AppTheme.getBorder(context)),

          // Main Content Area
          Expanded(child: _buildMainContent(navigationProvider)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(NavigationProvider navigationProvider) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      drawer: const SizedBox(
        width: 280,
        child: AppSidebar(isPersistent: false),
      ),
      body: _buildMainContent(navigationProvider),
      floatingActionButton: navigationProvider.currentScreen == AppScreen.home
          ? FloatingActionButton(
              heroTag: "responsive_layout_fab",
              onPressed: () => navigationProvider.navigateToNewPage(),
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Widget _buildMainContent(NavigationProvider navigationProvider) {
    switch (navigationProvider.currentScreen) {
      case AppScreen.home:
        return HomeScreen(
          key: const ValueKey('home'),
          isEmbedded: navigationProvider.isDesktop,
        );
      case AppScreen.page:
        return PageDetailScreen(
          key: ValueKey('page_${navigationProvider.currentPage?.id}'),
          page: navigationProvider.currentPage,
          isEmbedded: navigationProvider.isDesktop,
        );
      case AppScreen.settings:
        return SettingsScreen(
          key: const ValueKey('settings'),
          isEmbedded: navigationProvider.isDesktop,
        );
      case AppScreen.profile:
        return Container(
          key: const ValueKey('profile'),
          child: _buildProfileScreen(navigationProvider.isDesktop),
        );
    }
  }

  Widget _buildProfileScreen(bool isEmbedded) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppTheme.getBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.getTextPrimary(context),
          ),
          onPressed: () {
            Provider.of<NavigationProvider>(
              context,
              listen: false,
            ).navigateBack();
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppTheme.getTextPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 64,
              color: AppTheme.getTextSecondary(context),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'User profile management will be available in a future update.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.getTextSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
