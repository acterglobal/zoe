import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ProfileUserNameWidget extends ConsumerStatefulWidget {
  final bool isEditing;
  final TextEditingController controller;

  const ProfileUserNameWidget({
    super.key,
    required this.isEditing,
    required this.controller,
  });

  @override
  ConsumerState<ProfileUserNameWidget> createState() =>
      _ProfileUserNameWidgetState();
}

class _ProfileUserNameWidgetState extends ConsumerState<ProfileUserNameWidget> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        widget.controller.text = user.name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline_rounded, size: 18),
            const SizedBox(width: 8),
            Text(
              L10n.of(context).userName,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedTextField(
          controller: widget.controller,
          errorText: errorText,
          hintText: L10n.of(context).pleaseEnterAValidName,
          onErrorChanged: (error) => setState(() => errorText = error),
          onSubmitted: _validateName,
          enabled: widget.isEditing,
          readOnly: !widget.isEditing,
          autofocus: widget.isEditing,
        ),
      ],
    );
  }

  void _validateName() {
    final name = widget.controller.text.trim();
    if (CommonUtils.isValidName(name)) {
      setState(() {
        errorText = null;
      });
    } else {
      setState(() {
        errorText = L10n.of(context).nameCannotBeEmpty;
      });
    }
  }
}
