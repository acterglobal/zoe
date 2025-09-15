import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/users/models/user_model.dart';

class ZoeUserAvatarWidget extends StatelessWidget {
  final UserModel user;
  final bool showRemoveButton;
  final VoidCallback? onRemove;
  final bool showUserAvatar;
  final bool showUserName;
  final bool showUserNameWithAvatar;

  const ZoeUserAvatarWidget({
    super.key,
    required this.user,
    this.showRemoveButton = false,
    this.onRemove,
    this.showUserAvatar = false,
    this.showUserName = false,
    this.showUserNameWithAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);

    return showUserNameWithAvatar
        ? _buildShowUserNameWithAvatarWidget(context, randomColor)
        : showUserName
            ? _buildShowUserNameWidget(context, randomColor)
            : _buildShowUserAvatarWidget(context, randomColor);
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
          _buildShowUserAvatarWidget(context, randomColor),
          const SizedBox(width: 8),
          Text(
            user.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: randomColor,
              fontSize: 12,
            ),
          ),
          if (showRemoveButton && onRemove != null) ...[
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

  Widget _buildShowUserAvatarWidget(BuildContext context, Color randomColor) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: randomColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: randomColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
