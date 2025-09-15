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
    this.spacing = -6,
    this.avatarSize = 20,
  });

  double _getPosition(int index) => index * (avatarSize + spacing);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    
    final displayCount = users.length.clamp(0, maxUsers);
    final remainingCount = max(users.length - displayCount, 0);
    final width = _getPosition(displayCount) + (remainingCount > 0 ? avatarSize + 5 : 0);

    return SizedBox(
      width: width,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Display user avatars
          for (var i = 0; i < displayCount; i++)
            Positioned(
              left: _getPosition(i),
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: ZoeUserAvatarWidget(user: users[i],showUserAvatar: true,),
              ),
            ),
          // Display +X indicator if there are more users
          if (remainingCount > 0)
            Positioned(
              left: _getPosition(displayCount) + 5,
              child: SizedBox(
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
            ),
        ],
      ),
    );
  }
}