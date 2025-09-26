import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

class TestUserList extends UserList {
  final List<UserModel> initialUsers;

  TestUserList(this.initialUsers);

  @override
  List<UserModel> build() => initialUsers;
}