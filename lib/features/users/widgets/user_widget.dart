import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/users/providers/user_providers.dart';

class UserWidget extends ConsumerWidget {
  final String userId;
  final Widget? addUserActionWidget;
  final Function(String userId)? onUserSelected;
  const UserWidget({super.key, required this.userId, this.addUserActionWidget, this.onUserSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getUserByIdProvider(userId));
    if (user == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (onUserSelected != null) {
          onUserSelected!(userId);
          Navigator.of(context).pop();
        }
      },
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(user.name, style: theme.textTheme.bodyMedium),
          if (addUserActionWidget != null)
              addUserActionWidget ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
