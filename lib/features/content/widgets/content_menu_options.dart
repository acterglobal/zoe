import 'package:flutter/material.dart';

class ContentMenuOptions extends StatelessWidget {
  final VoidCallback onTapText;
  final VoidCallback onTapEvent;
  final VoidCallback onTapBulletedList;
  final VoidCallback onTapToDoList;

  const ContentMenuOptions({
    super.key,
    required this.onTapText,
    required this.onTapEvent,
    required this.onTapBulletedList,
    required this.onTapToDoList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          _buildAddContentOption(
            context,
            icon: Icons.text_fields,
            title: 'Text',
            description: 'Start writing with plain text',
            onTap: onTapText,
          ),

          _buildAddContentOption(
            context,
            icon: Icons.event_outlined,
            title: 'Event',
            description: 'Schedule and track events',
            onTap: onTapEvent,
          ),
          _buildAddContentOption(
            context,
            icon: Icons.list,
            title: 'Bulleted list',
            description: 'Create a simple bulleted list',
            onTap: onTapBulletedList,
          ),
          _buildAddContentOption(
            context,
            icon: Icons.check_box_outlined,
            title: 'To-do list',
            description: 'Track tasks with checkboxes',
            onTap: onTapToDoList,
          ),
        ],
      ),
    );
  }

  Widget _buildAddContentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: ListTile(
        leading: Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
