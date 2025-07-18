import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// Add block trigger widget
class AddBlockTrigger extends ConsumerWidget {
  final String sheetId;

  const AddBlockTrigger({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAddMenu = ref.watch(sheetDetailProvider(sheetId)).showAddMenu;
    return GestureDetector(
      onTap: () =>
          ref.read(sheetDetailProvider(sheetId).notifier).toggleAddMenu(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(showAddMenu ? Icons.close : Icons.add, size: 20),
            const SizedBox(width: 8),
            Text(showAddMenu ? 'Cancel' : 'Add a block'),
          ],
        ),
      ),
    );
  }
}
