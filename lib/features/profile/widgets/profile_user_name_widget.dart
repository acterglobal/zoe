import 'package:flutter/material.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ProfileUserNameWidget extends StatefulWidget {
  final TextEditingController controller;

  const ProfileUserNameWidget({super.key, required this.controller});

  @override
  State<ProfileUserNameWidget> createState() => _ProfileUserNameWidgetState();
}

class _ProfileUserNameWidgetState extends State<ProfileUserNameWidget> {
  String? errorText;

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
          autofocus: false,
        ),
      ],
    );
  }

  void _validateName() {
    final name = widget.controller.text.trim();
    if (ValidationUtils.isValidName(name)) {
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
