import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/sheet/data/sheet_data.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'sheet_providers.g.dart';

/// Main sheet list provider with all sheet management functionality
@Riverpod(keepAlive: true)
class SheetList extends _$SheetList {
  @override
  List<SheetModel> build() => sheetList;

  void addSheet(SheetModel sheet) {
    final currentUserId = ref.read(loggedInUserProvider).value;
  
    if (currentUserId != null && currentUserId.isNotEmpty) {
      // Create a new sheet with the current user in users list and as creator
      final users = <String>{...sheet.users, currentUserId};
      state = [...state, sheet.copyWith(users: users.toList(), createdBy: currentUserId)];
    } else {
      state = [...state, sheet];
    }
  }

  void deleteSheet(String sheetId) {
    state = state.where((s) => s.id != sheetId).toList();
  }

  void updateSheetTitle(String sheetId, String title) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(title: title) else sheet,
    ];
  }

  void updateSheetDescription(String sheetId, Description description) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(description: description)
        else
          sheet,
    ];
  }

  void updateSheetEmoji(String sheetId, String emoji) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(emoji: emoji) else sheet,
    ];
  }

  void addUserToSheet(String sheetId, String userId) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(users: {...sheet.users, userId}.toList())
        else
          sheet,
    ];
  }
}

/// Provider for sheets filtered by membership (current user must be a member)
@riverpod
List<SheetModel> sheetsList(Ref ref) {
  final allSheets = ref.watch(sheetListProvider);
  final currentUserId = ref.watch(loggedInUserProvider).value;

  // If no user, show nothing
  if (currentUserId == null || currentUserId.isEmpty) return [];

  // Filter by membership
  return allSheets.where((s) => s.users.contains(currentUserId)).toList();
}

/// Provider for searching sheets
@riverpod
List<SheetModel> sheetListSearch(Ref ref) {
  final sheets = ref.watch(sheetsListProvider);
  final searchValue = ref.watch(searchValueProvider);

  if (searchValue.isEmpty) return sheets;
  return sheets
      .where((s) => s.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}

/// Provider for a single sheet by ID
@riverpod
SheetModel? sheet(Ref ref, String sheetId) {
  final sheetList = ref.watch(sheetListProvider);
  return sheetList.where((s) => s.id == sheetId).firstOrNull;
}

/// Provider for list of users in a sheet
@riverpod
List<String> listOfUsersBySheetId(Ref ref, String sheetId) {
  final sheetList = ref.watch(sheetListProvider);
  return sheetList.where((s) => s.id == sheetId).firstOrNull?.users ?? [];
}

/// Provider to check if a sheet exists
@riverpod
bool sheetExists(Ref ref, String sheetId) {
  final sheet = ref.watch(sheetProvider(sheetId));
  return sheet != null;
}

/// Provider for sheets sorted by title (filtered by membership)
@riverpod
List<SheetModel> sortedSheets(Ref ref) {
  final sheets = ref.watch(sheetsListProvider);
  return [...sheets]..sort((a, b) => a.title.compareTo(b.title));
}
