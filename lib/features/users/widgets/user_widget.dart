import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ZoeUserChipWidget(user: user,type: ZoeUserChipType.userAvatarOnly,),
            const SizedBox(width: 8),
            Text(user.name, style: theme.textTheme.bodyMedium),
            const Spacer(),
            if (actionWidget != null) ...[
              const SizedBox(width: 8),
              actionWidget ?? const SizedBox.shrink(),
            ],
          ],
        ),
      ),
    );
  }
}
