import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

// Get a user by index from the user list
UserModel getUserByIndex(ProviderContainer container, {int index = 0}) {
  final userList = container.read(userListProvider);
  if (userList.isEmpty) fail('User list is empty');
  if (index < 0 || index >= userList.length) {
    fail('User index is out of bounds');
  }
  return userList[index];
}
