import 'package:flutter/material.dart';

class MaxWidthWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const MaxWidthWidget({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: padding,
        child: child,
      ),
    );
  }
}
