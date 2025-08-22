import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows a bottom sheet for selecting document source
Future<DocumentSource?> showDocumentSelectionBottomSheet(BuildContext context) async {
  return showModalBottomSheet<DocumentSource>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    enableDrag: true,
    showDragHandle: true,
    elevation: 6,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const DocumentSelectionBottomSheetWidget(),
  );
}

enum DocumentSource {
  camera,
  photoGallery,
  filePicker,
}

class DocumentSelectionBottomSheetWidget extends StatelessWidget {
  const DocumentSelectionBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: StyledIconContainer(
              icon: Icons.add,
              size: 72,
              borderRadius: BorderRadius.circular(36),
            ),
          ),
          const SizedBox(height: 12),
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
            onTap: () => Navigator.of(context).pop(DocumentSource.camera),
          ),
          ],
          const SizedBox(height: 16),
          _buildOptionButton(
            context,
            icon: Icons.photo_library_rounded,
            title: l10n.photoGallery,
            subtitle: l10n.selectFromGallery,
            color: AppColors.successColor,
            onTap: () => Navigator.of(context).pop(DocumentSource.photoGallery),
          ),
          const SizedBox(height: 16),
          _buildOptionButton(
            context,
            icon: Icons.folder_open_rounded,
            title: l10n.filePicker,
            subtitle: l10n.browseFiles,
            color: AppColors.secondaryColor,
            onTap: () => Navigator.of(context).pop(DocumentSource.filePicker),
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
