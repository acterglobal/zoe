import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

void selectProfileFileSource(
  BuildContext context,
  String userId,
  WidgetRef ref, {
  Function(String)? onImageSelected,
}) {
  showMediaSelectionBottomSheet(
    context,
    onTapCamera: (image) async {
      _updateUserAvatar(ref, userId, image.path);
      onImageSelected?.call(image.path);
    },
    onTapGallery: (images) async {
      final image = images.first;
      _updateUserAvatar(ref, userId, image.path);
      onImageSelected?.call(image.path);
    },
  );
}

void _updateUserAvatar(WidgetRef ref, String userId, String imagePath) {
  final currentUser = ref.read(currentUserProvider).value;
  if (currentUser != null) {
    final updatedUser = currentUser.copyWith(avatar: imagePath);
    ref.read(userListProvider.notifier).updateUser(userId, updatedUser);
  }
}
