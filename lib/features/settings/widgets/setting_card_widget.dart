import 'package:flutter/material.dart';
import 'package:Zoe/common/widgets/glassy_container_widget.dart';

class SettingCardWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SettingCardWidget({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        GlassyContainer(child: Column(children: children)),
      ],
    );
  }
}
