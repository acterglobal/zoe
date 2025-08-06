import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/users/providers/user_providers.dart';

class UserWidget extends ConsumerWidget {
  final String userId;
  final Widget? actionWidget;
  final Function(String userId)? onTapUser;
  const UserWidget({
    super.key,
    required this.userId,
    this.actionWidget,
    this.onTapUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getUserByIdProvider(userId));
    if (user == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (onTapUser != null) {
          onTapUser!(userId);
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
          if (actionWidget != null)
              actionWidget ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
