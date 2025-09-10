import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileAvatarNotifier extends StateNotifier<Map<String, String>> {
  ProfileAvatarNotifier() : super({});

  void setAvatarPath(String userId, String path) {
    state = {...state, userId: path};
  }

  String? getAvatarPath(String userId) {
    return state[userId];
  }
}
