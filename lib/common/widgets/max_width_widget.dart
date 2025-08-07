import 'package:flutter/material.dart';

class MaxWidthWidget extends StatelessWidget {
  final Widget child;
  final bool isScrollable;
  final EdgeInsets? padding;

  const MaxWidthWidget({
    super.key,
    required this.child,
    this.isScrollable = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final childWidget = Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: padding,
      child: child,
    );
    return isScrollable
        ? SingleChildScrollView(child: childWidget)
        : childWidget;
  }
}
