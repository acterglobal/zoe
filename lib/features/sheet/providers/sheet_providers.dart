import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/sheet/data/sheet_data.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
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
    var sheetToAdd = sheet;

    // Apply default theme if sheet doesn't have one
    if (sheetToAdd.theme == null) {
      sheetToAdd = sheetToAdd.copyWith(
        theme: (
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
      );
    }

    if (currentUserId != null && currentUserId.isNotEmpty) {
      state = [
        ...state,
        sheetToAdd.copyWith(users: [currentUserId], createdBy: currentUserId),
      ];
    } else {
      state = [...state, sheetToAdd];
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

  void updateSheetCoverImage(String sheetId, String? coverImageUrl) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          if (coverImageUrl == null)
            sheet.removeCoverImage()
          else
            sheet.copyWith(coverImageUrl: coverImageUrl)
        else
          sheet,
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

  void updateSheetAvatar({
    required String sheetId,
    required AvatarType type,
    required String data,
    Color? color,
  }) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(
            sheetAvatar: sheet.sheetAvatar.copyWith(
              type: type,
              data: data,
              color: color,
            ),
          )
        else
          sheet,
    ];
  }

  Future<void> addUserToSheet(String sheetId, String userId) async {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(users: {...sheet.users, userId}.toList())
        else
          sheet,
    ];
  }

  void updateSheetTheme({
    required String sheetId,
    required Color primary,
    required Color secondary,
  }) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(theme: (primary: primary, secondary: secondary))
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
