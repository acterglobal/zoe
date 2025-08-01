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

    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(user.name), 
    );
  }
}