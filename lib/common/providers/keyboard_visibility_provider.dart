import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keyboard_visibility_provider.g.dart';

/// Provider for keyboard visibility state
@riverpod
Stream<bool> keyboardVisible(Ref ref) async* {
  final keyboardVisibilityController = KeyboardVisibilityController();
  yield keyboardVisibilityController.isVisible;

  await for (final keyboardState in keyboardVisibilityController.onChange) {
    yield keyboardState;
  }
}
