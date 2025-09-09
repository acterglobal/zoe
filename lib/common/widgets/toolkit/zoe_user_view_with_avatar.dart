import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

class ZoeUserViewWithAvatar extends StatelessWidget {
  final UserModel user;

  const ZoeUserViewWithAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final randomColor = CommonUtils().getRandomColorFromName(user.name);

    return GlassyContainer(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      borderRadius: BorderRadius.circular(8),
      borderOpacity: 0.08,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZoeUserAvatarWidget(user: user),
          const SizedBox(width: 5),
          Text(
            user.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: randomColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
