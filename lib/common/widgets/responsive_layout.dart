import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_theme.dart';
import '../../features/home/home_screen.dart';
import '../../features/paper_sheet/page_detail_screen.dart';
import '../../features/settings/settings_screen.dart';

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
        return Scaffold(
          backgroundColor: AppTheme.getBackground(context),
          body: _buildMainContent(navigationProvider),
          floatingActionButton:
              navigationProvider.currentScreen == AppScreen.home
              ? FloatingActionButton(
                  heroTag: "responsive_layout_fab",
                  onPressed: () => navigationProvider.navigateToNewPage(),
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add_rounded),
                )
              : null,
        );
      },
    );
  }

  Widget _buildMainContent(NavigationProvider navigationProvider) {
    switch (navigationProvider.currentScreen) {
      case AppScreen.home:
        return const HomeScreen(key: ValueKey('home'), isEmbedded: false);
      case AppScreen.page:
        return PageDetailScreen(
          key: ValueKey('page_${navigationProvider.currentPage?.id}'),
          page: navigationProvider.currentPage,
          isEmbedded: false,
        );
      case AppScreen.settings:
        return const SettingsScreen(
          key: ValueKey('settings'),
          isEmbedded: false,
        );
      case AppScreen.profile:
        return Container(
          key: const ValueKey('profile'),
          child: _buildProfileScreen(),
        );
    }
  }

  Widget _buildProfileScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.getBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Provider.of<NavigationProvider>(
              context,
              listen: false,
            ).navigateToHome();
          },
        ),
      ),
      backgroundColor: AppTheme.getBackground(context),
      body: const Center(child: Text('Profile Screen - Coming Soon')),
    );
  }
}
