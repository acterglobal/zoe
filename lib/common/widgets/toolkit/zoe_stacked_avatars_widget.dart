import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

class ZoeStackedAvatarsWidget extends StatelessWidget {
  final List<UserModel> users;
  final int maxUsers;
  final double spacing;
  final double avatarSize;

  const ZoeStackedAvatarsWidget({
    super.key,
    required this.users,
    this.maxUsers = 3,
    this.spacing = -5,
    this.avatarSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    final displayCount = users.length.clamp(0, maxUsers);
    final remainingCount = max(users.length - displayCount, 0);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (var i = 0; i < displayCount; i++)
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerRight,
            children: [
              SizedBox(width: avatarSize - 4, height: avatarSize),
              Positioned(
                right: -4,
                child: ZoeUserAvatarWidget(
                  user: users[i],
                  showUserAvatar: true,
                ),
              ),
            ],
          ),

        if (remainingCount > 0)
          SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: Center(
              child: Text(
                '+$remainingCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
