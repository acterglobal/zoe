import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/users/providers/user_providers.dart';

class UserWidget extends ConsumerWidget {
  final String userId;
  const UserWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getUserByIdProvider(userId));
    if (user == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          Text(user.name),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              ref.read(userListProvider.notifier).deleteUser(userId);
            },
            icon: Icon(Icons.delete_outline_outlined, size: 16, color: theme.colorScheme.error),
          ),
        ],
      ), 
    );
  }
}