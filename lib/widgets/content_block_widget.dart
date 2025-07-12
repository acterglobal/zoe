import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/models/content_block.dart';

class ContentBlockWidget extends StatefulWidget {
  final ContentBlock block;
  final bool isEditing;
  final Function(ContentBlock) onUpdate;
  final VoidCallback onDelete;

  const ContentBlockWidget({
    super.key,
    required this.block,
    required this.isEditing,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ContentBlockWidget> createState() => _ContentBlockWidgetState();
}

class _ContentBlockWidgetState extends State<ContentBlockWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Block header with drag handle and delete button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drag handle (visible on hover)
                AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.drag_indicator,
                      size: 16,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),

                // Block type icon
                Icon(_getBlockIcon(), size: 16, color: const Color(0xFF6B7280)),
                const SizedBox(width: 8),

                // Block title (editable)
                Expanded(child: _buildBlockTitle()),

                // Delete button (visible on hover)
                AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    color: const Color(0xFF9CA3AF),
                    onPressed: widget.onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Block content
            Padding(
              padding: const EdgeInsets.only(left: 28), // Align with title
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockTitle() {
    String title = '';
    switch (widget.block.type) {
      case ContentBlockType.todo:
        title = (widget.block as TodoBlock).title;
        break;
      case ContentBlockType.event:
        title = (widget.block as EventBlock).title;
        break;
      case ContentBlockType.list:
        title = (widget.block as ListBlock).title;
        break;
      case ContentBlockType.text:
        return const SizedBox.shrink(); // Text blocks don't have titles
    }

    return TextField(
      controller: TextEditingController(text: title),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Untitled',
        hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (value) {
        switch (widget.block.type) {
          case ContentBlockType.todo:
            widget.onUpdate((widget.block as TodoBlock).copyWith(title: value));
            break;
          case ContentBlockType.event:
            widget.onUpdate(
              (widget.block as EventBlock).copyWith(title: value),
            );
            break;
          case ContentBlockType.list:
            widget.onUpdate((widget.block as ListBlock).copyWith(title: value));
            break;
          case ContentBlockType.text:
            break;
        }
      },
    );
  }

  Widget _buildContent() {
    switch (widget.block.type) {
      case ContentBlockType.todo:
        return _buildTodoBlock(widget.block as TodoBlock);
      case ContentBlockType.event:
        return _buildEventBlock(widget.block as EventBlock);
      case ContentBlockType.list:
        return _buildListBlock(widget.block as ListBlock);
      case ContentBlockType.text:
        return _buildTextBlock(widget.block as TextBlock);
    }
  }

  Widget _buildTodoBlock(TodoBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Todo items
        ...block.items.map((todo) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () {
                    final updatedTodo = todo.copyWith(
                      isCompleted: !todo.isCompleted,
                    );
                    final updatedItems = block.items.map((item) {
                      return item.id == todo.id ? updatedTodo : item;
                    }).toList();
                    widget.onUpdate(block.copyWith(items: updatedItems));
                  },
                  child: Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: todo.isCompleted
                          ? const Color(0xFF10B981)
                          : Colors.transparent,
                      border: Border.all(
                        color: todo.isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFFD1D5DB),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: todo.isCompleted
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Todo text
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: todo.text),
                    style: TextStyle(
                      fontSize: 14,
                      color: todo.isCompleted
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF374151),
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'To-do',
                      hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: null,
                    onChanged: (value) {
                      final updatedTodo = todo.copyWith(text: value);
                      final updatedItems = block.items.map((item) {
                        return item.id == todo.id ? updatedTodo : item;
                      }).toList();
                      widget.onUpdate(block.copyWith(items: updatedItems));
                    },
                  ),
                ),

                // Delete todo button
                if (_isHovered)
                  IconButton(
                    icon: const Icon(Icons.close, size: 14),
                    color: const Color(0xFF9CA3AF),
                    onPressed: () {
                      final updatedItems = block.items
                          .where((item) => item.id != todo.id)
                          .toList();
                      widget.onUpdate(block.copyWith(items: updatedItems));
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),

        // Add new todo item
        TextButton.icon(
          onPressed: () {
            final newTodo = TodoItem(text: '');
            final updatedItems = [...block.items, newTodo];
            widget.onUpdate(block.copyWith(items: updatedItems));
          },
          icon: const Icon(Icons.add, size: 16, color: Color(0xFF9CA3AF)),
          label: const Text(
            'Add a to-do',
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            minimumSize: Size.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildEventBlock(EventBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event items
        ...block.events.map((event) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time indicator
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Event content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event title
                      TextField(
                        controller: TextEditingController(text: event.title),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Event title',
                          hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          final updatedEvent = event.copyWith(title: value);
                          final updatedEvents = block.events.map((item) {
                            return item.id == event.id ? updatedEvent : item;
                          }).toList();
                          widget.onUpdate(
                            block.copyWith(events: updatedEvents),
                          );
                        },
                      ),

                      // Event time
                      Text(
                        DateFormat(
                          'MMM dd, yyyy • h:mm a',
                        ).format(event.startTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),

                      // Event description (if any)
                      if (event.description?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            event.description!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Delete event button
                if (_isHovered)
                  IconButton(
                    icon: const Icon(Icons.close, size: 14),
                    color: const Color(0xFF9CA3AF),
                    onPressed: () {
                      final updatedEvents = block.events
                          .where((item) => item.id != event.id)
                          .toList();
                      widget.onUpdate(block.copyWith(events: updatedEvents));
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),

        // Add new event
        TextButton.icon(
          onPressed: () {
            final newEvent = EventItem(title: '', startTime: DateTime.now());
            final updatedEvents = [...block.events, newEvent];
            widget.onUpdate(block.copyWith(events: updatedEvents));
          },
          icon: const Icon(Icons.add, size: 16, color: Color(0xFF9CA3AF)),
          label: const Text(
            'Add an event',
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            minimumSize: Size.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildListBlock(ListBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // List items
        ...block.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bullet point
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B7280),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // List item text
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: item),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'List item',
                      hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: null,
                    onChanged: (value) {
                      final updatedItems = [...block.items];
                      updatedItems[index] = value;
                      widget.onUpdate(block.copyWith(items: updatedItems));
                    },
                  ),
                ),

                // Delete list item button
                if (_isHovered)
                  IconButton(
                    icon: const Icon(Icons.close, size: 14),
                    color: const Color(0xFF9CA3AF),
                    onPressed: () {
                      final updatedItems = [...block.items];
                      updatedItems.removeAt(index);
                      widget.onUpdate(block.copyWith(items: updatedItems));
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),

        // Add new list item
        TextButton.icon(
          onPressed: () {
            final updatedItems = [...block.items, ''];
            widget.onUpdate(block.copyWith(items: updatedItems));
          },
          icon: const Icon(Icons.add, size: 16, color: Color(0xFF9CA3AF)),
          label: const Text(
            'Add an item',
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            minimumSize: Size.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildTextBlock(TextBlock block) {
    return TextField(
      controller: TextEditingController(text: block.content),
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF374151),
        height: 1.5,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Type something...',
        hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
        contentPadding: EdgeInsets.zero,
      ),
      maxLines: null,
      onChanged: (value) {
        widget.onUpdate(block.copyWith(content: value));
      },
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
}
