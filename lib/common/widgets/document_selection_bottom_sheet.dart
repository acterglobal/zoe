import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows a bottom sheet for selecting document source
void showFileSelectionBottomSheet(
  BuildContext context, {
  required VoidCallback onTapCamera,
  required VoidCallback onTapGallery,
  VoidCallback? onTapFileChooser,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    enableDrag: true,
    showDragHandle: true,
    elevation: 6,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => DocumentSelectionBottomSheetWidget(
      onTapCamera: onTapCamera,
      onTapGallery: onTapGallery,
      onTapFileChooser: onTapFileChooser,
    ),
  );
}

class DocumentSelectionBottomSheetWidget extends StatelessWidget {
  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;
  final VoidCallback? onTapFileChooser;

  const DocumentSelectionBottomSheetWidget({
    super.key,
    required this.onTapCamera,
    required this.onTapGallery,
    required this.onTapFileChooser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
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
            l10n.selectDocument,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.chooseHowToAddDocument,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (!CommonUtils.isDesktop(context)) ...[
            const SizedBox(height: 32),
            _buildOptionButton(
            context,
            icon: Icons.camera_alt_rounded,
            title: l10n.camera,
            subtitle: l10n.takePhotoOrVideo,
            color: AppColors.brightOrangeColor,
            onTap: () {
              Navigator.of(context).pop();
              onTapCamera();
            },
          ),
          ],
          const SizedBox(height: 16),
          _buildOptionButton(
            context,
            icon: Icons.photo_library_rounded,
            title: l10n.photoGallery,
            subtitle: l10n.selectFromGallery,
            color: AppColors.successColor,
            onTap: () {
              Navigator.of(context).pop();
              onTapGallery();
            },
          ),
          const SizedBox(height: 16),
          if (onTapFileChooser != null)
            _buildOptionButton(
              context,
              icon: Icons.folder_open_rounded,
              title: l10n.filePicker,
              subtitle: l10n.browseFiles,
              color: AppColors.secondaryColor,
              onTap: () {
                Navigator.of(context).pop();
                onTapFileChooser!();
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: GlassyContainer(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(16),
        borderOpacity: 0.1,
        shadowOpacity: 0.05,
        child: Row(
          children: [
            StyledIconContainer(
              icon: icon,
              size: 52,
              primaryColor: color,
              borderRadius: BorderRadius.circular(24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
