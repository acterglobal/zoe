import 'package:flutter/material.dart';

class MaxWidthWidget extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  final bool isScrollable;
  final EdgeInsets? padding;

  const MaxWidthWidget({
    super.key,
    required this.child,
    this.alignment = Alignment.center,
    this.isScrollable = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(alignment: alignment, child: _buildContentWidget());
  }

  Widget _buildContentWidget() {
    return isScrollable
        ? SingleChildScrollView(child: _buildChildWidget())
        : _buildChildWidget();
  }

  Widget _buildChildWidget() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: padding,
      child: child,
    );
  }
}
