import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keyboard_visbility_provider.g.dart';

/// Provider for keyboard visibility state
@riverpod
Stream<bool> keyboardVisible(Ref ref) async* {
  final keyboardVisibilityController = KeyboardVisibilityController();
  yield keyboardVisibilityController.isVisible;

  await for (final keyboardState in keyboardVisibilityController.onChange) {
    debugPrint('keyboard visibility changed to: $keyboardState');
    yield keyboardState;
  }
}
