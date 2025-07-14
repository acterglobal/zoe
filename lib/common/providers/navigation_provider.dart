import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/page.dart';

enum AppScreen { home, page, settings, profile }

class NavigationProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.home;
  ZoePage? _currentPage;
  bool _isDesktop = false;

  // Getters
  AppScreen get currentScreen => _currentScreen;
  ZoePage? get currentPage => _currentPage;
  bool get isDesktop => _isDesktop;
  bool get shouldShowPersistentSidebar => _isDesktop;

  // Update screen size detection
  void updateScreenSize(double width) {
    final wasDesktop = _isDesktop;
    _isDesktop = width >= 1024; // Desktop breakpoint

    if (wasDesktop != _isDesktop) {
      notifyListeners();
    }
  }

  // Navigate to home screen
  void navigateToHome() {
    if (_currentScreen != AppScreen.home) {
      _currentScreen = AppScreen.home;
      _currentPage = null;
      notifyListeners();
    }
  }

  // Navigate to a specific page
  void navigateToPage(ZoePage page) {
    _currentScreen = AppScreen.page;
    _currentPage = page;
    notifyListeners();
  }

  // Navigate to new page creation
  void navigateToNewPage() {
    _currentScreen = AppScreen.page;
    _currentPage = null;
    notifyListeners();
  }

  // Navigate to settings
  void navigateToSettings() {
    if (_currentScreen != AppScreen.settings) {
      _currentScreen = AppScreen.settings;
      _currentPage = null;
      notifyListeners();
    }
  }

  // Navigate to profile
  void navigateToProfile() {
    if (_currentScreen != AppScreen.profile) {
      _currentScreen = AppScreen.profile;
      _currentPage = null;
      notifyListeners();
    }
  }

  // Handle back navigation - always goes to home on desktop
  void navigateBack() {
    if (_isDesktop) {
      navigateToHome();
    } else {
      // On mobile, we'll use traditional navigation
      navigateToHome();
    }
  }

  // Check if we can show back button
  bool get canGoBack => _currentScreen != AppScreen.home;

  // Get current screen title
  String get currentScreenTitle {
    switch (_currentScreen) {
      case AppScreen.home:
        return 'Zoey';
      case AppScreen.page:
        return _currentPage?.title ?? 'Untitled';
      case AppScreen.settings:
        return 'Settings';
      case AppScreen.profile:
        return 'Profile';
    }
  }
}
