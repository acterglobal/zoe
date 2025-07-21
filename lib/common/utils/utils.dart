import 'package:flutter/material.dart';

const List<TargetPlatform> desktopPlatforms = [
  TargetPlatform.macOS,
  TargetPlatform.linux,
  TargetPlatform.windows,
];

bool isDesktop(BuildContext context) =>
    desktopPlatforms.contains(Theme.of(context).platform);