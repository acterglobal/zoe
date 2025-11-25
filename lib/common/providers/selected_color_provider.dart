import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';

part 'selected_color_provider.g.dart';

/// State class to hold selected primary and secondary colors
class SelectedColorState {
  final Color primaryColor;
  final Color secondaryColor;

  const SelectedColorState({
    required this.primaryColor,
    required this.secondaryColor,
  });

  SelectedColorState copyWith({Color? primaryColor, Color? secondaryColor}) {
    return SelectedColorState(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}

/// Provider for managing selected theme colors
@Riverpod(keepAlive: true)
class SelectedColor extends _$SelectedColor {
  @override
  SelectedColorState build() {
    // Initialize with default colors and load saved colors
    _loadColors();
    return SelectedColorState(
      primaryColor: iconPickerColors.first,
      secondaryColor: iconPickerColors[1],
    );
  }

  Future<void> _loadColors() async {
    final prefsService = ref.read(preferencesServiceProvider);
    final primaryColor = await prefsService.getPrimaryColor();
    final secondaryColor = await prefsService.getSecondaryColor();

    if (primaryColor != null || secondaryColor != null) {
      state = SelectedColorState(
        primaryColor: primaryColor ?? iconPickerColors.first,
        secondaryColor: secondaryColor ?? iconPickerColors[1],
      );
    }
  }

  Future<void> setPrimaryColor(Color color) async {
    state = state.copyWith(primaryColor: color);
    await ref.read(preferencesServiceProvider).setPrimaryColor(color);
  }

  Future<void> setSecondaryColor(Color color) async {
    state = state.copyWith(secondaryColor: color);
    await ref.read(preferencesServiceProvider).setSecondaryColor(color);
  }

  Future<void> setColors({
    required Color primaryColor,
    required Color secondaryColor,
  }) async {
    state = SelectedColorState(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
    final prefsService = ref.read(preferencesServiceProvider);
    await prefsService.setPrimaryColor(primaryColor);
    await prefsService.setSecondaryColor(secondaryColor);
  }

  Future<void> clearColors() async {
    state = SelectedColorState(
      primaryColor: iconPickerColors.first,
      secondaryColor: iconPickerColors[1],
    );
    await ref.read(preferencesServiceProvider).clearThemeColors();
  }
}
