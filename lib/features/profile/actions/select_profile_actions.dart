import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoe/common/widgets/document_selection_bottom_sheet.dart';
import 'package:zoe/features/profile/providers/profile_providers.dart';

void selectProfileFileSource(
  BuildContext context,
  String userId,
  WidgetRef ref, {
  Function(String)? onImageSelected,
}) {
  showFileSelectionBottomSheet(
    context,
    onTapCamera: () async {
      final image = await _handleProfileCameraSelection(context, ref, userId);
      if (image != null && onImageSelected != null) {
        onImageSelected(image.path);
      }
    },
    onTapGallery: () async {
      final image = await _handleProfileGallerySelection(context, ref, userId);
      if (image != null && onImageSelected != null) {
        onImageSelected(image.path);
      }
    },
  );
}

Future<XFile?> _handleProfileCameraSelection(
  BuildContext context,
  WidgetRef ref,
  String userId,
) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80,
  );

  if (image != null) {
    ref
        .read(profileAvatarNotifierProvider.notifier)
        .setAvatarPath(userId, image.path);
  }
  return image;
}

Future<XFile?> _handleProfileGallerySelection(
  BuildContext context,
  WidgetRef ref,
  String userId,
) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (image != null) {
    ref
        .read(profileAvatarNotifierProvider.notifier)
        .setAvatarPath(userId, image.path);
  }
  return image;
}
