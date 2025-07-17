import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/edit_save_button_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/sheet_more_menu_widget.dart';

/// App bar widget for sheet detail screen
class SheetDetailAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String sheetId;

  const SheetDetailAppBar({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      actions: [
        EditSaveButtonWidget(sheetId: sheetId),
        SheetMoreMenuWidget(sheetId: sheetId),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
