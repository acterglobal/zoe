import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/bottom_sheet_option_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows a bottom sheet for selecting document source
Future<void> showMediaSelectionBottomSheet(
  BuildContext context, {
  String? title,
  String? subtitle,
  bool allowMultiple = false,
  int imageQuality = 80,
  required Function(XFile) onTapCamera,
  required Function(List<XFile>) onTapGallery,
  Function(List<XFile>)? onTapFileChooser,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    enableDrag: true,
    showDragHandle: true,
    elevation: 6,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => MediaSelectionBottomSheetWidget(
      title: title,
      subtitle: subtitle,
      allowMultiple: allowMultiple,
      imageQuality: imageQuality,
      onTapCamera: onTapCamera,
      onTapGallery: onTapGallery,
      onTapFileChooser: onTapFileChooser,
    ),
  );
}

class MediaSelectionBottomSheetWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool allowMultiple;
  final int imageQuality;
  final Function(XFile) onTapCamera;
  final Function(List<XFile>) onTapGallery;
  final Function(List<XFile>)? onTapFileChooser;

  const MediaSelectionBottomSheetWidget({
    super.key,
    this.title,
    this.subtitle,
    required this.allowMultiple,
    required this.imageQuality,
    required this.onTapCamera,
    required this.onTapGallery,
    required this.onTapFileChooser,
  });

  Future<void> _onTapCamera(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );
      if (image != null) onTapCamera(image);
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
    } finally {
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _onTapGallery(BuildContext context) async {
    try {
      final picker = ImagePicker();
      if (allowMultiple) {
        final images = await picker.pickMultiImage(imageQuality: imageQuality);
        if (images.isNotEmpty) onTapGallery(images);
      } else {
        final image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality,
        );
        if (image != null) onTapGallery([image]);
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    } finally {
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _onTapFileChooser(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
      );
      if (result != null && result.files.isNotEmpty) {
        onTapFileChooser!(result.files.map((file) => file.xFile).toList());
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    } finally {
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final titleText = title ?? l10n.selectMedia;
    final subtitleText = subtitle ?? l10n.chooseAMediaFile;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titleText,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitleText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (!CommonUtils.isDesktop(context)) ...[
            const SizedBox(height: 32),
            BottomSheetOptionWidget(
              icon: Icons.camera_alt_rounded,
              title: l10n.camera,
              subtitle: l10n.takePhotoOrVideo,
              color: AppColors.brightOrangeColor,
              onTap: () => _onTapCamera(context),
            ),
          ],
          const SizedBox(height: 16),
          BottomSheetOptionWidget(
            icon: Icons.photo_library_rounded,
            title: l10n.photoGallery,
            subtitle: l10n.selectFromGallery,
            color: AppColors.successColor,
            onTap: () => _onTapGallery(context),
          ),
          const SizedBox(height: 16),
          if (onTapFileChooser != null)
            BottomSheetOptionWidget(
              icon: Icons.folder_open_rounded,
              title: l10n.filePicker,
              subtitle: l10n.browseFiles,
              color: AppColors.secondaryColor,
              onTap: () => _onTapFileChooser(context),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
