import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/models/content_block.dart';

class TaskEditorBottomSheet extends StatefulWidget {
  final TodoItem task;
  final Function(TodoItem) onSave;

  const TaskEditorBottomSheet({
    super.key,
    required this.task,
    required this.onSave,
  });

  static void show(
    BuildContext context,
    TodoItem task,
    Function(TodoItem) onSave,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskEditorBottomSheet(task: task, onSave: onSave),
    );
  }

  @override
  State<TaskEditorBottomSheet> createState() => _TaskEditorBottomSheetState();
}

class _TaskEditorBottomSheetState extends State<TaskEditorBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assigneeController;
  late TextEditingController _tagController;

  late TodoPriority _selectedPriority;
  late List<String> _assignees;
  late List<String> _tags;
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.text);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
    _assigneeController = TextEditingController();
    _tagController = TextEditingController();

    _selectedPriority = widget.task.priority;
    _assignees = List.from(widget.task.assignees);
    _tags = List.from(widget.task.tags);
    _selectedDueDate = widget.task.dueDate;
    _selectedTime = widget.task.dueDate != null
        ? TimeOfDay.fromDateTime(widget.task.dueDate!)
        : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Stack(
      children: [
        Container(
          height: screenHeight * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      'Edit Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: keyboardHeight + 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Title
                      _buildSectionTitle('Task Title'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _titleController,
                        decoration: _buildInputDecoration('Enter task title'),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      _buildSectionTitle('Description'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        decoration: _buildInputDecoration(
                          'Add a description...',
                        ),
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // Priority
                      _buildSectionTitle('Priority'),
                      const SizedBox(height: 8),
                      _buildPrioritySelector(),
                      const SizedBox(height: 20),

                      // Due Date
                      _buildSectionTitle('Due Date'),
                      const SizedBox(height: 8),
                      _buildDueDateSelector(),
                      const SizedBox(height: 20),

                      // Assignees
                      _buildSectionTitle('Assignees'),
                      const SizedBox(height: 8),
                      _buildAssigneesSection(),
                      const SizedBox(height: 20),

                      // Tags
                      _buildSectionTitle('Tags'),
                      const SizedBox(height: 8),
                      _buildTagsSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Floating Action Button
        _buildFloatingActionButton(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildPrioritySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TodoPriority.values.map((priority) {
        final isSelected = _selectedPriority == priority;
        return GestureDetector(
          onTap: () => setState(() => _selectedPriority = priority),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? _getPriorityColor(priority).withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? _getPriorityColor(priority)
                    : const Color(0xFFE5E7EB),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(priority),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _getPriorityName(priority),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? _getPriorityColor(priority)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDueDateSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedDueDate != null
                              ? DateFormat(
                                  'MMM dd, yyyy',
                                ).format(_selectedDueDate!)
                              : 'Select date',
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedDueDate != null
                                ? const Color(0xFF374151)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_selectedDueDate != null) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => setState(() {
                  _selectedDueDate = null;
                  _selectedTime = null;
                }),
                icon: const Icon(Icons.clear, size: 16),
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ],
        ),
        if (_selectedDueDate != null) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _selectTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select time (optional)',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedTime != null
                          ? const Color(0xFF374151)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAssigneesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add assignee input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _assigneeController,
                decoration: _buildInputDecoration('Enter assignee name'),
                onSubmitted: _addAssignee,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _addAssignee(_assigneeController.text),
              icon: const Icon(Icons.add),
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Assignees list
        if (_assignees.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _assignees.map((assignee) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 12,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      assignee,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeAssignee(assignee),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add tag input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: _buildInputDecoration('Enter tag name'),
                onSubmitted: _addTag,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _addTag(_tagController.text),
              icon: const Icon(Icons.add),
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Tags list
        if (_tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeTag(tag),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // Floating Action Button for Save
  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: _saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return const Color(0xFF10B981);
      case TodoPriority.medium:
        return const Color(0xFF3B82F6);
      case TodoPriority.high:
        return const Color(0xFFF59E0B);
      case TodoPriority.urgent:
        return const Color(0xFFEF4444);
    }
  }

  String _getPriorityName(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
      case TodoPriority.urgent:
        return 'Urgent';
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addAssignee(String assignee) {
    if (assignee.trim().isNotEmpty && !_assignees.contains(assignee.trim())) {
      setState(() {
        _assignees.add(assignee.trim());
        _assigneeController.clear();
      });
    }
  }

  void _removeAssignee(String assignee) {
    setState(() {
      _assignees.remove(assignee);
    });
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveTask() {
    DateTime? finalDueDate;
    if (_selectedDueDate != null) {
      if (_selectedTime != null) {
        finalDueDate = DateTime(
          _selectedDueDate!.year,
          _selectedDueDate!.month,
          _selectedDueDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
      } else {
        finalDueDate = _selectedDueDate;
      }
    }

    final updatedTask = widget.task.copyWith(
      text: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      priority: _selectedPriority,
      dueDate: finalDueDate,
      assignees: _assignees,
      tags: _tags,
    );

    widget.onSave(updatedTask);
    Navigator.of(context).pop();
  }
}
