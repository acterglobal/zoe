import 'package:flutter/material.dart';
import 'package:zoe/core/constants/empty_state_constants.dart';
import 'package:zoe/features/content/models/content_model.dart';

class EmptyStateLineWidget extends StatelessWidget {
  final Color color;
  final ContentType? contentType;

  const EmptyStateLineWidget({
    super.key,
    required this.color,
    this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: EmptyContentTypeConstants.sheetLineSpacing,
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: EmptyContentTypeConstants.checkboxSpacing),
          _buildLine(),
        ],
      ),
    );
  }

  /// Mapping between ContentType and their respective icons
  static const Map<ContentType, IconData> _iconMap = {
    ContentType.task: Icons.task_alt_outlined,
    ContentType.event: Icons.event_rounded,
    ContentType.document: Icons.insert_drive_file_rounded,
    ContentType.link: Icons.link_rounded,
    ContentType.poll: Icons.poll_rounded,
  };

  Widget _buildIcon() {
    final iconData = _iconMap[contentType] ?? Icons.article_rounded;
    return _buildEmptyIcon(iconData);
  }

  Widget _buildEmptyIcon(IconData iconData) {
    return Icon(
      iconData,
      size: EmptyContentTypeConstants.checkboxSize,
      color: color.withValues(alpha: 0.2),
    );
  }

  Widget _buildLine() {
    return Expanded(
      child: Container(
        height: EmptyContentTypeConstants.sheetLineHeight,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
