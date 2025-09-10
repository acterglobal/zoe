import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/profile/providers/profile_notifiers.dart';

final profileAvatarNotifierProvider = StateNotifierProvider<ProfileAvatarNotifier, Map<String, String>>(
  (ref) => ProfileAvatarNotifier(),
);

final profileAvatarProvider = Provider.family<String?, String>((ref, userId) {
  final avatarState = ref.watch(profileAvatarNotifierProvider);
  return avatarState[userId];
});
