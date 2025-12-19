import 'package:flutter/material.dart';

enum LoadingIndicatorType { circular, linear }

class LoadingIndicatorWidget extends StatelessWidget {
  final LoadingIndicatorType type;
  final Color? backgroundColor;
  final double? size;

  const LoadingIndicatorWidget({
    super.key,
    this.size,
    this.backgroundColor,
    this.type = LoadingIndicatorType.linear,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      LoadingIndicatorType.circular => _buildCircularLoadingIndicator(),
      LoadingIndicatorType.linear => _buildLinearLoadingIndicator(),
    };
  }

  Widget _buildCircularLoadingIndicator() {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(backgroundColor: backgroundColor),
    );
  }

  Widget _buildLinearLoadingIndicator() {
    return SizedBox(
      width: double.infinity,
      height: size,
      child: LinearProgressIndicator(backgroundColor: backgroundColor),
    );
  }
}
