import 'package:zoe/features/users/data/user_list.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

class MockUserList extends UserList {
  @override
  List<UserModel> build() => userList;
}
