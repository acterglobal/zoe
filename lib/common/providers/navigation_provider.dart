import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/page.dart';

enum AppScreen { home, page, settings, profile }

class NavigationProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.home;
  ZoePage? _currentPage;

  // Getters
  AppScreen get currentScreen => _currentScreen;
  ZoePage? get currentPage => _currentPage;

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

  // Handle back navigation - always goes to home
  void navigateBack() {
    navigateToHome();
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

  // Update screen size detection (kept for potential future use)
  void updateScreenSize(double width) {
    // No longer needed but kept for compatibility
  }
}
