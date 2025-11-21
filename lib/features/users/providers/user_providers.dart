import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/features/users/data/user_list.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

part 'user_providers.g.dart';

/// Main user list provider with all user management functionality
@Riverpod(keepAlive: true)
class UserList extends _$UserList {
  @override
  List<UserModel> build() => userList;

  void addUser(UserModel user) {
    state = [...state, user];
  }

  void deleteUser(String userId) {
    state = state.where((u) => u.id != userId).toList();
  }

  void updateUserName(String userId, String name) {
    state = [
      for (final user in state)
        if (user.id == userId) user.copyWith(name: name) else user,
    ];
  }

  void updateUser(String userId, UserModel updatedUser) {
    state = [
      for (final user in state)
        if (user.id == userId) updatedUser else user,
    ];
  }
}

/// Provider to check if a user is logged in
@riverpod
Future<bool> isUserLoggedIn(Ref ref) async {
  final userId = await ref.watch(loggedInUserProvider.future);
  return userId != null && userId.isNotEmpty;
}

/// Provider for the logged-in user ID
@riverpod
Future<String?> loggedInUser(Ref ref) async {
  final defaultUser = 'user_1';
  final prefsService = PreferencesService();
  final userId = await prefsService.getLoginUserId();
  if (userId == null || userId.isEmpty) {
    await prefsService.setLoginUserId(defaultUser);
  }
  return userId ?? defaultUser;
}

/// Provider for the current user model
@riverpod
Future<UserModel?> currentUser(Ref ref) async {
  final userId = await ref.watch(loggedInUserProvider.future);
  if (userId == null) return null;
  return ref.watch(getUserByIdProvider(userId));
}

/// Provider for users in a specific sheet
@riverpod
List<UserModel> usersBySheetId(Ref ref, String sheetId) {
  final userList = ref.watch(userListProvider);
  final sheet = ref.watch(sheetProvider(sheetId));
  if (sheet == null) return [];

  return userList.where((user) => sheet.users.contains(user.id)).toList();
}

/// Provider for getting a user by ID
@riverpod
UserModel? getUserById(Ref ref, String userId) {
  final userList = ref.watch(userListProvider);
  return userList.where((u) => u.id == userId).firstOrNull;
}

/// Provider for getting a user by name
@riverpod
UserModel? getUserByName(Ref ref, String name) {
  final userList = ref.watch(userListProvider);
  return userList.where((u) => u.name == name).firstOrNull;
}

/// Provider for getting user IDs from a list of UserModel objects
@riverpod
List<String> userIdsFromUserModels(Ref ref, List<UserModel> userModels) {
  return userModels.map((user) => user.id).toList();
}

/// Provider for getting user display name
@riverpod
String userDisplayName(Ref ref, String userId) {
  final currentUserId = ref.watch(loggedInUserProvider).value ?? '';
  final user = ref.watch(getUserByIdProvider(userId));

  if (currentUserId == userId) {
    return 'You';
  }

  if (user != null && user.name.isNotEmpty) {
    return user.name;
  }

  return userId;
}

/// Provider for searching users
@riverpod
List<UserModel> userListSearch(Ref ref, String searchTerm) {
  final userList = ref.watch(userListProvider);
  if (searchTerm.isEmpty) return userList;
  return userList
      .where((u) => u.name.toLowerCase().contains(searchTerm.toLowerCase()))
      .toList();
}

/// Provider for user count in a sheet
@riverpod
int sheetUserCount(Ref ref, String sheetId) {
  final users = ref.watch(usersBySheetIdProvider(sheetId));
  return users.length;
}
