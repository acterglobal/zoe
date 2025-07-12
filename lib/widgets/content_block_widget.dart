import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/models/content_block.dart';
import '../common/theme/app_theme.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with title and actions
          if (widget.isEditing)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getBlockIcon(),
                    size: 16,
                    color: const Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getBlockTypeName(),
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded, size: 16),
                    color: Colors.red,
                    onPressed: widget.onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

          // Content
          Padding(padding: const EdgeInsets.all(16), child: _buildContent()),
        ],
      ),
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
        // Title
        widget.isEditing
            ? TextField(
                controller: TextEditingController(text: block.title),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Block title',
                ),
                onChanged: (value) {
                  widget.onUpdate(block.copyWith(title: value));
                },
              )
            : Text(
                block.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
        const SizedBox(height: 12),

        // Todo items
        Column(
          children: block.items.map((todo) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
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
                      decoration: BoxDecoration(
                        color: todo.isCompleted
                            ? const Color(0xFF10B981)
                            : Colors.transparent,
                        border: Border.all(
                          color: todo.isCompleted
                              ? const Color(0xFF10B981)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: todo.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: widget.isEditing
                        ? TextField(
                            controller: TextEditingController(text: todo.text),
                            style: TextStyle(
                              fontSize: 14,
                              color: todo.isCompleted
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF1F2937),
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Todo item',
                            ),
                            onChanged: (value) {
                              final updatedTodo = todo.copyWith(text: value);
                              final updatedItems = block.items.map((item) {
                                return item.id == todo.id ? updatedTodo : item;
                              }).toList();
                              widget.onUpdate(
                                block.copyWith(items: updatedItems),
                              );
                            },
                          )
                        : Text(
                            todo.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: todo.isCompleted
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF1F2937),
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                  ),
                  if (widget.isEditing)
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      color: Colors.red,
                      onPressed: () {
                        final updatedItems = block.items
                            .where((item) => item.id != todo.id)
                            .toList();
                        widget.onUpdate(block.copyWith(items: updatedItems));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            );
          }).toList(),
        ),

        // Add new todo item
        if (widget.isEditing)
          TextButton.icon(
            onPressed: () {
              final newTodo = TodoItem(text: 'New task');
              final updatedItems = [...block.items, newTodo];
              widget.onUpdate(block.copyWith(items: updatedItems));
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add item'),
          ),
      ],
    );
  }

  Widget _buildEventBlock(EventBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        widget.isEditing
            ? TextField(
                controller: TextEditingController(text: block.title),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Block title',
                ),
                onChanged: (value) {
                  widget.onUpdate(block.copyWith(title: value));
                },
              )
            : Text(
                block.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
        const SizedBox(height: 12),

        // Event items
        Column(
          children: block.events.map((event) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: widget.isEditing
                              ? TextField(
                                  controller: TextEditingController(
                                    text: event.title,
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Event title',
                                  ),
                                  onChanged: (value) {
                                    final updatedEvent = event.copyWith(
                                      title: value,
                                    );
                                    final updatedEvents = block.events.map((
                                      item,
                                    ) {
                                      return item.id == event.id
                                          ? updatedEvent
                                          : item;
                                    }).toList();
                                    widget.onUpdate(
                                      block.copyWith(events: updatedEvents),
                                    );
                                  },
                                )
                              : Text(
                                  event.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                        ),
                        if (widget.isEditing)
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            color: Colors.red,
                            onPressed: () {
                              final updatedEvents = block.events
                                  .where((item) => item.id != event.id)
                                  .toList();
                              widget.onUpdate(
                                block.copyWith(events: updatedEvents),
                              );
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, y • h:mm a').format(event.startTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    if (event.description != null &&
                        event.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        // Add new event
        if (widget.isEditing)
          TextButton.icon(
            onPressed: () {
              final newEvent = EventItem(
                title: 'New event',
                startTime: DateTime.now(),
              );
              final updatedEvents = [...block.events, newEvent];
              widget.onUpdate(block.copyWith(events: updatedEvents));
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add event'),
          ),
      ],
    );
  }

  Widget _buildListBlock(ListBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        widget.isEditing
            ? TextField(
                controller: TextEditingController(text: block.title),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Block title',
                ),
                onChanged: (value) {
                  widget.onUpdate(block.copyWith(title: value));
                },
              )
            : Text(
                block.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
        const SizedBox(height: 12),

        // List items
        Column(
          children: block.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B7280),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: widget.isEditing
                        ? TextField(
                            controller: TextEditingController(text: item),
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF1F2937),
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'List item',
                            ),
                            onChanged: (value) {
                              final updatedItems = [...block.items];
                              updatedItems[index] = value;
                              widget.onUpdate(
                                block.copyWith(items: updatedItems),
                              );
                            },
                          )
                        : Text(
                            item,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                  ),
                  if (widget.isEditing)
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      color: Colors.red,
                      onPressed: () {
                        final updatedItems = [...block.items];
                        updatedItems.removeAt(index);
                        widget.onUpdate(block.copyWith(items: updatedItems));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            );
          }).toList(),
        ),

        // Add new list item
        if (widget.isEditing)
          TextButton.icon(
            onPressed: () {
              final updatedItems = [...block.items, 'New item'];
              widget.onUpdate(block.copyWith(items: updatedItems));
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add item'),
          ),
      ],
    );
  }

  Widget _buildTextBlock(TextBlock block) {
    return widget.isEditing
        ? TextField(
            controller: TextEditingController(text: block.content),
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1F2937),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Type something...',
            ),
            maxLines: null,
            onChanged: (value) {
              widget.onUpdate(block.copyWith(content: value));
            },
          )
        : Text(
            block.content,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1F2937),
            ),
          );
  }

  IconData _getBlockIcon() {
    switch (widget.block.type) {
      case ContentBlockType.todo:
        return Icons.check_box_rounded;
      case ContentBlockType.event:
        return Icons.event_rounded;
      case ContentBlockType.list:
        return Icons.list_rounded;
      case ContentBlockType.text:
        return Icons.text_fields_rounded;
    }
  }

  String _getBlockTypeName() {
    switch (widget.block.type) {
      case ContentBlockType.todo:
        return 'To-do List';
      case ContentBlockType.event:
        return 'Events';
      case ContentBlockType.list:
        return 'List';
      case ContentBlockType.text:
        return 'Text';
    }
  }
}
