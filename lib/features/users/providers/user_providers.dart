import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
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

final getUsersBySheetIdProvider = Provider.family<List<UserModel>, String>((ref, sheetId) {
  // Get all content for the specific sheet
  final allContent = ref.watch(contentListProvider);
  final sheetContent = allContent.where((content) => content.sheetId == sheetId).toList();
  
  // Get all users
  final userList = ref.watch(userListProvider);
  
  // Extract unique user IDs from content created in this sheet
  final userIds = sheetContent.map((content) => content.createdBy).toSet();
  
  // Filter users based on content creators in this sheet
  return userList.where((user) => userIds.contains(user.id)).toList();
});
