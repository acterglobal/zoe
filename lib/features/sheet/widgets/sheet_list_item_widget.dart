import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

class SheetListItemWidget extends ConsumerWidget {
  final String sheetId;
  const SheetListItemWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.sheet.route.replaceAll(':sheetId', sheet.id)),
      child: GlassyContainer(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildEmojiContainer(sheet.emoji, sheet.color, theme),
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
      ),
    );
  }

  Widget _buildEmojiContainer(String emoji, Color? color, ThemeData theme) {
    return StyledContentContainer(
      size: 56,
      primaryColor: color ?? theme.colorScheme.primary,
      backgroundOpacity: 0.1,
      borderOpacity: 0.10,
      shadowOpacity: 0.06,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }

  Widget _buildContentSection(dynamic sheet, ThemeData theme) {
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
    );
  }
}
