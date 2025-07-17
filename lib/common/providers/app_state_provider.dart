import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/data/zoe_page_data.dart';
import '../models/page.dart';

class AppState {
  final List<ZoePage> pages;
  final String userName;
  final bool isFirstLaunch;

  const AppState({
    required this.pages,
    required this.userName,
    required this.isFirstLaunch,
  });

  AppState copyWith({
    List<ZoePage>? pages,
    String? userName,
    bool? isFirstLaunch,
  }) {
    return AppState(
      pages: pages ?? this.pages,
      userName: userName ?? this.userName,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier()
    : super(const AppState(pages: [], userName: 'Zoe', isFirstLaunch: true));

  // Initialize with sample data
  void initializeWithSampleData() {
    final samplePages = [gettingStartedPage];
    state = state.copyWith(pages: samplePages, isFirstLaunch: false);
  }

  // Page management
  void addPage(ZoePage page) {
    state = state.copyWith(pages: [...state.pages, page]);
  }

  void updatePage(ZoePage updatedPage) {
    final updatedPages = state.pages.map((page) {
      return page.id == updatedPage.id ? updatedPage : page;
    }).toList();
    state = state.copyWith(pages: updatedPages);
  }

  void deletePage(String pageId) {
    final updatedPages = state.pages
        .where((page) => page.id != pageId)
        .toList();
    state = state.copyWith(pages: updatedPages);
  }

  ZoePage? getPageById(String pageId) {
    try {
      return state.pages.firstWhere((page) => page.id == pageId);
    } catch (e) {
      return null;
    }
  }

  // User settings
  void updateUserName(String name) {
    state = state.copyWith(userName: name);
  }

  void completeFirstLaunch() {
    state = state.copyWith(isFirstLaunch: false);
  }
}

// Main Riverpod provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((
  ref,
) {
  return AppStateNotifier();
});
