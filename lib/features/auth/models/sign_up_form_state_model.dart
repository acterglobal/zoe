import 'package:flutter/material.dart';

/// State model for signup form
class SignupFormStateModel {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? errorMessage;

  const SignupFormStateModel({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.firstNameController,
    required this.lastNameController,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.errorMessage,
  });

  SignupFormStateModel copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? errorMessage,
  }) {
    return SignupFormStateModel(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController:
          confirmPasswordController ?? this.confirmPasswordController,
      firstNameController: firstNameController ?? this.firstNameController,
      lastNameController: lastNameController ?? this.lastNameController,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      errorMessage: errorMessage,
    );
  }

  /// Clear error message
  SignupFormStateModel clearError() {
    return copyWith(errorMessage: null);
  }
}
