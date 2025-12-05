import 'package:flutter/material.dart';

/// State model for signup form
class SignupFormStateModel {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nameController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? errorMessage;

  const SignupFormStateModel({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.errorMessage,
  });

  SignupFormStateModel copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    TextEditingController? nameController,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? errorMessage,
  }) {
    return SignupFormStateModel(
      emailController: emailController ?? this.emailController, 
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController:
          confirmPasswordController ?? this.confirmPasswordController,
      nameController: nameController ?? this.nameController,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Clear error message
  SignupFormStateModel clearError() {
    return SignupFormStateModel(
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      nameController: nameController,
      obscurePassword: obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword,
      errorMessage: null,
    );
  }
} 
