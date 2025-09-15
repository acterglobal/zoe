import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/option_button_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showContextMenuBottomSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  VoidCallback? onEdit,
  VoidCallback? onCopy,
  VoidCallback? onDelete,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => ContextMenuBottomSheetWidget(
      title: title,
      subtitle: subtitle,
      onEdit: onEdit,
      onCopy: onCopy,
      onDelete: onDelete,
    ),
  );
}

class ContextMenuBottomSheetWidget extends ConsumerWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onEdit;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;

  const ContextMenuBottomSheetWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 30),

          // Edit
          if (onEdit != null) ...[
            OptionButtonWidget(
              icon: Icons.edit_rounded,
              title: l10n.edit,
              titleStyle: theme.textTheme.titleLarge,
              color: theme.colorScheme.primary,
              onTap: () {
                Navigator.of(context).pop();
                onEdit!.call();
              },
            ),
            const SizedBox(height: 15),
          ],

          // Copy Title
          if (onCopy != null) ...[
            OptionButtonWidget(
              icon: Icons.copy_rounded,
              title: l10n.copy,
              titleStyle: theme.textTheme.titleLarge,
              color: theme.colorScheme.secondary,
              onTap: () {
                Navigator.of(context).pop();
                onCopy!.call();
              },
            ),
            const SizedBox(height: 15),
          ],

          // Delete
          if (onDelete != null) ...[
            OptionButtonWidget(
              icon: Icons.delete_rounded,
              title: l10n.delete,
              titleStyle: theme.textTheme.titleLarge,
              color: theme.colorScheme.error,
              onTap: () {
                Navigator.of(context).pop();
                onDelete!.call();
              },
            ),
            const SizedBox(height: 15),
          ],
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
