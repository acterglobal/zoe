import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/users/models/user_model.dart';

class ZoeUserAvatarWidget extends StatelessWidget {
  final UserModel user;
  final double? size;
  final double? fontSize;

  const ZoeUserAvatarWidget({super.key, required this.user, this.size, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);
    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(
        color: randomColor.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: randomColor, width: 0.3),
      ),
      child: Center(
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: randomColor,
            fontSize: fontSize ?? 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
