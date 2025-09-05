import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/users/models/user_model.dart';

class MockUserNotifier extends StateNotifier<List<UserModel>> {
  MockUserNotifier() : super([
    UserModel(id: 'user_1', name: 'Test User 1'),
    UserModel(id: 'user_2', name: 'Test User 2'),
  ]);

  void setUsers(List<UserModel> users) {
    state = users;
  }
}

final mockUserListProvider = StateNotifierProvider<MockUserNotifier, List<UserModel>>(
  (ref) => MockUserNotifier(),
);

final mockGetUserByIdProvider = Provider.family<UserModel?, String>((ref, userId) {
  final userList = ref.watch(mockUserListProvider);
  return userList.where((u) => u.id == userId).firstOrNull;
}, dependencies: [mockUserListProvider]);

final mockLoggedInUserProvider = FutureProvider<UserModel>((ref) async {
  return UserModel(id: 'user_1', name: 'Test User 1');
});

final mockIsUserLoggedInProvider = FutureProvider<bool>((ref) async {
  return true;
});

final mockUsersBySheetIdProvider = Provider.family<List<UserModel>, String>((ref, sheetId) {
  final userList = ref.watch(mockUserListProvider);
  return userList;
}, dependencies: [mockUserListProvider]);