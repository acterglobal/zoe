import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/features/users/widgets/user_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class UserListWidget extends ConsumerWidget {
  final String sheetId;

  const UserListWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(listOfUsersBySheetIdProvider(sheetId));
    if (users.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  L10n.of(context).usersInSheet,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: UserWidget(key: ValueKey(user), userId: user),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
