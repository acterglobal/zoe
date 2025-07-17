import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:zoey/features/sheet/models/content_block/content_block.dart';
import 'package:zoey/features/sheet/models/content_block/event_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/list_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/text_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/todo_block_model.dart';
import 'package:zoey/core/theme/app_theme.dart';
import 'package:zoey/features/sheet/widgets/sheeting_details/event_editor_dialog.dart';
import 'package:zoey/features/sheet/widgets/sheeting_details/task_editor_dialog.dart';

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

  // Text controllers for managing cursor position
  late TextEditingController _titleController;
  late TextEditingController _textBlockController;
  final Map<String, TextEditingController> _todoControllers = {};
  final Map<String, TextEditingController> _eventControllers = {};
  final Map<int, TextEditingController> _listControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(ContentBlockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block != widget.block) {
      _updateControllers();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textBlockController.dispose();
    for (final controller in _todoControllers.values) {
      controller.dispose();
    }
    for (final controller in _eventControllers.values) {
      controller.dispose();
    }
    for (final controller in _listControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    // Initialize title controller
    String title = '';
    switch (widget.block.type) {
      case ContentBlockType.todo:
        title = (widget.block as TodoBlockModel).title;
        break;
      case ContentBlockType.event:
        title = (widget.block as EventBlockModel).title;
        break;
      case ContentBlockType.list:
        title = (widget.block as ListBlockModel).title;
        break;
      case ContentBlockType.text:
        title = (widget.block as TextBlockModel).title;
        break;
    }
    _titleController = TextEditingController(text: title);

    // Initialize text block controller
    if (widget.block.type == ContentBlockType.text) {
      _textBlockController = TextEditingController(
        text: (widget.block as TextBlockModel).content,
      );
    } else {
      _textBlockController = TextEditingController();
    }

    // Initialize item controllers
    _updateItemControllers();
  }

  void _updateControllers() {
    // Update title controller
    String title = '';
    switch (widget.block.type) {
      case ContentBlockType.todo:
        title = (widget.block as TodoBlockModel).title;
        break;
      case ContentBlockType.event:
        title = (widget.block as EventBlockModel).title;
        break;
      case ContentBlockType.list:
        title = (widget.block as ListBlockModel).title;
        break;
      case ContentBlockType.text:
        title = (widget.block as TextBlockModel).title;
        break;
    }

    if (_titleController.text != title) {
      final selection = _titleController.selection;
      _titleController.text = title;
      if (selection.isValid && selection.end <= title.length) {
        _titleController.selection = selection;
      }
    }

    // Update text block controller
    if (widget.block.type == ContentBlockType.text) {
      final content = (widget.block as TextBlockModel).content;
      if (_textBlockController.text != content) {
        final selection = _textBlockController.selection;
        _textBlockController.text = content;
        if (selection.isValid && selection.end <= content.length) {
          _textBlockController.selection = selection;
        }
      }
    }

    // Update item controllers
    _updateItemControllers();
  }

  void _updateItemControllers() {
    switch (widget.block.type) {
      case ContentBlockType.todo:
        final block = widget.block as TodoBlockModel;
        // Clean up old controllers
        final oldIds = _todoControllers.keys.toSet();
        final newIds = block.items.map((item) => item.id).toSet();
        for (final id in oldIds.difference(newIds)) {
          _todoControllers[id]?.dispose();
          _todoControllers.remove(id);
        }
        // Create new controllers
        for (final item in block.items) {
          if (!_todoControllers.containsKey(item.id)) {
            _todoControllers[item.id] = TextEditingController(text: item.text);
          } else if (_todoControllers[item.id]!.text != item.text) {
            final selection = _todoControllers[item.id]!.selection;
            _todoControllers[item.id]!.text = item.text;
            if (selection.isValid && selection.end <= item.text.length) {
              _todoControllers[item.id]!.selection = selection;
            }
          }
        }
        break;
      case ContentBlockType.event:
        final block = widget.block as EventBlockModel;
        // Clean up old controllers
        final oldIds = _eventControllers.keys.toSet();
        final newIds = block.events.map((event) => event.id).toSet();
        for (final id in oldIds.difference(newIds)) {
          _eventControllers[id]?.dispose();
          _eventControllers.remove(id);
        }
        // Create new controllers
        for (final event in block.events) {
          if (!_eventControllers.containsKey(event.id)) {
            _eventControllers[event.id] = TextEditingController(
              text: event.title,
            );
          } else if (_eventControllers[event.id]!.text != event.title) {
            final selection = _eventControllers[event.id]!.selection;
            _eventControllers[event.id]!.text = event.title;
            if (selection.isValid && selection.end <= event.title.length) {
              _eventControllers[event.id]!.selection = selection;
            }
          }
        }
        break;
      case ContentBlockType.list:
        final block = widget.block as ListBlockModel;
        // Clean up old controllers
        final oldIndices = _listControllers.keys.toSet();
        final newIndices = List.generate(
          block.items.length,
          (index) => index,
        ).toSet();
        for (final index in oldIndices.difference(newIndices)) {
          _listControllers[index]?.dispose();
          _listControllers.remove(index);
        }
        // Create new controllers
        for (int i = 0; i < block.items.length; i++) {
          if (!_listControllers.containsKey(i)) {
            _listControllers[i] = TextEditingController(text: block.items[i]);
          } else if (_listControllers[i]!.text != block.items[i]) {
            final selection = _listControllers[i]!.selection;
            _listControllers[i]!.text = block.items[i];
            if (selection.isValid && selection.end <= block.items[i].length) {
              _listControllers[i]!.selection = selection;
            }
          }
        }
        break;
      case ContentBlockType.text:
        // Already handled above
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Block header with drag handle and delete button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drag handle (visible on hover or always on touch devices, only in edit mode)
                if (widget.isEditing)
                  AnimatedOpacity(
                    opacity: (_isHovered || _isTouchDevice) ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: ReorderableDragStartListener(
                      index: _getBlockIndex(),
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.drag_indicator,
                          size: 16,
                          color: AppTheme.getTextSecondary(context),
                        ),
                      ),
                    ),
                  ),

                // Block type icon (hide for text blocks in view mode)
                if (widget.isEditing ||
                    widget.block.type != ContentBlockType.text) ...[
                  Icon(
                    _getBlockIcon(),
                    size: 16,
                    color: AppTheme.getTextSecondary(context),
                  ),
                  const SizedBox(width: 8),
                ],

                // Block title (editable in edit mode, read-only in view mode)
                Expanded(child: _buildBlockTitle()),

                // Delete button (visible on hover or always on touch devices, only in edit mode)
                if (widget.isEditing)
                  AnimatedOpacity(
                    opacity: (_isHovered || _isTouchDevice) ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      color: AppTheme.getTextSecondary(context),
                      onPressed: widget.onDelete,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: _isTouchDevice
                            ? 32
                            : 24, // Larger touch target on touch devices
                        minHeight: _isTouchDevice ? 32 : 24,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Block content
            Padding(
              padding: EdgeInsets.only(left: _getContentPadding()),
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockTitle() {
    if (widget.isEditing) {
      return TextField(
        controller: _titleController,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          hintText: 'Untitled',
          hintStyle: TextStyle(color: AppTheme.getTextSecondary(context)),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          switch (widget.block.type) {
            case ContentBlockType.todo:
              widget.onUpdate(
                (widget.block as TodoBlockModel).copyWith(title: value),
              );
              break;
            case ContentBlockType.event:
              widget.onUpdate(
                (widget.block as EventBlockModel).copyWith(title: value),
              );
              break;
            case ContentBlockType.list:
              widget.onUpdate(
                (widget.block as ListBlockModel).copyWith(title: value),
              );
              break;
            case ContentBlockType.text:
              widget.onUpdate(
                (widget.block as TextBlockModel).copyWith(title: value),
              );
              break;
          }
        },
      );
    } else {
      // View mode - show title as text
      String title = '';
      switch (widget.block.type) {
        case ContentBlockType.todo:
          title = (widget.block as TodoBlockModel).title;
          break;
        case ContentBlockType.event:
          title = (widget.block as EventBlockModel).title;
          break;
        case ContentBlockType.list:
          title = (widget.block as ListBlockModel).title;
          break;
        case ContentBlockType.text:
          title = (widget.block as TextBlockModel).title;
          break;
      }

      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: widget.block.type == ContentBlockType.text ? 4.0 : 8.0,
        ),
        child: Text(
          title.isEmpty ? 'Untitled' : title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }
  }

  Widget _buildContent() {
    switch (widget.block.type) {
      case ContentBlockType.todo:
        return _buildTodoBlock(widget.block as TodoBlockModel);
      case ContentBlockType.event:
        return _buildEventBlock(widget.block as EventBlockModel);
      case ContentBlockType.list:
        return _buildListBlock(widget.block as ListBlockModel);
      case ContentBlockType.text:
        return _buildTextBlock(widget.block as TextBlockModel);
    }
  }

  Widget _buildTodoBlock(TodoBlockModel block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Todo items
        ...block.items.map((todo) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                ),
                const SizedBox(width: 12),

                // Todo content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Todo title with priority indicator
                      Row(
                        children: [
                          // Priority indicator
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8, top: 3),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(todo.priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: widget.isEditing
                                ? TextField(
                                    controller: _todoControllers[todo.id],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: todo.isCompleted
                                          ? AppTheme.getTextSecondary(context)
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      decoration: todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      height: 1.4,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      filled: false,
                                      hintText: 'To-do',
                                      hintStyle: TextStyle(
                                        color: AppTheme.getTextSecondary(
                                          context,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                    ),
                                    maxLines: null,
                                    onChanged: (value) {
                                      final updatedTodo = todo.copyWith(
                                        text: value,
                                      );
                                      final updatedItems = block.items.map((
                                        item,
                                      ) {
                                        return item.id == todo.id
                                            ? updatedTodo
                                            : item;
                                      }).toList();
                                      widget.onUpdate(
                                        block.copyWith(items: updatedItems),
                                      );
                                    },
                                  )
                                : Text(
                                    todo.text.isEmpty ? 'To-do' : todo.text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: todo.isCompleted
                                          ? AppTheme.getTextSecondary(context)
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      decoration: todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      height: 1.4,
                                    ),
                                  ),
                          ),
                        ],
                      ),

                      // Description
                      if (todo.description?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 16),
                          child: Text(
                            todo.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.getTextSecondary(context),
                              height: 1.3,
                            ),
                          ),
                        ),

                      // Metadata row
                      if (todo.assignees.isNotEmpty ||
                          todo.dueDate != null ||
                          todo.tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              // Assignees
                              if (todo.assignees.isNotEmpty)
                                _buildAssigneesChip(todo.assignees),

                              // Due date
                              if (todo.dueDate != null)
                                _buildDueDateChip(todo.dueDate!),

                              // Tags
                              ...todo.tags.map((tag) => _buildTagChip(tag)),
                            ],
                          ),
                        ),

                      // Quick actions row (only in edit mode)
                      if (widget.isEditing)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 16),
                          child: Row(
                            children: [
                              // Edit button
                              GestureDetector(
                                onTap: () => _editTask(todo, block),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 12,
                                        color: AppTheme.getTextSecondary(
                                          context,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.getTextSecondary(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Quick due date button
                              if (todo.dueDate == null)
                                GestureDetector(
                                  onTap: () => _quickSetDueDate(todo, block),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 12,
                                          color: AppTheme.getTextSecondary(
                                            context,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Set Due Date',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.getTextSecondary(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Delete todo button (only in edit mode)
                if (widget.isEditing && (_isHovered || _isTouchDevice))
                  IconButton(
                    icon: const Icon(Icons.close, size: 14),
                    color: AppTheme.getTextSecondary(context),
                    onPressed: () {
                      final updatedItems = block.items
                          .where((item) => item.id != todo.id)
                          .toList();
                      widget.onUpdate(block.copyWith(items: updatedItems));
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: _isTouchDevice ? 28 : 20,
                      minHeight: _isTouchDevice ? 28 : 20,
                    ),
                  ),
              ],
            ),
          );
        }),

        // Add new todo item (only in edit mode)
        if (widget.isEditing)
          TextButton.icon(
            onPressed: () {
              final newTodo = TodoItem(text: '');
              final updatedItems = [...block.items, newTodo];
              widget.onUpdate(block.copyWith(items: updatedItems));
            },
            icon: Icon(
              Icons.add,
              size: 16,
              color: AppTheme.getTextSecondary(context),
            ),
            label: Text(
              'Add a to-do',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getTextSecondary(context),
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              minimumSize: Size.zero,
            ),
          ),
      ],
    );
  }

  Widget _buildEventBlock(EventBlockModel block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event items
        ...block.events.map((event) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time indicator
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 8),
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
                      widget.isEditing
                          ? TextField(
                              controller: _eventControllers[event.id],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.4,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                hintText: 'Event title',
                                hintStyle: TextStyle(
                                  color: AppTheme.getTextSecondary(context),
                                ),
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (value) {
                                final updatedEvent = event.copyWith(
                                  title: value,
                                );
                                final updatedEvents = block.events.map((item) {
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
                              event.title.isEmpty ? 'Event title' : event.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.4,
                              ),
                            ),

                      const SizedBox(height: 6),

                      // Event time range
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 12,
                            color: AppTheme.getTextSecondary(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatEventTime(event),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.getTextSecondary(context),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),

                      // Event description
                      if (event.description?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            event.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.getTextSecondary(context),
                              height: 1.3,
                            ),
                          ),
                        ),

                      // Location
                      if (event.location?.physical?.isNotEmpty == true ||
                          event.location?.virtual?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (event.location?.physical?.isNotEmpty == true)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: AppTheme.getTextSecondary(context),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        event.location!.physical!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.getTextSecondary(
                                            context,
                                          ),
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (event.location?.virtual?.isNotEmpty == true)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        event.location?.physical?.isNotEmpty ==
                                            true
                                        ? 4
                                        : 0,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.videocam,
                                        size: 12,
                                        color: AppTheme.getTextSecondary(
                                          context,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          event.location!.virtual!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF3B82F6),
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                      // RSVP Section
                      if (event.requiresRSVP && event.rsvpResponses.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RSVP Responses:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.getTextSecondary(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: event.rsvpResponses.map((response) {
                                  return _buildRSVPChip(response);
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                      // Quick actions row for events (only in edit mode)
                      if (widget.isEditing)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              // Edit button
                              GestureDetector(
                                onTap: () => _editEvent(event, block),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 12,
                                        color: AppTheme.getTextSecondary(
                                          context,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.getTextSecondary(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Delete event button (only in edit mode)
                if (widget.isEditing && (_isHovered || _isTouchDevice))
                  IconButton(
                    icon: const Icon(Icons.close, size: 14),
                    color: AppTheme.getTextSecondary(context),
                    onPressed: () {
                      final updatedEvents = block.events
                          .where((item) => item.id != event.id)
                          .toList();
                      widget.onUpdate(block.copyWith(events: updatedEvents));
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: _isTouchDevice ? 28 : 20,
                      minHeight: _isTouchDevice ? 28 : 20,
                    ),
                  ),
              ],
            ),
          );
        }),

        // Add new event (only in edit mode)
        if (widget.isEditing)
          TextButton.icon(
            onPressed: () {
              final newEvent = EventItem(title: '', startTime: DateTime.now());
              final updatedEvents = [...block.events, newEvent];
              widget.onUpdate(block.copyWith(events: updatedEvents));
            },
            icon: Icon(
              Icons.add,
              size: 16,
              color: AppTheme.getTextSecondary(context),
            ),
            label: Text(
              'Add an event',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getTextSecondary(context),
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              minimumSize: Size.zero,
            ),
          ),
      ],
    );
  }

  Widget _buildListBlock(ListBlockModel block) {
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
                  margin: const EdgeInsets.only(
                    top: 9,
                  ), // Better alignment with text
                  decoration: BoxDecoration(
                    color: AppTheme.getTextSecondary(context),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // List item text
                Expanded(
                  child: widget.isEditing
                      ? TextField(
                          controller: _listControllers[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.4, // Better line height
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            hintText: 'List item',
                            hintStyle: TextStyle(
                              color: AppTheme.getTextSecondary(context),
                            ),
                            contentPadding: EdgeInsets.zero,
                            isDense: true, // Reduce padding
                          ),
                          maxLines: null,
                          onChanged: (value) {
                            final updatedItems = [...block.items];
                            updatedItems[index] = value;
                            widget.onUpdate(
                              block.copyWith(items: updatedItems),
                            );
                          },
                        )
                      : Text(
                          item.isEmpty ? 'List item' : item,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                ),

                // Delete list item button (only in edit mode)
                if (widget.isEditing && (_isHovered || _isTouchDevice))
                  IconButton(
                    icon: const Icon(Icons.close, size: 14),
                    color: AppTheme.getTextSecondary(context),
                    onPressed: () {
                      final updatedItems = [...block.items];
                      updatedItems.removeAt(index);
                      widget.onUpdate(block.copyWith(items: updatedItems));
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: _isTouchDevice ? 28 : 20,
                      minHeight: _isTouchDevice ? 28 : 20,
                    ),
                  ),
              ],
            ),
          );
        }),

        // Add new list item (only in edit mode)
        if (widget.isEditing)
          TextButton.icon(
            onPressed: () {
              final updatedItems = [...block.items, ''];
              widget.onUpdate(block.copyWith(items: updatedItems));
            },
            icon: Icon(
              Icons.add,
              size: 16,
              color: AppTheme.getTextSecondary(context),
            ),
            label: Text(
              'Add an item',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getTextSecondary(context),
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              minimumSize: Size.zero,
            ),
          ),
      ],
    );
  }

  Widget _buildTextBlock(TextBlockModel block) {
    if (widget.isEditing) {
      return TextField(
        controller: _textBlockController,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.6,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: AppTheme.getTextSecondary(context)),
          contentPadding: EdgeInsets.zero,
        ),
        maxLines: null,
        onChanged: (value) {
          widget.onUpdate(block.copyWith(content: value));
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          block.content.isEmpty ? '' : block.content,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.6,
          ),
        ),
      );
    }
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

  int _getBlockIndex() {
    return widget.blockIndex;
  }

  double _getContentPadding() {
    // Text blocks in view mode don't have icons, so they need less padding
    if (widget.block.type == ContentBlockType.text && !widget.isEditing) {
      return 0; // No padding for text blocks in view mode
    }
    // Other blocks or text blocks in edit mode get normal padding
    return _isTouchDevice ? 20 : 28;
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return const Color(0xFF10B981); // Green
      case TodoPriority.medium:
        return const Color(0xFF3B82F6); // Blue
      case TodoPriority.high:
        return const Color(0xFFF59E0B); // Orange
      case TodoPriority.urgent:
        return const Color(0xFFEF4444); // Red
    }
  }

  Widget _buildAssigneesChip(List<String> assignees) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person,
            size: 10,
            color: AppTheme.getTextSecondary(context),
          ),
          const SizedBox(width: 4),
          Text(
            assignees.length == 1
                ? assignees.first
                : '${assignees.length} people',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateChip(DateTime dueDate) {
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(now);
    final isToday =
        dueDate.day == now.day &&
        dueDate.month == now.month &&
        dueDate.year == now.year;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;

    if (isOverdue) {
      backgroundColor = isDark
          ? const Color(0xFF4A1F1F)
          : const Color(0xFFFEE2E2);
      textColor = isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
    } else if (isToday) {
      backgroundColor = isDark
          ? const Color(0xFF4A3A1F)
          : const Color(0xFFFEF3C7);
      textColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);
    } else {
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      textColor = AppTheme.getTextSecondary(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 10, color: textColor),
          const SizedBox(width: 4),
          Text(
            _formatDueDate(dueDate),
            style: TextStyle(fontSize: 10, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF3B3B7A) // Dark purple for dark mode
            : const Color(0xFFEDE9FE), // Light purple for light mode
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '#$tag',
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFB8A9FF) // Light purple text for dark mode
              : const Color(0xFF7C3AED), // Dark purple text for light mode
        ),
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDay == today) {
      return 'Today';
    } else if (dueDay == tomorrow) {
      return 'Tomorrow';
    } else if (dueDay.isBefore(today)) {
      return 'Overdue';
    } else {
      return DateFormat('MMM dd').format(dueDate);
    }
  }

  String _formatEventTime(EventItem event) {
    final startFormat = DateFormat('MMM dd, yyyy • h:mm a');
    final endFormat = DateFormat('h:mm a');

    if (event.endTime != null) {
      final isSameDay =
          event.startTime.day == event.endTime!.day &&
          event.startTime.month == event.endTime!.month &&
          event.startTime.year == event.endTime!.year;

      if (isSameDay) {
        return '${startFormat.format(event.startTime)} - ${endFormat.format(event.endTime!)}';
      } else {
        return '${startFormat.format(event.startTime)} - ${startFormat.format(event.endTime!)}';
      }
    } else {
      return startFormat.format(event.startTime);
    }
  }

  Widget _buildRSVPChip(RSVPResponse response) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (response.status) {
      case RSVPStatus.yes:
        backgroundColor = isDark
            ? const Color(0xFF1F4A3C)
            : const Color(0xFFDCFCE7);
        textColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
        icon = Icons.check_circle;
        break;
      case RSVPStatus.no:
        backgroundColor = isDark
            ? const Color(0xFF4A1F1F)
            : const Color(0xFFFEE2E2);
        textColor = isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
        icon = Icons.cancel;
        break;
      case RSVPStatus.maybe:
        backgroundColor = isDark
            ? const Color(0xFF4A3A1F)
            : const Color(0xFFFEF3C7);
        textColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);
        icon = Icons.help_outline;
        break;
      case RSVPStatus.pending:
        backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        textColor = AppTheme.getTextSecondary(context);
        icon = Icons.schedule;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: textColor),
          const SizedBox(width: 4),
          Text(
            response.userName,
            style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _editTask(TodoItem task, TodoBlockModel block) {
    TaskEditorBottomSheet.show(context, task, (updatedTask) {
      final updatedItems = block.items.map((item) {
        return item.id == task.id ? updatedTask : item;
      }).toList();
      widget.onUpdate(block.copyWith(items: updatedItems));
    });
  }

  void _quickSetDueDate(TodoItem task, TodoBlockModel block) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((selectedDate) {
      if (selectedDate != null) {
        final updatedTask = task.copyWith(dueDate: selectedDate);
        final updatedItems = block.items.map((item) {
          return item.id == task.id ? updatedTask : item;
        }).toList();
        widget.onUpdate(block.copyWith(items: updatedItems));
      }
    });
  }

  void _editEvent(EventItem event, EventBlockModel block) {
    EventEditorBottomSheet.show(context, event, (updatedEvent) {
      final updatedEvents = block.events.map((item) {
        return item.id == event.id ? updatedEvent : item;
      }).toList();
      widget.onUpdate(block.copyWith(events: updatedEvents));
    });
  }
}
