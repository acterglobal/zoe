import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_menu_providers.g.dart';

/// Provider for toggling content menu visibility
@riverpod
class ToggleContentMenu extends _$ToggleContentMenu {
  @override
  bool build() => false;
}

/// Provider for tracking edit state for specific content by parentId
@riverpod
class IsEditValue extends _$IsEditValue {
  @override
  bool build(String parentId) => false;
}