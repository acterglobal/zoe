import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/add_block_menu.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/add_block_trigger.dart';

/// Add block widget for sheet detail screen
class SheetAddBlock extends ConsumerWidget {
  final String? sheetId;

  const SheetAddBlock({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAddMenu = ref.watch(sheetDetailProvider(sheetId)).showAddMenu;
    final isEditing = ref.watch(isEditingProvider(sheetId));

    if (!isEditing) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddBlockTrigger(sheetId: sheetId),
        if (showAddMenu) AddBlockMenu(sheetId: sheetId),
      ],
    );
  }
}
