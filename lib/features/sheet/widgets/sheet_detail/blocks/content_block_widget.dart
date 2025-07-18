import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:zoey/features/sheet/models/content_block/content_block.dart';
import 'package:zoey/features/sheet/models/content_block/event_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/list_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/text_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/todo_block_model.dart';
import 'package:zoey/features/contents/text/widgets/text_content_widget.dart';
import 'package:zoey/features/contents/todos/widgets/todos_content_widget.dart';
import 'package:zoey/features/contents/events/widgets/events_content_widget.dart';
import 'package:zoey/features/contents/bullet-lists/widgets/bullets_content_widget.dart';

class ContentBlockWidget extends StatefulWidget {
  final ContentBlockModel block;
  final int blockIndex;
  final bool isEditing;
  final Function(ContentBlockModel) onUpdate;
  final VoidCallback onDelete;

  const ContentBlockWidget({
    super.key,
    required this.block,
    required this.blockIndex,
    required this.isEditing,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ContentBlockWidget> createState() => _ContentBlockWidgetState();
}

class _ContentBlockWidgetState extends State<ContentBlockWidget> {
  bool _isHovered = false;
  bool get _isTouchDevice =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _isHovered && widget.isEditing
                  ? Theme.of(
                      context,
                    ).colorScheme.surfaceContainerLowest.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
            padding: EdgeInsets.all(widget.isEditing ? 2 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content with inline controls
                _buildContentWithControls(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentWithControls() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Drag handle and icon (only in edit mode)
          if (widget.isEditing) Flexible(flex: 0, child: _buildLeftControls()),

          // Main content area
          Expanded(child: _buildMainContent()),

          // Right side: Delete button (only in edit mode)
          if (widget.isEditing) Flexible(flex: 0, child: _buildRightControls()),
        ],
      ),
    );
  }

  Widget _buildLeftControls() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 32,
      ), // Maximum width constraint
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle (positioned to align with content)
          AnimatedOpacity(
            opacity: (_isHovered || _isTouchDevice) ? 0.7 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: ReorderableDragStartListener(
              index: widget.blockIndex,
              child: Container(
                width: 14,
                height: 18,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _isHovered
                      ? Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.1)
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.drag_indicator,
                  size: 10,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          // Only add spacing if block icon will be shown
          if (widget.block.type != ContentBlockType.text || widget.isEditing)
            const SizedBox(width: 2),
          // Block type icon (aligned with content)
          if (widget.block.type != ContentBlockType.text || widget.isEditing)
            Container(
              margin: const EdgeInsets.only(top: 3),
              child: Icon(
                _getBlockIcon(),
                size: 10,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRightControls() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 32,
      ), // Maximum width constraint
      padding: const EdgeInsets.only(left: 4),
      child: AnimatedOpacity(
        opacity: (_isHovered || _isTouchDevice) ? 0.7 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.only(top: 2),
          child: SizedBox(
            width: 16,
            height: 16,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 10,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onPressed: widget.onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              style: IconButton.styleFrom(
                backgroundColor: _isHovered
                    ? Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.1)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      constraints: const BoxConstraints(minWidth: 0), // Allow shrinking
      padding: EdgeInsets.only(
        left: widget.isEditing ? 2 : _getContentPadding(),
        top: 0,
        bottom: 0,
      ),
      child: _buildContentWidget(),
    );
  }

  Widget _buildContentWidget() {
    // Check if this is an embedded content block (old system) or separate content (new system)
    if (_hasEmbeddedContent()) {
      return _buildEmbeddedContentWidget();
    } else {
      return _buildSeparateContentWidget();
    }
  }

  bool _hasEmbeddedContent() {
    // Check if the block has embedded content based on its type
    switch (widget.block.type) {
      case ContentBlockType.text:
        return widget.block is TextBlockModel;
      case ContentBlockType.todo:
        return widget.block is TodoBlockModel;
      case ContentBlockType.event:
        return widget.block is EventBlockModel;
      case ContentBlockType.list:
        return widget.block is ListBlockModel;
    }
  }

  Widget _buildEmbeddedContentWidget() {
    // Handle embedded content blocks (backward compatibility)
    switch (widget.block.type) {
      case ContentBlockType.text:
        final textBlock = widget.block as TextBlockModel;
        return _buildInlineTextContent(textBlock);
      case ContentBlockType.todo:
        final todoBlock = widget.block as TodoBlockModel;
        return _buildInlineTodoContent(todoBlock);
      case ContentBlockType.event:
        final eventBlock = widget.block as EventBlockModel;
        return _buildInlineEventContent(eventBlock);
      case ContentBlockType.list:
        final listBlock = widget.block as ListBlockModel;
        return _buildInlineListContent(listBlock);
    }
  }

  Widget _buildSeparateContentWidget() {
    // Map content block types to their respective specialized widgets (new system)
    switch (widget.block.type) {
      case ContentBlockType.text:
        return TextContentWidget(
          textContentId: widget.block.id,
          isEditing: widget.isEditing,
        );
      case ContentBlockType.todo:
        return TodosContentWidget(
          todosContentId: widget.block.id,
          isEditing: widget.isEditing,
        );
      case ContentBlockType.event:
        return EventsContentWidget(
          eventsContentId: widget.block.id,
          isEditing: widget.isEditing,
        );
      case ContentBlockType.list:
        return BulletsContentWidget(
          bulletsContentId: widget.block.id,
          isEditing: widget.isEditing,
        );
    }
  }

  // Inline content builders for embedded content (backward compatibility)
  Widget _buildInlineTextContent(TextBlockModel block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isEditing || widget.block.type != ContentBlockType.text) ...[
          Text(
            block.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        Text(block.content, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildInlineTodoContent(TodoBlockModel block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          block.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...block.items.map(
          (todo) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: todo.isCompleted
                        ? const Color(0xFF10B981)
                        : Colors.transparent,
                    border: Border.all(
                      color: todo.isCompleted
                          ? const Color(0xFF10B981)
                          : Theme.of(context).colorScheme.outline,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: todo.isCompleted
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (todo.description?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            todo.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineEventContent(EventBlockModel block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          block.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...block.events.map(
          (event) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_month, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (event.description?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            event.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineListContent(ListBlockModel block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          block.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...block.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 9),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getBlockIcon() {
    switch (widget.block.type) {
      case ContentBlockType.todo:
        return Icons.check_box_outlined;
      case ContentBlockType.event:
        return Icons.event_outlined;
      case ContentBlockType.list:
        return Icons.format_list_bulleted;
      case ContentBlockType.text:
        return Icons.text_fields;
    }
  }

  double _getContentPadding() {
    // In the new layout, provide appropriate spacing for view mode
    if (widget.isEditing) {
      return 0; // No extra padding in edit mode since controls provide spacing
    }
    // In view mode, provide minimal left padding for proper alignment
    if (widget.block.type == ContentBlockType.text) {
      return 2; // Minimal indent for text blocks
    }
    return 24; // Reduced further - Other block types get moderate indent
  }
}
