import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

class ZoeUserAvatarChipWidget extends StatelessWidget {
  final UserModel user;
  final bool showRemoveButton;
  final VoidCallback? onRemove;

  const ZoeUserAvatarChipWidget({
    super.key,
    required this.user,
    this.showRemoveButton = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final randomColor = CommonUtils().getRandomColorFromName(user.name);

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
}
