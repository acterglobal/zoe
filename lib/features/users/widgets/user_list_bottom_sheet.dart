import 'package:flutter/material.dart';
import 'package:zoey/features/users/widgets/user_list_widget.dart';

class UserListBottomSheet extends StatelessWidget {
  final String sheetId;
  final String title;

  const UserListBottomSheet({
    super.key,
    required this.sheetId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.people_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          UserListWidget(sheetId: sheetId),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Helper function to show the bottom sheet
void showUserListBottomSheet(
  BuildContext context,
  String sheetId,
  String title,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => UserListBottomSheet(
      sheetId: sheetId,
      title: title,
    ),
  );
} 