import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';

part 'selected_color_provider.g.dart';

/// Provider for managing selected color
@Riverpod(keepAlive: true)
class SelectedColor extends _$SelectedColor {
  @override
  Color build() {
    // Initialize with default color and load saved color
    _loadColor();
    return iconPickerColors.first;
  }

  Future<void> _loadColor() async {
    final prefsService = ref.read(preferencesServiceProvider);
    final savedColor = await prefsService.getPrimaryColor();

    if (savedColor != null) {
      state = savedColor;
    }
  }

  Future<void> setColor(Color color) async {
    state = color;
    await ref.read(preferencesServiceProvider).setPrimaryColor(color);
  }

  Future<void> clearColor() async {
    state = iconPickerColors.first;
    await ref
        .read(preferencesServiceProvider)
        .setPrimaryColor(iconPickerColors.first);
  }
}
