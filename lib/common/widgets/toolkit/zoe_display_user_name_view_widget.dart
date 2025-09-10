import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/users/models/user_model.dart';

class ZoeDisplayUserNameViewWidget extends StatelessWidget {
  final UserModel user;
  final int? maxUsers;

  const ZoeDisplayUserNameViewWidget({
    super.key,
    required this.user,
    this.maxUsers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final randomColor = CommonUtils().getRandomColorFromName(user.name);

     return ConstrainedBox(
       constraints: const BoxConstraints(maxWidth: 120),
       child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
         margin: const EdgeInsets.only(right: 4),
         decoration: BoxDecoration(
           color: randomColor.withValues(alpha: 0.1),
           borderRadius: BorderRadius.circular(4),
           border: Border.all(color: randomColor.withValues(alpha: 0.3), width: 1),
         ),
         child: Text(
           user.name,
           overflow: TextOverflow.ellipsis,
           style: theme.textTheme.bodyMedium?.copyWith(
             color: randomColor.withValues(alpha: 0.6),
             fontSize: 10,
             fontWeight: FontWeight.w600,
           ),
         ),
       ),
     );
  }
}
