import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

final showSheetNameProvider = Provider<bool>((ref) => true);

class DisplaySheetNameWidget extends ConsumerWidget {
  final String sheetId;

  const DisplaySheetNameWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return SizedBox.shrink();
    final theme = Theme.of(context);

    return Flexible(
      child: Text(
        '${sheet.emoji} ${sheet.title}',
        style: theme.textTheme.bodySmall 
      ),
    );
  }
}
