import 'package:flutter/material.dart';
import 'package:zoey/features/users/models/user_model.dart';

class TaskAssigneeAvatarWidget extends StatelessWidget {
  final UserModel user;

  const TaskAssigneeAvatarWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),
        ),
      ),
    );
  }
}