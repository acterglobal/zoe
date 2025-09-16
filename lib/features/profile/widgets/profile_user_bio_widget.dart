import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ProfileUserBioWidget extends StatefulWidget {
  final TextEditingController controller;

  const ProfileUserBioWidget({super.key, required this.controller});

  @override
  State<ProfileUserBioWidget> createState() =>
      _ProfileUserBioWidgetState();
}

class _ProfileUserBioWidgetState extends State<ProfileUserBioWidget> {

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
          hintText: L10n.of(context).writeSomethingAboutYourself,
          onErrorChanged: (error) => {},
          onSubmitted: () {},
          maxLines: 3,
          autofocus: false,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
