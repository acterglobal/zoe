import 'package:flutter/material.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/users/models/user_model.dart';

class ZoeUserAvatarWidget extends StatelessWidget {
  final UserModel user;

  const ZoeUserAvatarWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);
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
