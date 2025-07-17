import 'package:flutter/material.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';

final lightColorScheme = ColorScheme.light(
  primary: AppColors.primaryColor,
  secondary: AppColors.secondaryColor,
  surface: AppColors.lightSurface,
  onSurface: AppColors.lightOnSurface,
  onPrimary: AppColors.lightOnSurface,
  error: AppColors.errorColor,
);

final darkColorScheme = ColorScheme.dark(
  primary: AppColors.primaryColor,
  secondary: AppColors.secondaryColor,
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkOnSurface,
  onPrimary: AppColors.darkOnSurface,
  error: AppColors.errorColor,
);
