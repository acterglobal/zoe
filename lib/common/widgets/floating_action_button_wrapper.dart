import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';

class FloatingActionButtonWrapper extends ConsumerWidget {
  final String parentId;
  final String sheetId;
  final Color? primaryColor;

  const FloatingActionButtonWrapper({
    super.key,
    required this.parentId,
    required this.sheetId,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editContentId = ref.watch(editContentIdProvider);

    bool isEditing = false;
    if (editContentId != null) {
      // For content detail screens, show save state only if:
      // 1. The current content itself is being edited, OR
      // 2. A child content (belonging to this parent) is being edited
      if (editContentId == parentId) {
        isEditing = true;
      } else {
        // Check if the edited content belongs to this parent
        final editedContent = ref.watch(contentProvider(editContentId));
        isEditing = editedContent?.parentId == parentId;
      }
    }

    return ZoeFloatingActionButton(
      icon: isEditing ? Icons.save_rounded : Icons.add_rounded,
      primaryColor: primaryColor,
      onPressed: () => isEditing
          ? ref.read(editContentIdProvider.notifier).state = null
          : showAddContentBottomSheet(
              context,
              parentId: parentId,
              sheetId: sheetId,
            ),
    );
  }
}
