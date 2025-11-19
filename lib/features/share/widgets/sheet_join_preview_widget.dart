import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showJoinSheetBottomSheet({
  required BuildContext context,
  required String parentId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SheetJoinPreviewWidget(parentId: parentId),
  );
}

class SheetJoinPreviewWidget extends ConsumerWidget {
  final String parentId;

  const SheetJoinPreviewWidget({super.key, required this.parentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sheet = ref.watch(sheetProvider(parentId));
    if (sheet == null) return const SizedBox.shrink();

    return MaxWidthWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L10n.of(context).joinSheet,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SheetAvatarWidget(
                sheetId: sheet.id,
                padding: const EdgeInsets.all(8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(sheet.title, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
          Text(
            sheet.description?.plainText ?? '',
            style: theme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          _buildJoinButton(context, ref),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(loggedInUserProvider).value;
    if (currentUserId == null) return const SizedBox.shrink();
    return ZoePrimaryButton(
      onPressed: () async {
        try {
          await ref
              .read(sheetListProvider.notifier)
              .addUserToSheet(parentId, currentUserId);
          if (context.mounted) {
            Navigator.of(context).pop();
            context.push(
              AppRoutes.sheet.route.replaceAll(':sheetId', parentId),
            );
          }
        } catch (e) {
          if (context.mounted) {
            // Show error to user
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Failed to join sheet: $e')));
          }
        }
      },
      icon: Icons.person_add_rounded,
      text: L10n.of(context).join,
    );
  }
}
