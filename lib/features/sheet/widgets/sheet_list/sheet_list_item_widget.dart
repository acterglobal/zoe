import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/sheet/providers/sheet_provider.dart';

class SheetListItemWidget extends ConsumerWidget {
  final String sheetId;
  const SheetListItemWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(sheetId));
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => context.push(
          AppRoutes.sheet.route.replaceAll(':sheetId', sheet.id),
        ),
        leading: Text(sheet.emoji ?? ''),
        title: Text(sheet.title),
        subtitle: Text(
          sheet.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
