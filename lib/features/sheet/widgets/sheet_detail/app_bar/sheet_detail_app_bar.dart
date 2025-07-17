import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/sheet_more_menu_widget.dart';

/// App bar widget for sheet detail screen
class SheetDetailAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String sheetId;

  const SheetDetailAppBar({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider(sheetId));
    return AppBar(
      actions: [
        ZoePrimaryButton(
          text: isEditing ? 'Save' : 'Edit',
          icon: isEditing ? Icons.save_rounded : Icons.edit_rounded,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onPressed: () =>
              ref.read(sheetDetailProvider(sheetId).notifier).toggleEditSave(),
        ),
        SheetMoreMenuWidget(sheetId: sheetId),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
