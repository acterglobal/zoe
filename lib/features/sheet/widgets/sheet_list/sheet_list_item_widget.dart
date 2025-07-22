import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class SheetListItemWidget extends StatelessWidget {
  final SheetModel sheet;
  const SheetListItemWidget({super.key, required this.sheet});

  @override
  Widget build(BuildContext context) {
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
