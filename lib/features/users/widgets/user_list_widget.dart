import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/features/users/widgets/user_widget.dart';

class UserListWidget extends ConsumerWidget {
  final String sheetId;
  const UserListWidget({
    super.key,
    required this.sheetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(getUsersBySheetIdProvider(sheetId));
    if (users.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: UserWidget(
            key: ValueKey(user.id),
            userId: user.id,
          ),
        );
      },
    );
  }
}
