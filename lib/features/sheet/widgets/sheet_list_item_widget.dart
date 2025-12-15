import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';

class SheetListItemWidget extends ConsumerWidget {
  final String sheetId;
  final bool isCompact;

  const SheetListItemWidget({
    super.key,
    required this.sheetId,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final child = isCompact
        ? _buildCompactDesign(context, theme, sheet)
        : _buildExpandedDesign(context, theme, sheet);

    return GestureDetector(
      onTap: () {
        if (context.canPop() && isCompact) context.pop();
        context.push(AppRoutes.sheet.route.replaceAll(':sheetId', sheet.id));
      },
      child: child,
    );
  }

  Widget _buildCompactDesign(
    BuildContext context,
    ThemeData theme,
    SheetModel sheet,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SheetAvatarWidget(sheetId: sheet.id, isCompact: isCompact),
          const SizedBox(width: 16),
          Expanded(child: _buildContentSection(sheet, theme)),
          const SizedBox(width: 12),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedDesign(
    BuildContext context,
    ThemeData theme,
    SheetModel sheet,
  ) {
    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SheetAvatarWidget(sheetId: sheet.id, isCompact: isCompact),
          const SizedBox(width: 16),
          Expanded(child: _buildContentSection(sheet, theme)),
          const SizedBox(width: 12),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(SheetModel sheet, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sheet.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (!isCompact) ...[
          const SizedBox(height: 4),
          Text(
            sheet.description?.plainText ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
