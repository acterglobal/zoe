import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

enum ZoeUserChipType {
  userNameChip,
  userNameWithAvatarChip,
}

class ZoeUserChipWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onRemove;
  final ZoeUserChipType type;

  const ZoeUserChipWidget({
    super.key,
    required this.user,
    this.onRemove,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);

    return switch (type) {
      ZoeUserChipType.userNameChip => _buildShowUserNameWidget(context, randomColor),
      ZoeUserChipType.userNameWithAvatarChip => _buildShowUserNameWithAvatarWidget(context, randomColor),
    };
  }

  Widget _buildShowUserNameWithAvatarWidget(BuildContext context, Color randomColor) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: randomColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: randomColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZoeUserAvatarWidget(user: user),
          const SizedBox(width: 8),
          Text(
            user.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: randomColor,
              fontSize: 12,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              onPressed: onRemove,
              icon: Icon(
                Icons.close_rounded,
                size: 14,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShowUserNameWidget(BuildContext context, Color randomColor) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: randomColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: randomColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            user.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: randomColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}