import 'package:flutter/material.dart';
import 'package:zoe/features/content/models/content_model.dart';

class EmptyStateCustomBgWidget extends StatelessWidget {
  final Color color;
  final ContentType? contentType;
  final IconData? icon;

  const EmptyStateCustomBgWidget({
    super.key,
    required this.color,
    required this.contentType,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 220,
      decoration: _getSheetDecoration(context),
      child: Column(
        children: [_buildSheetHeader(context), ..._buildContentLines()],
      ),
    );
  }

  BoxDecoration _getSheetDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
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

  Widget _buildSheetHeader(BuildContext context) {
    return Container(
      height: 40,
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
      4,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [_buildIcon(), const SizedBox(width: 12), _buildLine()],
        ),
      ),
    );
  }

  static const Map<ContentType, IconData> _iconMap = {
    ContentType.task: Icons.task_alt_outlined,
    ContentType.event: Icons.event_rounded,
    ContentType.document: Icons.insert_drive_file_rounded,
    ContentType.link: Icons.link_rounded,
    ContentType.poll: Icons.poll_rounded,
  };

  Widget _buildIcon() {
    final iconData = icon ?? _iconMap[contentType] ?? Icons.article_rounded;
    return Icon(iconData, size: 16, color: color.withValues(alpha: 0.2));
  }

  Widget _buildLine() {
    return Expanded(
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
