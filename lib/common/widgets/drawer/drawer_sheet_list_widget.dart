import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DrawerSheetListWidget extends ConsumerWidget {
  const DrawerSheetListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, ref),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SheetListWidget(
              sheetsProvider: memberSheetsProvider,
              shrinkWrap: false,
              isCompact: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            L10n.of(context).sheets,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const Spacer(),
          ZoeIconButtonWidget(
            icon: Icons.add,
            onTap: () {
              if (context.canPop()) context.pop();
              final sheet = SheetModel();
              ref.read(sheetListProvider.notifier).addSheet(sheet);
              ref.read(editContentIdProvider.notifier).state = sheet.id;
              context.push(
                AppRoutes.sheet.route.replaceAll(':sheetId', sheet.id),
              );
            },
            size: 16,
          ),
        ],
      ),
    );
  }
}
