import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/users/data/user_list.dart';
import 'package:zoe/features/users/models/user_model.dart';

class UserNotifier extends StateNotifier<List<UserModel>> {
  UserNotifier() : super(userList);

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
