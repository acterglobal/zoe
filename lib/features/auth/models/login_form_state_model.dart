import 'package:flutter/cupertino.dart';

/// State model for login form
class LoginFormStateModel {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final String? errorMessage;

  LoginFormStateModel({
    required this.emailController,
    required this.passwordController,
    this.obscurePassword = true,
    this.errorMessage,
  });

  LoginFormStateModel copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    bool? obscurePassword,
    String? errorMessage,
  }) {
    return LoginFormStateModel(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: errorMessage,
    );
  }

  /// Clear error message
  LoginFormStateModel clearError() {
    return copyWith(errorMessage: null);  
  }
}
