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
    this.maxUsers = 5,
    this.spacing = -6,
    this.avatarSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    final displayCount = users.length > maxUsers ? maxUsers -1 : users.length;
    final remainingCount = users.length > maxUsers ? users.length - (maxUsers - 1) : 0;

    final totalWidth = displayCount * (avatarSize + spacing) + (remainingCount > 0 ? avatarSize : 0);
    
    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Display user avatars
          for (var i = 0; i < displayCount; i++)
            Positioned(
              left: i * (avatarSize + spacing),
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: ZoeUserAvatarWidget(
                  user: users[i],
                ),
              ),
            ),

          // Display +X indicator if there are more users
          if (remainingCount > 0)
            Positioned(
              left: (displayCount) * (avatarSize + spacing) + 5,
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
