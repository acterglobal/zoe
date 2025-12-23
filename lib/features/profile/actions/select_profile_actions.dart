import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';

void selectProfileFileSource(
  BuildContext context, {
  Function(XFile?)? onImageSelected,
  bool hasAvatar = false,
}) {
  showMediaSelectionBottomSheet(
    context,
    onTapCamera: (image) => onImageSelected?.call(image),
    onTapGallery: (images) async => onImageSelected?.call(images.first),
    onTapRemoveImage: hasAvatar
        ? () async {
            onImageSelected?.call(null);
            Navigator.pop(context);
          }
        : null,
  );
}
