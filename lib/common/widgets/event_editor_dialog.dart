import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/content_block.dart';
import '../../core/theme/app_theme.dart';

class EventEditorBottomSheet extends StatefulWidget {
  final EventItem event;
  final Function(EventItem) onSave;

  const EventEditorBottomSheet({
    super.key,
    required this.event,
    required this.onSave,
  });

  static void show(
    BuildContext context,
    EventItem event,
    Function(EventItem) onSave,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          EventEditorBottomSheet(event: event, onSave: onSave),
    );
  }

  @override
  State<EventEditorBottomSheet> createState() => _EventEditorBottomSheetState();
}

class _EventEditorBottomSheetState extends State<EventEditorBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _physicalLocationController;
  late TextEditingController _virtualLocationController;

  late DateTime _startDate;
  late TimeOfDay _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  late bool _isAllDay;
  late bool _requiresRSVP;
  late List<RSVPResponse> _rsvpResponses;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(
      text: widget.event.description ?? '',
    );
    _physicalLocationController = TextEditingController(
      text: widget.event.location?.physical ?? '',
    );
    _virtualLocationController = TextEditingController(
      text: widget.event.location?.virtual ?? '',
    );

    _startDate = DateTime(
      widget.event.startTime.year,
      widget.event.startTime.month,
      widget.event.startTime.day,
    );
    _startTime = TimeOfDay.fromDateTime(widget.event.startTime);

    if (widget.event.endTime != null) {
      _endDate = DateTime(
        widget.event.endTime!.year,
        widget.event.endTime!.month,
        widget.event.endTime!.day,
      );
      _endTime = TimeOfDay.fromDateTime(widget.event.endTime!);
    }

    _isAllDay = widget.event.isAllDay;
    _requiresRSVP = widget.event.requiresRSVP;
    _rsvpResponses = List.from(widget.event.rsvpResponses);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _physicalLocationController.dispose();
    _virtualLocationController.dispose();
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
          decoration: BoxDecoration(
            color: AppTheme.getSurface(context),
            borderRadius: const BorderRadius.only(
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
                  color: AppTheme.getBorder(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Edit Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getTextPrimary(context),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: AppTheme.getTextSecondary(context),
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
                      // Event Title
                      _buildSectionTitle('Event Title'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _titleController,
                        decoration: _buildInputDecoration('Enter event title'),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.getTextPrimary(context),
                        ),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.getTextPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // All Day Toggle
                      Row(
                        children: [
                          Checkbox(
                            value: _isAllDay,
                            onChanged: (value) =>
                                setState(() => _isAllDay = value ?? false),
                            activeColor: const Color(0xFF8B5CF6),
                          ),
                          Text(
                            'All Day Event',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.getTextPrimary(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Start Date & Time
                      _buildSectionTitle('Start Date & Time'),
                      const SizedBox(height: 8),
                      _buildDateTimeSelector(
                        date: _startDate,
                        time: _startTime,
                        onDateChanged: (date) =>
                            setState(() => _startDate = date),
                        onTimeChanged: (time) =>
                            setState(() => _startTime = time),
                      ),
                      const SizedBox(height: 20),

                      // End Date & Time
                      _buildSectionTitle('End Date & Time (Optional)'),
                      const SizedBox(height: 8),
                      _buildDateTimeSelector(
                        date: _endDate,
                        time: _endTime,
                        onDateChanged: (date) =>
                            setState(() => _endDate = date),
                        onTimeChanged: (time) =>
                            setState(() => _endTime = time),
                        isOptional: true,
                      ),
                      const SizedBox(height: 20),

                      // Location
                      _buildSectionTitle('Location'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _physicalLocationController,
                        decoration: _buildInputDecoration(
                          'Physical location (e.g., Conference Room A)',
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.getTextPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _virtualLocationController,
                        decoration: _buildInputDecoration(
                          'Virtual location (e.g., Zoom link)',
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.getTextPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // RSVP Settings
                      Row(
                        children: [
                          Checkbox(
                            value: _requiresRSVP,
                            onChanged: (value) =>
                                setState(() => _requiresRSVP = value ?? false),
                            activeColor: const Color(0xFF8B5CF6),
                          ),
                          Text(
                            'Requires RSVP',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.getTextPrimary(context),
                            ),
                          ),
                        ],
                      ),
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
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.getTextPrimary(context),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.getHint(context)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppTheme.getBorderInput(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildDateTimeSelector({
    required DateTime? date,
    required TimeOfDay? time,
    required Function(DateTime) onDateChanged,
    required Function(TimeOfDay) onTimeChanged,
    bool isOptional = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(date ?? DateTime.now(), onDateChanged),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.getBorderInput(context)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.getTextSecondary(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date != null
                        ? DateFormat('MMM dd, yyyy').format(date)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      color: date != null
                          ? AppTheme.getTextPrimary(context)
                          : AppTheme.getHint(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!_isAllDay) ...[
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: date != null
                  ? () => _selectTime(time ?? TimeOfDay.now(), onTimeChanged)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.getBorder(context)),
                  borderRadius: BorderRadius.circular(8),
                  color: date == null
                      ? AppTheme.getSurfaceVariant(context)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: date != null
                          ? AppTheme.getTextSecondary(context)
                          : AppTheme.getHint(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time != null ? time.format(context) : 'Select time',
                      style: TextStyle(
                        fontSize: 14,
                        color: time != null
                            ? AppTheme.getTextPrimary(context)
                            : AppTheme.getHint(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (isOptional && date != null)
          IconButton(
            onPressed: () => setState(() {
              if (isOptional) {
                _endDate = null;
                _endTime = null;
              }
            }),
            icon: const Icon(Icons.clear, size: 16),
            color: AppTheme.getTextTertiary(context),
          ),
      ],
    );
  }

  Future<void> _selectDate(
    DateTime initialDate,
    Function(DateTime) onDateChanged,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  Future<void> _selectTime(
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeChanged,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  void _saveEvent() {
    DateTime finalStartTime;
    if (_isAllDay) {
      finalStartTime = _startDate;
    } else {
      finalStartTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
    }

    DateTime? finalEndTime;
    if (_endDate != null) {
      if (_isAllDay) {
        finalEndTime = _endDate!.add(const Duration(days: 1));
      } else if (_endTime != null) {
        finalEndTime = DateTime(
          _endDate!.year,
          _endDate!.month,
          _endDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }
    }

    EventLocation? location;
    if (_physicalLocationController.text.trim().isNotEmpty ||
        _virtualLocationController.text.trim().isNotEmpty) {
      location = EventLocation(
        physical: _physicalLocationController.text.trim().isEmpty
            ? null
            : _physicalLocationController.text.trim(),
        virtual: _virtualLocationController.text.trim().isEmpty
            ? null
            : _virtualLocationController.text.trim(),
      );
    }

    final updatedEvent = widget.event.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      startTime: finalStartTime,
      endTime: finalEndTime,
      isAllDay: _isAllDay,
      location: location,
      requiresRSVP: _requiresRSVP,
      rsvpResponses: _rsvpResponses,
    );

    widget.onSave(updatedEvent);
    Navigator.of(context).pop();
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: _saveEvent,
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
}
