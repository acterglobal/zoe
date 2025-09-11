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

  Widget _buildIcon() {
    switch (contentType) {
      case ContentType.task:
       return Icon(
          Icons.task_alt_outlined,
          size: EmptyContentTypeConstants.checkboxSize,
          color: color.withValues(alpha: 0.2),
        );
      case ContentType.event:
        return Icon(
          Icons.event_rounded,
          size: EmptyContentTypeConstants.checkboxSize,
          color: color.withValues(alpha: 0.2),
        );
      case ContentType.document:
        return Icon(
          Icons.insert_drive_file_rounded,
          size: EmptyContentTypeConstants.checkboxSize,
          color: color.withValues(alpha: 0.2),
        );
      case ContentType.link:
        return Icon(
          Icons.link_rounded,
          size: EmptyContentTypeConstants.checkboxSize,
          color: color.withValues(alpha: 0.2),
        );
      case ContentType.poll:
        return Icon(
          Icons.poll_rounded,
          size: EmptyContentTypeConstants.checkboxSize,
          color: color.withValues(alpha: 0.2),
        );
      default:
        return Icon(
          Icons.article_rounded,
          size: EmptyContentTypeConstants.checkboxSize,
          color: color.withValues(alpha: 0.2),
        );
    }
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
