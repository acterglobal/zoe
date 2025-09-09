import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';

class ZoeSheetFloatingActionButton extends ConsumerWidget {
  final String parentId;
  final String sheetId;

  const ZoeSheetFloatingActionButton({
    super.key,
    required this.parentId,
    required this.sheetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (CommonUtils.isKeyboardOpen(context)) return const SizedBox.shrink();

    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId != null || editContentId == parentId;

    return ZoeFloatingActionButton(
      icon: isEditing ? Icons.save_rounded : Icons.add_rounded,
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
