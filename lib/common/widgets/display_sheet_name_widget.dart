import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';

class DisplaySheetNameWidget extends ConsumerWidget {
  final String sheetId;

  const DisplaySheetNameWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return SizedBox.shrink();
    final theme = Theme.of(context);

    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetAvatarWidget(
            sheetId: sheet.id,
            size: 20,
            iconSize: 12,
            imageSize: 12,
            emojiSize: 10,
          ),
          const SizedBox(width: 4),
          Expanded(child: Text(sheet.title, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
