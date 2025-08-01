import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/features/users/widgets/user_widget.dart';

class UserListWidget extends ConsumerWidget {
  final String sheetId;
  const UserListWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(listOfUsersBySheetIdProvider(sheetId));
    if (users.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
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
    );
  }
}
