import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/constants/firestore_collection_constants.dart';
import 'package:zoe/constants/firestore_field_constants.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

part 'user_providers.g.dart';

/// Main user list provider with all user management functionality
@Riverpod(keepAlive: true)
class UserList extends _$UserList {
  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.users);

  StreamSubscription? _subscription;

  @override
  List<UserModel> build() {
    _subscription?.cancel();
    _subscription = null;

    _subscription = collection.snapshots().listen((snapshot) {
      state = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });

    ref.onDispose(() => _subscription?.cancel());
    return [];
  }

  Future<void> addUser(UserModel user) async {
    await collection.doc(user.id).set(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await collection.doc(userId).delete();
  }

  Future<void> updateUserName(String userId, String name) async {
    await collection.doc(userId).update({FirestoreFieldConstants.name: name});
  }

  Future<void> updateUser(String userId, UserModel updatedUser) async {
    await collection.doc(userId).update(updatedUser.toJson());
  }
}

/// Provider for the current user model
@riverpod
UserModel? currentUser(Ref ref) {
  final authUser = ref.watch(authProvider);
  if (authUser == null) return null;
  return ref.watch(getUserByIdProvider(authUser.id));
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
  final currentUserId = ref.watch(currentUserProvider)?.id ?? '';
  final user = ref.watch(getUserByIdProvider(userId));

  if (currentUserId == userId) return 'You';
  if (user != null && user.name.isNotEmpty) return user.name;
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
