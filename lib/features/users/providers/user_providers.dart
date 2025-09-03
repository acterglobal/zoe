import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_notifiers.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe_native/providers.dart';

final isUserLoggedInProvider = FutureProvider<bool>((ref) async {
  final userId = await ref.watch(userIdProvider.future);
  return userId.isNotEmpty;
});

final loggedInUserProvider = FutureProvider<String?>((ref) async {
  await ref.watch(userIdProvider.future);
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
  final userId = await ref.watch(userIdProvider.future);
  return UserModel(id: userId, name: userId.substring(0, 8));
});

// Provider that returns user IDs from a list of UserModel objects
final userIdsFromUserModelsProvider =
    Provider.family<List<String>, List<UserModel>>((ref, userModels) {
      return userModels.map((user) => user.id).toList();
    });

// Provider that returns user display name for a user ID
final userDisplayNameProvider = Provider.family<String, String>((ref, userId) {
  final currentUserId = ref.watch(loggedInUserProvider).valueOrNull ?? '';
  final user = ref.watch(getUserByIdProvider(userId));

  if (currentUserId == userId) {
    return 'You';
  }

  if (user != null && user.name.isNotEmpty) {
    return user.name;
  }

  return userId;
});
