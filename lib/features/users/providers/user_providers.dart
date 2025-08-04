import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/users/models/user_model.dart';
import 'package:zoey/features/users/providers/user_notifiers.dart';
import 'package:zoey/core/preference_service/preferences_service.dart';

final isUserLoggedInProvider = FutureProvider<bool>((ref) async {
  final userId = await PreferencesService().getLoginUserId();
  return userId != null && userId.isNotEmpty;
});

final userListProvider = StateNotifierProvider<UserNotifier, List<UserModel>>(
  (ref) => UserNotifier(),
);

final getUserByIdProvider = Provider.family<UserModel?, String>((ref, userId) {
  final userList = ref.watch(userListProvider);
  return userList.where((u) => u.id == userId).firstOrNull;
});

// Provider that returns user IDs from a list of UserModel objects
final userIdsFromUserModelsProvider =
    Provider.family<List<String>, List<UserModel>>((ref, userModels) {
      return userModels.map((user) => user.id).toList();
    });
