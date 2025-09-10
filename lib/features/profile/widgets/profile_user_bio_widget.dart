import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ProfileUserBioWidget extends ConsumerStatefulWidget {
  final bool isEditing;
  final TextEditingController controller;

  const ProfileUserBioWidget({
    super.key,
    required this.isEditing,
    required this.controller,
  });

  @override
  ConsumerState<ProfileUserBioWidget> createState() =>
      _ProfileUserBioWidgetState();
}

class _ProfileUserBioWidgetState extends ConsumerState<ProfileUserBioWidget> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        widget.controller.text = user.bio ?? '';
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
            Icon(Icons.description_outlined, size: 18),
            const SizedBox(width: 8),
            Text(
              L10n.of(context).userBio,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedTextField(
          controller: widget.controller,
          errorText: errorText,
          hintText: L10n.of(context).writeSomethingAboutYourself,
          onErrorChanged: (error) => setState(() => errorText = error),
          onSubmitted: () {},
          enabled: widget.isEditing,
          readOnly: !widget.isEditing,
          autofocus: widget.isEditing,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
