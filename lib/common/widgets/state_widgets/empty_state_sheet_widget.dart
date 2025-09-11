import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_line_widget.dart';
import 'package:zoe/core/constants/empty_state_constants.dart';
import 'package:zoe/features/content/models/content_model.dart';

class EmptyStateSheetWidget extends StatelessWidget {
  final Color color;
  final ContentType? contentType;

  const EmptyStateSheetWidget({
    super.key,
    required this.color,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: EmptyContentTypeConstants.sheetWidth,
      height: EmptyContentTypeConstants.sheetHeight,
      decoration: _getSheetDecoration(theme),
      child: Column(
        children: [_buildSheetHeader(theme), ..._buildContentLines()],
      ),
    );
  }

  BoxDecoration _getSheetDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSheetHeader(ThemeData theme) {
    return Container(
      height: EmptyContentTypeConstants.headerHeight,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(color: color.withValues(alpha: 0.1), width: 1),
        ),
      ),
    );
  }

  List<Widget> _buildContentLines() {
    return List.generate(
      EmptyContentTypeConstants.totalSheetLines,
      (index) => EmptyStateLineWidget(color: color, contentType: contentType),
    );
  }
}
