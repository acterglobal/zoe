import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/data/zoe_sheet_data.dart';
import '../models/zoe_sheet_model.dart';

class AppState {
  final List<ZoeSheet> sheets;
  final String userName;
  final bool isFirstLaunch;

  const AppState({
    required this.sheets,
    required this.userName,
    required this.isFirstLaunch,
  });

  AppState copyWith({
    List<ZoeSheet>? sheets,
    String? userName,
    bool? isFirstLaunch,
  }) {
    return AppState(
      sheets: sheets ?? this.sheets,
      userName: userName ?? this.userName,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier()
    : super(const AppState(sheets: [], userName: 'Zoe', isFirstLaunch: true));

  // Initialize with sample data
  void initializeWithSampleData() {
    final sampleSheets = [gettingStartedSheet];
    state = state.copyWith(sheets: sampleSheets, isFirstLaunch: false);
  }

  // Sheet management
  void addSheet(ZoeSheet sheet) {
    state = state.copyWith(sheets: [...state.sheets, sheet]);
  }

  void updateSheet(ZoeSheet updatedSheet) {
    final updatedSheets = state.sheets.map((sheet) {
      return sheet.id == updatedSheet.id ? updatedSheet : sheet;
    }).toList();
    state = state.copyWith(sheets: updatedSheets);
  }

  void deleteSheet(String sheetId) {
    final updatedSheets = state.sheets
        .where((sheet) => sheet.id != sheetId)
        .toList();
    state = state.copyWith(sheets: updatedSheets);
  }

  ZoeSheet? getSheetById(String sheetId) {
    try {
      return state.sheets.firstWhere((sheet) => sheet.id == sheetId);
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
