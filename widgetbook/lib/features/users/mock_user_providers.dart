import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/users/models/user_model.dart';

final mockUserListProvider = Provider<List<UserModel>>((ref) {
  return [];
});

final mockUsersBySheetIdProvider = Provider.family<List<UserModel>, String>((ref, sheetId) {
  return [];
}, dependencies: [mockUserListProvider]);
