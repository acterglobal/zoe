import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/users/widgets/user_widget.dart';

class UserListWidget extends ConsumerWidget {
  final ProviderBase<List<String>> userIdList;
  final Widget? actionWidget;
  final Function(String userId)? onTapUser;
  final String title;

  const UserListWidget({
    super.key,
    required this.userIdList,
    this.actionWidget,
    this.onTapUser,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userIds = ref.watch(userIdList);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 5, top: 10, bottom: 10),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.people_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userIds.length,
            itemBuilder: (context, index) {
              final userId = userIds[index];
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                child: UserWidget(
                  key: ValueKey(userId),
                  userId: userId,
                  actionWidget: actionWidget,
                  onTapUser: onTapUser,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
