import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoe/common/widgets/document_selection_bottom_sheet.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

void selectProfileFileSource(
  BuildContext context,
  String userId,
  WidgetRef ref, {
  Function(String)? onImageSelected,
}) {
  showFileSelectionBottomSheet(
    context,
    onTapCamera: () async {
      final image = await _pickImage(ref, ImageSource.camera);
      if (image != null) {
        _updateUserAvatar(ref, userId, image.path);
        onImageSelected?.call(image.path);
      }
    },
    onTapGallery: () async {
      final image = await _pickImage(ref, ImageSource.gallery);
      if (image != null) {
        _updateUserAvatar(ref, userId, image.path);
        onImageSelected?.call(image.path);
      }
    },
  );
}

Future<XFile?> _pickImage(WidgetRef ref, ImageSource source) async {
  return ref.read(imagePickerProvider).pickImage(
    source: source,
    imageQuality: 80,
  );
}

void _updateUserAvatar(WidgetRef ref, String userId, String imagePath) {
  final currentUser = ref.read(currentUserProvider).value;
  if (currentUser != null) {
    final updatedUser = currentUser.copyWith(
      avatar: imagePath,
    );
    ref.read(userListProvider.notifier).updateUser(userId, updatedUser);
  }
}