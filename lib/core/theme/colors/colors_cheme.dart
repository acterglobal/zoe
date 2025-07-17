import 'package:flutter/material.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';

final lightColorScheme = ColorScheme.light(
  primary: AppColors.primaryColor,
  secondary: AppColors.secondaryColor,
  surface: AppColors.lightSurface,
  onSurface: AppColors.lightOnSurface,
  onPrimary: AppColors.lightOnSurface,
  error: AppColors.errorColor,
  outline: AppColors.lightOnSurface.withValues(alpha: 0.1),
);

final darkColorScheme = ColorScheme.dark(
  primary: AppColors.primaryColor,
  secondary: AppColors.secondaryColor,
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkOnSurface,
  onPrimary: AppColors.darkOnSurface,
  error: AppColors.errorColor,
  outline: AppColors.darkOnSurface.withValues(alpha: 0.1),
);
