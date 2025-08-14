import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/users/models/user_model.dart';
import 'package:Zoe/features/users/providers/user_notifiers.dart';
import 'package:Zoe/core/preference_service/preferences_service.dart';
import 'package:Zoe/features/sheet/providers/sheet_providers.dart';

final isUserLoggedInProvider = FutureProvider<bool>((ref) async {
  final userId = await PreferencesService().getLoginUserId();
  return userId != null && userId.isNotEmpty;
});

final loggedInUserProvider = FutureProvider<String?>((ref) async {
  final userId = await PreferencesService().getLoginUserId();
  return userId;
});

final userListProvider = StateNotifierProvider<UserNotifier, List<UserModel>>(
  (ref) => UserNotifier(),
);

// Provider that returns users for a specific sheet
final usersBySheetIdProvider = Provider.family<List<UserModel>, String>((
  ref,
  sheetId,
) {
  final userList = ref.watch(userListProvider);
  final sheet = ref.watch(sheetProvider(sheetId));
  if (sheet == null) return [];

  return userList.where((user) => sheet.users.contains(user.id)).toList();
});

final getUserByIdProvider = Provider.family<UserModel?, String>((ref, userId) {
  final userList = ref.watch(userListProvider);
  return userList.where((u) => u.id == userId).firstOrNull;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userId = await PreferencesService().getLoginUserId();
  if (userId == null || userId.isEmpty) return null;

  final userList = ref.watch(userListProvider);
  return userList.where((u) => u.id == userId).firstOrNull;
});

// Provider that returns user IDs from a list of UserModel objects
final userIdsFromUserModelsProvider =
    Provider.family<List<String>, List<UserModel>>((ref, userModels) {
      return userModels.map((user) => user.id).toList();
    });
